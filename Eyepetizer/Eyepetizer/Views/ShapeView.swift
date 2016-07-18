//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class ShapeView: UIView {
    var font: UIFont?
    var fontSize: CGFloat?
    var pathLayer: CAShapeLayer?
    
    var animationString: String? {
        didSet {
            let pathLayer = setupDefaultLayer()
            self.pathLayer = pathLayer
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        
        font = UIFont.customFont_FZLTXIHJW()
        fontSize = SMALL_FONT_SIZE
    }
    
    private func setupDefaultLayer() -> CAShapeLayer {
        let letters = CGPathCreateMutable()
        let font = CTFontCreateWithName("HelveticaNeue-UltraLight", self.fontSize!, nil)
        let attrStr = NSAttributedString(string: animationString!, attributes: [kCTFontAttributeName as String : font])
        let line = CTLineCreateWithAttributedString(attrStr)
        let runArray = CTLineGetGlyphRuns(line)
        for runIndex in 0..<CFArrayGetCount(runArray) {
            let run = unsafeBitCast(CFArrayGetValueAtIndex(runArray, runIndex), CTRunRef.self)
            let runFont = unsafeBitCast(CFDictionaryGetValue(CTRunGetAttributes(run), unsafeBitCast(kCTFontAttributeName, UnsafePointer<Void>.self)), CTFontRef.self)
            for runGlyphIndex in 0..<CTRunGetGlyphCount(run) {
                let thisGlyphRange = CFRangeMake(runGlyphIndex, 1)
                var glyph: CGGlyph = CGGlyph()
                var position: CGPoint = CGPoint()
                CTRunGetGlyphs(run, thisGlyphRange, &glyph)
                CTRunGetPositions(run, thisGlyphRange, &position)
                let letter = CTFontCreatePathForGlyph(runFont, glyph, nil)
                var t = CGAffineTransformMakeTranslation(position.x, position.y)
                CGPathAddPath(letters, &t, letter);
            }
        }
        let path = UIBezierPath()
        path.moveToPoint(CGPointZero)
        path.appendPath(UIBezierPath(CGPath: letters))
        
        let pathLayer = CAShapeLayer()
        pathLayer.frame = bounds
        pathLayer.bounds = CGPathGetBoundingBox(path.CGPath)
        pathLayer.geometryFlipped = true
        pathLayer.path = path.CGPath
        pathLayer.strokeColor = UIColor.whiteColor().CGColor
        pathLayer.fillColor = nil
        pathLayer.strokeEnd = 1
        pathLayer.lineWidth = 1.0
        pathLayer.lineJoin = kCALineJoinBevel
        return pathLayer
    }
    
    func startAnimation() {
        layer.addSublayer(pathLayer!)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.duration = 0.5
        animation.removedOnCompletion = false
        pathLayer?.addAnimation(animation, forKey: animation.keyPath)
    }
    
    func stopAnimation() {
        pathLayer?.removeAllAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

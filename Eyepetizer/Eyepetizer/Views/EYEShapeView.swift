//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEShapeView: UIView {
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
        return CAShapeLayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

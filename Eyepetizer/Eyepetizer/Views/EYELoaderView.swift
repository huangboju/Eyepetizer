//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYELoaderView: UIView {
    /// 外面眼圈
    private lazy var eyeBackgroundLoaderView: UIImageView = {
        let eyeBackgroundLoaderView = APPImageView(image: R.image.ic_eye_black_outer())
        eyeBackgroundLoaderView.frame = CGRect(x: 0, y: 0, width: self.frame.height,height: self.frame.height)
        eyeBackgroundLoaderView.center = self.center
        eyeBackgroundLoaderView.layer.allowsEdgeAntialiasing = true
        return eyeBackgroundLoaderView;
    }()
    
    /// 中间眼球
    private lazy var eyeCenterLoaderView: UIImageView = {
        let eyeCenterLoaderView = APPImageView(image: R.image.ic_eye_black_inner())
        eyeCenterLoaderView.frame = CGRect(x: 0, y: 0, width: self.frame.height - MARGIN_5, height: self.frame.height - MARGIN_5)
        eyeCenterLoaderView.center = self.center
        //消除锯齿
        eyeCenterLoaderView.layer.allowsEdgeAntialiasing = true
        return eyeCenterLoaderView;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(eyeBackgroundLoaderView)
        addSubview(eyeCenterLoaderView)
    }
    
    func startLoadingAnimation() {
        hidden = false
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = M_PI * 2
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = HUGE
        animation.fillMode = kCAFillModeForwards
        animation.removedOnCompletion = false
        eyeCenterLoaderView.layer.addAnimation(animation, forKey: animation.keyPath)
    }
    
    func stopLoadingAnimation() {
        eyeCenterLoaderView.layer.removeAllAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

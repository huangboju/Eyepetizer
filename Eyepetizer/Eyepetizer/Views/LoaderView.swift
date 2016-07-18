//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class LoaderView: UIView {
    /// 外面眼圈
    private lazy var BackgroundLoaderView: UIImageView = {
        let BackgroundLoaderView = APPImageView(image: R.image.ic_eye_black_outer())
        BackgroundLoaderView.frame = CGRect(x: 0, y: 0, width: self.frame.height,height: self.frame.height)
        BackgroundLoaderView.center = self.center
        BackgroundLoaderView.layer.allowsEdgeAntialiasing = true
        return BackgroundLoaderView;
    }()
    
    /// 中间眼球
    private lazy var CenterLoaderView: UIImageView = {
        let CenterLoaderView = APPImageView(image: R.image.ic_eye_black_inner())
        CenterLoaderView.frame = CGRect(x: 0, y: 0, width: self.frame.height - MARGIN_5, height: self.frame.height - MARGIN_5)
        CenterLoaderView.center = self.center
        //消除锯齿
        CenterLoaderView.layer.allowsEdgeAntialiasing = true
        return CenterLoaderView;
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(BackgroundLoaderView)
        addSubview(CenterLoaderView)
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
        CenterLoaderView.layer.addAnimation(animation, forKey: animation.keyPath)
    }
    
    func stopLoadingAnimation() {
        CenterLoaderView.layer.removeAllAnimations()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

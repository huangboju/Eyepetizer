//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

extension UIBarButtonItem {
    class func barButtonItemWithImg(image: UIImage?, selectedImg: UIImage?, target: AnyObject!, action: Selector) -> UIBarButtonItem {
        let superview = UIView()
        superview.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        
        let imageView = APPImageView(image: image)
        imageView.frame = CGRect(x: -10, y: 0, width: 40, height: 40)
        superview.addSubview(imageView)
        
        let button = UIButton(type: .Custom)
        button.frame = CGRect(origin: CGPoint.zero, size: superview.frame.size)
        button.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        superview.addSubview(button)
        
        return UIBarButtonItem(customView: superview)
    }
}

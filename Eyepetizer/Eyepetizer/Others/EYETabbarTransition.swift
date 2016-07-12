//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

/// tabbar切换动画
class EYETabbarTransition: NSObject, UIViewControllerAnimatedTransitioning {
    let duration: NSTimeInterval = 0.4
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        let fromView = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)?.view
        let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view
        
        if let toView = toView {
            containerView?.addSubview(toView)
        }
        toView?.alpha = 0
        fromView?.alpha = 1
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: {
            toView?.alpha = 1
            fromView?.alpha = 0
            }) { (flag) in
                transitionContext.completeTransition(true)
        }
    }
}

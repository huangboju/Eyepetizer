//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEVideoDetailPushTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var toVC: EYEVideoDetailController?
    private var fromVC: EYEBaseViewController?
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView()
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as? EYEBaseViewController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as? EYEVideoDetailController
        self.fromVC = fromVC
        self.toVC = toVC
        
        let backgroundSnapshotView = fromVC?.view.snapshotViewAfterScreenUpdates(false)
        let snapshotView = fromVC?.selectCell?.backgroundImageView.snapshotViewAfterScreenUpdates(false)
        
        guard let rect = fromVC?.selectCell?.backgroundImageView.frame, selectCell = fromVC?.selectCell else {
            return
        }
        snapshotView?.frame = container?.convertRect(rect, toView: selectCell) ?? CGRect.zero
        fromVC?.selectCell?.backgroundImageView.hidden = true
        let coverView = fromVC?.selectCell?.coverButton.snapshotViewAfterScreenUpdates(false)
        guard let frame = fromVC?.selectCell?.coverButton.frame else {
            return
        }
        coverView?.frame = container?.convertRect(frame, fromView: selectCell) ?? CGRect.zero
        let blurImageView = UIImageView(image: fromVC!.selectCell!.backgroundImageView.image)
        blurImageView.frame = CGRect(x: 0, y: snapshotView?.frame.maxY ?? 0, width: snapshotView?.frame.width ?? 0, height: 0)
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurImageView.frame
        
        let tabbarSnapshotView = fromVC?.tabBarController?.tabBar
        toVC?.view.frame = transitionContext.finalFrameForViewController(toVC!)
//        toVC?.detailView
    }
}















//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEVideoDetailPopTransition: NSObject, UIViewControllerAnimatedTransitioning {
    private var fromVC: EYEVideoDetailController!
    private var toVC: BaseController!
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.3
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! EYEVideoDetailController
        let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! BaseController
        let container = transitionContext.containerView()
        self.fromVC = fromVC
        self.toVC = toVC
        
        fromVC.detailView.backBtn.alpha = 0
        // 背景图片
        let snapshotView = fromVC.detailView.albumImageView.snapshotViewAfterScreenUpdates(false)
        snapshotView.frame = fromVC.detailView.albumImageView.frame
        fromVC.detailView.albumImageView.hidden = true
        fromVC.detailView.blurImageView.hidden = true
        fromVC.detailView.blurView.hidden = true
        fromVC.detailView.bottomToolView.hidden = true
        
        // 覆盖层
        let cover = UIView(frame: snapshotView.frame)
        cover.backgroundColor = UIColor.blackColor()
        cover.alpha = 0
        
        // 模糊图片
        let blurImageView = fromVC.detailView.blurImageView.snapshotViewAfterScreenUpdates(false)
        blurImageView.frame = fromVC.detailView.blurImageView.frame
        
        let blurEffect : UIBlurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = blurImageView.frame
        
        toVC.view.frame = transitionContext.finalFrameForViewController(toVC)
        toVC.selectCell?.backgroundImageView.hidden = true
        toVC.selectCell?.titleLabel.alpha = 0
        toVC.selectCell?.subTitleLabel.alpha = 0
    
        container?.addSubview(toVC.view)
        container!.addSubview(snapshotView)
        container?.addSubview(cover)
        container?.addSubview(blurImageView)
        container?.addSubview(blurView)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () in
            
            let snapshotFrame = container!.convertRect(toVC.selectCell!.backgroundImageView.frame, fromView: toVC.selectCell)
            snapshotView.frame = snapshotFrame
            
            cover.frame = snapshotFrame
            cover.alpha = 0.3
            
            blurImageView.frame = CGRect(x: 0, y: snapshotFrame.maxY, width: snapshotFrame.width, height: 0)
            blurView.frame = CGRect(x: 0, y: snapshotFrame.maxY, width: snapshotFrame.width, height: 0)
            
        }) { [unowned self] (finish) in
            toVC.selectCell?.backgroundImageView.hidden = false
            fromVC.detailView.backBtn.alpha = 1
            
            snapshotView.removeFromSuperview()
            cover.removeFromSuperview()
            blurImageView.removeFromSuperview()
            blurView.removeFromSuperview()
            
            fromVC.detailView.albumImageView.hidden = false
            fromVC.detailView.blurImageView.hidden = false
            fromVC.detailView.blurView.hidden = false
            fromVC.detailView.bottomToolView.hidden = false
            self.titleAnimation()
            if !fromVC.panIsCancel {
                self.tabbarAnimation()
            }
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }
    
    private func tabbarAnimation() {
        let tabbarSnapshotView = toVC.tabBarController?.tabBar
        UIView.animateWithDuration(0.2, delay: 0, options: .CurveLinear, animations: { 
            tabbarSnapshotView?.frame.origin.y = SCREEN_HEIGHT - TAB_BAR_HEIGHT
            }, completion: nil)
    }
    
    
    private func titleAnimation() {
        UIView.animateWithDuration(0.3) {
            self.toVC.selectCell?.titleLabel.alpha = 1
            self.toVC.selectCell?.subTitleLabel.alpha = 1
        }
    }
}

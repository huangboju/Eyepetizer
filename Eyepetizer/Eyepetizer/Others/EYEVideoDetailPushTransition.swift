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
        toVC?.detailView.albumImageView.alpha = 0
        toVC?.detailView.blurImageView.alpha = 0
        toVC?.detailView.backBtn.alpha = 0
        toVC?.detailView.playImageView.alpha = 0
        toVC?.detailView.classifyLabel.alpha = 0
        toVC?.detailView.describeLabel.alpha = 0
        toVC?.detailView.bottomToolView.alpha = 0
        
        container?.addSubview((toVC?.view)!)
        container?.addSubview(backgroundSnapshotView!)
        container?.addSubview(snapshotView!)
        container?.addSubview(coverView!)
        container?.addSubview(blurImageView)
        container?.addSubview(blurView)
        
        toVC?.detailView.albumImageView.layoutIfNeeded()
        
        UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: .CurveLinear, animations: { 
            snapshotView?.frame = toVC!.detailView.albumImageView.frame
            coverView?.frame = toVC!.detailView.albumImageView.frame
            coverView?.alpha = 0
            blurImageView.frame = toVC!.detailView.blurImageView.frame
            blurView.frame = toVC!.detailView.blurImageView.frame
            }) { [unowned self] (flag) in
                toVC!.detailView.albumImageView.image = fromVC!.selectCell!.backgroundImageView.image
                toVC!.detailView.albumImageView.alpha = 1
                toVC!.detailView.blurImageView.alpha = 1
                
                backgroundSnapshotView?.removeFromSuperview()
                coverView?.removeFromSuperview()
                snapshotView?.removeFromSuperview()
                blurImageView.removeFromSuperview()
                blurView.removeFromSuperview()
                
                self.playBtnAnimation()
                self.titleAnimation()
                self.subTitleAnimation()
                // 还原图片
                fromVC?.selectCell?.backgroundImageView.hidden = false
                fromVC?.selectCell?.coverButton.alpha = 0.3
                fromVC?.selectCell?.titleLabel.alpha = 1
                fromVC?.selectCell?.subTitleLabel.alpha = 1
                
                //一定要记得动画完成后执行此方法，让系统管理 navigation
                transitionContext.completeTransition(true)
        }
        
    }
    
    private func playBtnAnimation() {
        let playView = toVC?.detailView.playImageView
        UIView.transitionWithView(playView!, duration: 0.5, options: .CurveEaseOut, animations: {
            self.toVC?.detailView.playImageView.alpha = 1
            self.toVC?.detailView.backBtn.alpha = 1
            }, completion: nil)
    }
    
    private func titleAnimation () {
        let titleView = toVC?.detailView.videoTitleLabel
        titleView?.startAnimation()
    }
    
    private func subTitleAnimation() {
        UIView.animateWithDuration(0.3, delay: 0.5, options: .CurveEaseInOut, animations: {
            self.toVC?.detailView.classifyLabel.alpha = 1
            self.toVC?.detailView.describeLabel.alpha = 1
            self.toVC?.detailView.bottomToolView.alpha = 1
            }, completion: nil)
    }
}















//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class VideoDetailController: UIViewController {
    var model: ItemModel?
    var panIsCancel = false
    private var percentDrivenTransition: UIPercentDrivenInteractiveTransition?
    
    lazy var detailView: EYEVideoDetailView = {
        let detailView = EYEVideoDetailView(frame: self.view.bounds)
        detailView.delegate = self
        return detailView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        navigationController?.navigationBarHidden = true
        view.addSubview(detailView)
        detailView.model = model
        navigationController?.delegate = self
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithImg(R.image.ic_action_back(), selectedImg: nil, target: self, action: #selector(leftBtnDidClick))
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(edgePanGesture))
        edgePan.edges = .Left
        view.addGestureRecognizer(edgePan)
    }
    
    convenience init(model: ItemModel) {
        self.init()
        self.model = model
        title = "Eyepelizer"
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func leftBtnDidClick() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func edgePanGesture(sender: UIScreenEdgePanGestureRecognizer) {
        let progress = sender.translationInView(view).x / view.bounds.width
        if sender.state == .Began {
            percentDrivenTransition = UIPercentDrivenInteractiveTransition()
            navigationController?.popViewControllerAnimated(true)
        } else if sender.state == .Changed {
            percentDrivenTransition?.updateInteractiveTransition(progress)
        } else if sender.state == .Cancelled || sender.state == .Ended {
            if progress > 0.5 {
                percentDrivenTransition?.finishInteractiveTransition()
                panIsCancel = false
            } else {
                percentDrivenTransition?.cancelInteractiveTransition()
                panIsCancel = true
            }
            percentDrivenTransition = nil
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension VideoDetailController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return operation == .Pop ? VideoDetailPopTransition() : nil
    }
    
    func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return animationController is VideoDetailController ? percentDrivenTransition : nil
    }
}

extension VideoDetailController: EYEVideoDetailViewDelegate {
    func playImageViewDidClick() {
        let playerController = PlayerController(url: model!.playUrl, title: model!.title)
        navigationController?.pushViewController(playerController, animated: false)
    }
    
    func backBtnDidClick() {
        navigationController?.popViewControllerAnimated(true)
    }
}

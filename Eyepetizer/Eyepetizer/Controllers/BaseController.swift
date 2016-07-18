//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class BaseController: UIViewController {
    var selectCell: ChoiceCell?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.delegate = nil
    }
}

extension BaseController: UINavigationControllerDelegate {
    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .Push && toVC is VideoDetailController {
            return VideoDetailPushTransition()
        }
        return nil
    }
}

//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class MainNavigation: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.delegate = self
            navigationBar.titleTextAttributes = ["Font" : UIFont.customFont_Lobster(fontSize: LABEL_FONT_SIZE)]
            delegate = self
        }
        navigationBar.tintColor = UIColor.blackColor()
        navigationBar.barStyle = .Default
        navigationBar.backIndicatorImage = R.image.ic_action_back()
        navigationBar.backIndicatorTransitionMaskImage = R.image.ic_action_back()
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        return super.popToRootViewControllerAnimated(animated)
    }
    
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) && animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToViewController(viewController, animated: false)
    }
    
    // MARK: - UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        if respondsToSelector(Selector("interactivePopGestureRecognizer")) {
            interactivePopGestureRecognizer?.enabled = true
        }
    }
    
    //MARK: - UIGestureRecognizerDelegate
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if viewControllers.count < 2 || visibleViewController == viewControllers[0] {
                return false
            }
        }
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

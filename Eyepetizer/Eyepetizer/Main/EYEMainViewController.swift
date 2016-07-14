//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEMainViewController: UITabBarController {
    
    private lazy var tabView: EYEMainTabView = {
        var tabView = EYEMainTabView.tabView()
        tabView.frame = self.tabBar.bounds
        tabView.delegate = self
        return tabView
    }()
    
    private lazy var launchView: EYELaunchView = {
        var launchView = EYELaunchView.launchView()
        launchView.frame = self.view.bounds
        return launchView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        tabBar.addSubview(tabView)
        
        addChildVC()
        
        view.addSubview(launchView)
        launchView.animationDidStop { [unowned self] (launchView) in
            self.launchViewRemoveAnimation()
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // 删除系统自带的导航按钮
        for button in self.tabBar.subviews {
            if button is UIControl {
                button.removeFromSuperview()
            }
        }
    }
    
    private func addChildVC() {
        let choiceController = EYEChoiceController()
        let discoverController = EYEDiscoverController()
        let popularController = EYEPopularController()
        
        setupChildController(choiceController)
        setupChildController(discoverController)
        setupChildController(popularController)
    }
    
    private func setupChildController(controller: UIViewController) {
        controller.title = "Eyepetizer"
        addChildViewController(EYENavigationController(rootViewController: controller))
        view.bringSubviewToFront(controller.view)
    }
    
    private func launchViewRemoveAnimation() {
        UIView.animateWithDuration(1, animations: {
            self.launchView.alpha = 0
        }) { [unowned self] (_) in
            self.launchView.removeFromSuperview()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EYEMainViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return EYETabbarTransition()
    }
}

extension EYEMainViewController: EYEMainTabViewDelegate {
    func tabBarDidSelector(fromSelectorButton from: Int, toSelectorButton to: Int, title : String) {
        selectedIndex = to
    }
}

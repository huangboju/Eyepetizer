//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class MainTabBar: UITabBarController {
    
    private lazy var tabView: MainTabView = {
        var tabView = MainTabView.tabView()
        tabView.frame = self.tabBar.bounds
        tabView.delegate = self
        return tabView
    }()
    
    private lazy var launchView: LaunchView = {
        var launchView = LaunchView.launchView()
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
        let choiceController = ChoiceController()
        let discoverController = DiscoverController()
        let popularController = PopularController()
        
        setupChildController(choiceController)
        setupChildController(discoverController)
        setupChildController(popularController)
    }
    
    private func setupChildController(controller: UIViewController) {
        controller.title = "petizer"
        addChildViewController(MainNavigation(rootViewController: controller))
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

extension MainTabBar: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return TabbarTransition()
    }
}

extension MainTabBar: MainTabViewDelegate {
    func tabBarDidSelector(fromSelectorButton from: Int, toSelectorButton to: Int, title : String) {
        selectedIndex = to
    }
}

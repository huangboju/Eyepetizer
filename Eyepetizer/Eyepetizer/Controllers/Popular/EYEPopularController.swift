//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEPopularController: EYEBaseViewController, LoadingPresenter {
    var loaderView: EYELoaderView?
    private let titles = ["周排行", "月排行", "总排行"]
    private var weekController: EYEPopularWeekController?
    private var monthController: EYEPopularMonthController?
    private var historyController: EYEPopularHistoryController?
    private var currentController: UIViewController?
    
    private lazy var headerView: EYEPopularHeaderView = {
        let headerView = EYEPopularHeaderView(frame: CGRect(x: 0, y: NAV_BAR_HEIGHT + STATUS_BAR_HEIGHT, width: SCREEN_WIDTH, height: CHARTS_HEIGHT), titles: self.titles)
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
        headerView.headerViewTitleDidClick { [unowned self](targetBtn, index) in
            self.itemDidClick(index)
        }
        itemDidClick(0)
    }
    
    private func itemDidClick(index : Int) {
        var actionController: UIViewController!
        // 再添加控制器
        switch index {
        case 0:
            if weekController == nil {
                weekController = EYEPopularWeekController()
            }
            actionController = weekController
        case 1:
            if monthController == nil {
                monthController = EYEPopularMonthController()
            }
            actionController = monthController
        case 2:
            if historyController == nil {
                historyController = EYEPopularHistoryController()
            }
            actionController = historyController
        default:
            break
        }
        addChildViewController(actionController)
        view.addSubview(actionController.view)
        setupControllerFrame(actionController.view)
        if let currentVC = currentController {
            startAnimation(currentVC, toVC: actionController)
        } else {
            currentController = actionController
        }
    }
    
    private func startAnimation(fromVC: UIViewController, toVC: UIViewController) {
        toVC.view.alpha = 0
        UIView.animateWithDuration(0.5, animations: { 
            fromVC.view.alpha = 0
            toVC.view.alpha = 1
            }) { (flag) in
                fromVC.view.removeFromSuperview()
                self.currentController = toVC
        }
    }
    
    private func setupControllerFrame (view : UIView) {
        view.snp_makeConstraints { (make) in
            make.left.trailing.equalTo(self.view)
            make.top.equalTo(headerView).offset(headerView.frame.height)
            make.bottom.equalTo(self.view).offset(-TAB_BAR_HEIGHT)
        }
    }
}










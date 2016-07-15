//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class DiscoverDetailController: BaseController {
    private let titles = ["按时间排序", "分享排行榜"]
    private var timeController: DiscoverDetailTimeController?
    private var shareController: DiscoverDetailShareController?
    private var currentController: UIViewController?
    private var categoryId = 0
    
    private lazy var headerView: PopularHeaderView = {
        let headerView = PopularHeaderView(frame: CGRect(x: 0, y: TOP_BAR_HEIGHT, width: SCREEN_WIDTH, height: CHARTS_HEIGHT), titles: self.titles)
        headerView.setupLineViewWidth(65)
        return headerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        navigationItem.leftBarButtonItem = UIBarButtonItem.barButtonItemWithImg(R.image.ic_action_back(), selectedImg: nil, target: self, action: #selector(leftBtnDidClick))
        view.addSubview(headerView)
        headerView.headerViewTitleDidClick { [unowned self] (targetBtn, index) in
            self.itemDidClick(index)
        }
        itemDidClick(0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.enabled = true
    }
    
    convenience init(title: String, categoryId: Int) {
        self.init()
        self.title = title
        self.categoryId = categoryId
    }
    
    private func itemDidClick(index: Int) {
        var actionController: UIViewController!
        // 再添加控制器
        switch index {
        case 0:
            if timeController == nil {
                timeController = DiscoverDetailTimeController(categoryId: categoryId)
            }
            actionController = timeController
        case 1:
            if shareController == nil {
                shareController = DiscoverDetailShareController(categoryId: categoryId)
            }
            actionController = shareController
        default:
            break
        }
        
        addChildViewController(actionController)
        view.addSubview(actionController.view)
        setupControllerFrame(actionController.view)
        // 动画
        startAnimation(currentController, toVC: actionController)
    }
    
    private func setupControllerFrame (view : UIView) {
        view.snp_makeConstraints { (make) in
            make.left.trailing.equalTo(self.view)
            make.top.equalTo(headerView).offset(headerView.frame.height)
            make.bottom.equalTo(self.view).offset(-TAB_BAR_HEIGHT)
        }
    }
    
    private func startAnimation(fromVC: UIViewController? = nil, toVC: UIViewController) {
        toVC.view.alpha = 0
        UIView.animateWithDuration(0.5, animations: { 
            if let fromVC = fromVC {
                fromVC.view.alpha = 0
            }
            toVC.view.alpha = 1
            }) { [unowned self] (flag) in
                if let fromVC = fromVC {
                    fromVC.view.removeFromSuperview()
                }
                self.currentController = toVC
        }
    }
    
    func leftBtnDidClick() {
        navigationController?.popViewControllerAnimated(true)
    }
}

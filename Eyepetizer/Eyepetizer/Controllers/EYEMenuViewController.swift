//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEMenuViewController: UIViewController, GuillotineMenu {
    let titles = ["我的缓存", "功能开关", "我要投稿", "更多应用"]
    private let menuViewCellId = "menuViewCellId"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.clearColor()
        tableView.tableHeaderView = EYEMenuHeaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 200))
        tableView.sectionHeaderHeight = 200
        tableView.rowHeight = 70
        tableView.separatorStyle = .None
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var dismissButton: UIButton! = {
        let dismissButton = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 40))
        dismissButton.setImage(R.image.ic_action_menu(), forState: .Normal)
        dismissButton.addTarget(self, action: #selector(dismissButtonTapped), forControlEvents: .TouchUpInside)
        return dismissButton
    }()
    
    lazy var titleLabel: UILabel! = {
        var titleLabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "Eyepetizer"
        titleLabel.textColor = UIColor.blackColor()
        titleLabel.sizeToFit()
        return titleLabel
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        let blurEffect = UIBlurEffect(style: .Light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        view.addSubview(tableView)
        tableView.snp_makeConstraints { make in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(view).offset(TOP_BAR_HEIGHT)
        }
    }
    
    func dismissButtonTapped(sende: UIButton) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EYEMenuViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(menuViewCellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: menuViewCellId)
        }
        cell?.backgroundColor = UIColor.clearColor()
        cell?.contentView.backgroundColor = UIColor.clearColor()
        cell?.selectionStyle = .None
        cell?.textLabel?.textAlignment = .Center
        cell?.textLabel?.text = titles[indexPath.row]
        return cell!
    }
}

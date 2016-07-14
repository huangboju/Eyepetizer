//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class EYEChoiceController: EYEBaseViewController, LoadingPresenter, MenuPresenter {
    var issueList = [IssueModel]()
    var nextPageUrl: String?
    var loaderView: EYELoaderView?
    var menuBtn: EYEMenuBtn?
    
    private lazy var collectionView: EYECollectionView = {
        let collectionView = EYECollectionView(frame: self.view.bounds, collectionViewLayout: EYECollectionLayout())
        collectionView.registerClass(EYEChoiceHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: EYEChoiceHeaderView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        setupLoaderView()
        
        getData(EYEAPIHeaper.API_Choice, params: [
            "date" : NSDate.getCurrentTimeStamp(),
            "num" : "7"
            ])
        
        setLoaderViewHidden(false)
        
        setupMenuBtn()
        
        collectionView.headerViewPulltoRefresh { [unowned self] in
            self.getData(EYEAPIHeaper.API_Choice, params: [
                "date" : NSDate.getCurrentTimeStamp(),
                "num" : "7"
                ])
        }
        
        collectionView.footerViewPullToRefresh {[unowned self] in
            if let url = self.nextPageUrl {
                self.getData(url)
            }
        }
    }
    
    private func getData(api: String, params: [String : AnyObject]? = nil) {
        Alamofire.request(.GET, api, parameters: params).responseSwiftyJSON ({[unowned self](request, Response, json, error) -> Void in
            print("\(EYEAPIHeaper.API_Choice)- \(params)")
            
            if json != .null && error == nil {
                // 转模型
                let dict = json.rawValue as! NSDictionary
                // 获取下一个url
                self.nextPageUrl = dict["nextPageUrl"] as? String
                // 内容数组
                let issueArray = dict["issueList"] as! [[String : AnyObject]]
                let list = issueArray.map({ (dict) -> IssueModel in
                    return IssueModel(dict: dict)
                })
                
                // 这里判断下拉刷新还是上拉加载更多，如果是上拉加载更多，拼接model。如果是下拉刷新，直接复制
                if params != nil {
                    // 如果params有值就是下拉刷新
                    self.issueList = list
                    self.collectionView.headerViewEndRefresh()
                } else {
                    self.issueList.appendContentsOf(list)
                    self.collectionView.footerViewEndRefresh()
                }
                
                self.setLoaderViewHidden(true)
                // 刷新
                self.collectionView.reloadData()
            }
            })
    }
    
    func menuBtnDidClick() {
        let menuController = EYEMenuViewController()
        menuController.modalPresentationStyle = .Custom
        menuController.transitioningDelegate = self
        
        if menuController is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuController as? GuillotineAnimationDelegate
        }
        
        presentationAnimator.supportView = navigationController?.navigationBar
        presentationAnimator.presentButton = menuBtn
        presentationAnimator.duration = 0.15
        presentViewController(menuController, animated: true, completion: nil)
    }
}

extension EYEChoiceController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return issueList.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let issueModel = issueList[section]
        return issueModel.itemList.count
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as? EYEChoiceCell
        let issueModel = issueList[indexPath.section]
        cell?.model = issueModel.itemList[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(EYEChoiceCell.reuseIdentifier, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? EYEChoiceCell
    
        let issueModel = issueList[indexPath.section]
        let model = issueModel.itemList[indexPath.row]
        
        if model.playUrl.isEmpty {
            APESuperHUD.showOrUpdateHUD(icon: .SadFace, message: "没有播放地址", duration: 0.3, presentingView: view, completion: nil)
            return
        }
        navigationController?.pushViewController(EYEVideoDetailController(model: model), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: EYEChoiceHeaderView.reuseIdentifier, forIndexPath: indexPath) as? EYEChoiceHeaderView
            let issueModel = issueList[indexPath.section]
            if let image = issueModel.headerImage {
                headerView?.image = image
            } else {
                headerView?.title = issueModel.headerTitle
            }
            
            return headerView ?? UICollectionReusableView()
        }
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let issueModel = issueList[section]
        return issueModel.isHaveSectionView ? CGSize(width: SCREEN_WIDTH, height: 50) : CGSize.zero
    }
}

extension EYEChoiceController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Presentation
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Dismissal
        return presentationAnimator
    }
}

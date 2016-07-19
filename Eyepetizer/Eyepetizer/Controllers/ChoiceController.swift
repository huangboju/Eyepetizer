//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class ChoiceController: BaseController, LoadingPresenter, MenuPresenter, DataPresenter {
    var loaderView: LoaderView?
    var menuButton: MenuButton?
    
    var data: [IssueModel] = [IssueModel]()
    var nextPageUrl: String?
    var endpoint = "" {
        willSet {
            netWork(newValue, parameters: [
                "date" : NSDate.getCurrentTimeStamp(),
                "num" : "7"
                ])
        }
    }
    
    private lazy var collectionView: CollectionView = {
        let collectionView = CollectionView(frame: self.view.bounds, collectionViewLayout: CollectionLayout())
        collectionView.registerClass(ChoiceHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ChoiceHeaderView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupLoaderView()
        endpoint = APIHeaper.API_Choice
        
        setLoaderViewHidden(false)
        
        setupMenuButton()
        
        collectionView.headerViewPulltoRefresh { [unowned self] in
            self.netWork(APIHeaper.API_Choice, parameters: [
                "date" : NSDate.getCurrentTimeStamp(),
                "num" : "7"
                ])
        }
        
        collectionView.footerViewPullToRefresh {[unowned self] in
            if let nextPageUrl = self.nextPageUrl {
                self.netWork(nextPageUrl)
            }
        }
    }
    
    func onLoadSuccess(isPaging: Bool, json: DATA) {
        if let dict = json.dictionary {
            self.nextPageUrl = dict["nextPageUrl"]?.string
            if let issueArray = dict["issueList"]?.arrayValue {
                let list = issueArray.map({ (dict) -> IssueModel in
                    return IssueModel(dict: dict.rawValue as? [String : AnyObject] ?? [String : AnyObject]())
                })
                
                if isPaging {
                    data = list
                    collectionView.headerViewEndRefresh()
                } else {
                    data.appendContentsOf(list)
                    collectionView.footerViewEndRefresh()
                }
            }
            setLoaderViewHidden(true)
            collectionView.reloadData()
        }
    }
    
    func menuBtnDidClick() {
        let menuController = MenuViewController()
        menuController.modalPresentationStyle = .Custom
        menuController.transitioningDelegate = self
        
        if menuController is GuillotineAnimationDelegate {
            presentationAnimator.animationDelegate = menuController as? GuillotineAnimationDelegate
        }
        
        presentationAnimator.supportView = navigationController?.navigationBar
        presentationAnimator.presentButton = menuButton
        presentationAnimator.duration = 0.15
        presentViewController(menuController, animated: true, completion: nil)
    }
}

extension ChoiceController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let issueModel = data[section]
        return issueModel.itemList.count
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as? ChoiceCell
        let issueModel = data[indexPath.section]
        cell?.model = issueModel.itemList[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(ChoiceCell.cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? ChoiceCell
    
        let issueModel = data[indexPath.section]
        let model = issueModel.itemList[indexPath.row]
        
        if model.playUrl.isEmpty {
            APESuperHUD.showOrUpdateHUD(icon: .SadFace, message: "没有播放地址", duration: 0.3, presentingView: view, completion: nil)
            return
        }
        navigationController?.pushViewController(VideoDetailController(model: model), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ChoiceHeaderView.reuseIdentifier, forIndexPath: indexPath) as? ChoiceHeaderView
            let issueModel = data[indexPath.section]
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
        let issueModel = data[section]
        return issueModel.isHaveSectionView ? CGSize(width: SCREEN_WIDTH, height: 50) : CGSize.zero
    }
}

extension ChoiceController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Presentation
        return presentationAnimator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        presentationAnimator.mode = .Dismissal
        return presentationAnimator
    }
}

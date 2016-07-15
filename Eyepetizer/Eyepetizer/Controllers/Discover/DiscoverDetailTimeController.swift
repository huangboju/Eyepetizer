//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class DiscoverDetailTimeController: UIViewController, LoadingPresenter {
    var loaderView: LoaderView?
    private var models = [ItemModel]()
    private var nextURL: String?
    private var categoryId = 0
    
    private lazy var collectionView : CollectionView = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: SCREEN_HEIGHT - TAB_BAR_HEIGHT - NAV_BAR_HEIGHT - STATUS_BAR_HEIGHT)
        let collectionView = CollectionView(frame: rect, collectionViewLayout:CollectionLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupLoaderView()
        setLoaderViewHidden(false)
        getData(params: ["categoryId": categoryId])
        collectionView.footerViewPullToRefresh {[unowned self] in
            if let url = self.nextURL {
                self.getData(url, params: nil)
            }
        }
    }
    
    private func getData(api: String = APIHeaper.API_Discover_Date, params:[String: AnyObject]? = nil) {
        print("\(api) - \(params)")
        Alamofire.request(.POST, api, parameters: params).responseSwiftyJSON ({ [unowned self](request, response, json, error) -> Void in
            // 字典转模型 刷新数据
            if json != .null && error == nil {
                let dataDict = json.rawValue as? [String : AnyObject]
                // 获取下一个url
                if let dataDict = dataDict {
                    self.nextURL = dataDict["nextPageUrl"] as? String
                    let itemArray = dataDict["videoList"] as! NSArray
                    let list = itemArray.map({ (dict) -> ItemModel in
                        return ItemModel(dict: dict as? [String : AnyObject])
                    })
                    if params != nil {
                        // 第一次进入
                        self.models = list
                    } else {
                        self.models.appendContentsOf(list)
                        self.collectionView.footerViewEndRefresh()
                    }
                }
                
                self.collectionView.reloadData()
            }
            // 隐藏loadview
            self.setLoaderViewHidden(true)
            })
    }
    
    convenience init(categoryId: Int) {
        self.init()
        self.categoryId = categoryId
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DiscoverDetailTimeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(ChoiceCell.cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        (cell as? ChoiceCell)?.model = models[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if parentViewController is DiscoverDetailController {
            (parentViewController as! DiscoverDetailController).selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? ChoiceCell
        }
        let model = models[indexPath.row]
        navigationController?.pushViewController(VideoDetailController(model: model), animated: true)
    }
}

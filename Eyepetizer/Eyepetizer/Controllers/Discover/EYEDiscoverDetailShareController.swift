//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class EYEDiscoverDetailShareController: UIViewController, LoadingPresenter {
    var loaderView: EYELoaderView?
    private var models = [ItemModel]()
    private var nextURL: String?
    private var categoryId = 0
    
    private lazy var collectionView : EYECollectionView = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: SCREEN_HEIGHT-TAB_BAR_HEIGHT - STATUS_BAR_HEIGHT - NAV_BAR_HEIGHT)
        var collectionView = EYECollectionView(frame: rect, collectionViewLayout:EYECollectionLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupLoaderView()
        getData(params: ["categoryId" : categoryId])
        setLoaderViewHidden(false)
        collectionView.footerViewPullToRefresh { [unowned self] in
            if let url = self.nextURL {
                self.getData(url, params: nil)
            }
        }
    }
    
    convenience init(categoryId: Int) {
        self.init()
        self.categoryId = categoryId
    }
    
    private func getData(api : String = EYEAPIHeaper.API_Discover_Share, params:[String: AnyObject]? = nil) {
        
        Alamofire.request(.GET, api, parameters: params).responseSwiftyJSON ({ [unowned self](request, response, json, error) -> Void in
            // 字典转模型 刷新数据
            if json != .null && error == nil {
                let dataDict = json.rawValue as? [String : AnyObject]
                // 下一个url
                self.nextURL = dataDict!["nextPageUrl"] as? String
                let itemArray = dataDict!["videoList"] as! NSArray
                // 字典转模型
                let list = itemArray.map({ (dict) -> ItemModel in
                    ItemModel(dict: dict as? [String : AnyObject])
                })
                
                if params != nil {
                    self.models = list
                } else {
                    self.models.appendContentsOf(list)
                    self.collectionView.footerViewEndRefresh()
                }
                self.collectionView.reloadData()
            }
            self.setLoaderViewHidden(true)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EYEDiscoverDetailShareController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(EYEChoiceCell.cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        (cell as? EYEChoiceCell)?.model = models[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if parentViewController is EYEDiscoverDetailController {
            (parentViewController as? EYEDiscoverDetailController)?.selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? EYEChoiceCell
        }
        
        let model = models[indexPath.row]
        navigationController?.pushViewController(EYEVideoDetailController(model: model), animated: true)
    }
}

//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class EYEPopularWeekController: UIViewController, LoadingPresenter {
    var loaderView: EYELoaderView?
    private var models = [ItemModel]()
    private lazy var collectionView: EYECollectionView = {
        let rect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TAB_BAR_HEIGHT - CHARTS_HEIGHT - TOP_BAR_HEIGHT)
        let collectionView = EYECollectionView(frame: rect, collectionViewLayout: EYECollectionLayout())
        let layout = collectionView.collectionViewLayout as? EYECollectionLayout
        layout?.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
        collectionView.registerClass(EYEPopularFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: EYEPopularFooterView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoaderView()
        getData()
    }
    
    private func getData(api : String = EYEAPIHeaper.API_Popular_Weakly) {
        setLoaderViewHidden(false)
        Alamofire.request(.GET, api).responseSwiftyJSON ({ [unowned self](request, response, json, error) in
            // 字典转模型 刷新数据
            if json != .null && error == nil {
                if let dataDict = json.rawValue as? [String : AnyObject] {
                    let itemArray = dataDict["videoList"] as! NSArray
                    self.models = itemArray.map({ (dict) -> ItemModel in
                        ItemModel(dict: dict as? [String : AnyObject])
                    })
                    
                    self.collectionView.reloadData()
                }
            }
            self.setLoaderViewHidden(true)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension EYEPopularWeekController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(EYEChoiceCell.cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = cell as? EYEChoiceCell
        cell?.model = models[indexPath.row]
        cell?.index = "\(indexPath.row+1)"
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if parentViewController is EYEPopularController {
            (parentViewController as? EYEPopularController)?.selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? EYEChoiceCell
        }
        
        let model = models[indexPath.row]
        navigationController?.pushViewController(EYEVideoDetailController(model: model), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionFooter  {
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: EYEPopularFooterView.reuseIdentifier, forIndexPath: indexPath)
            return footerView
        }
        return UICollectionReusableView()
    }
}

//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class EYEDiscoverController: UIViewController, LoadingPresenter {
    var loaderView: EYELoaderView?
    var models = [DiscoverModel]()
    
    private lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemSize = SCREEN_WIDTH / 2 - 0.5
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.sectionInset = UIEdgeInsetsZero
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.registerClass(EYEDiscoverCell.self, forCellWithReuseIdentifier: EYEDiscoverCell.cellID)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupLoaderView()
        getData()
    }
    
    private func getData() {
        setLoaderViewHidden(false)
        Alamofire.request(.GET, EYEAPIHeaper.API_Discover).responseSwiftyJSON ({ [unowned self](request, response, json, error) -> Void in
            
            if json != .null && error == nil{
                let jsonArray = json.arrayValue
                self.models = jsonArray.map({ (dict) -> DiscoverModel in
                    return DiscoverModel(dict: dict.rawValue as? [String : AnyObject] ?? [String : AnyObject]())
                })
                self.collectionView.reloadData()
            }
            self.setLoaderViewHidden(true)
            })
    }
}

extension EYEDiscoverController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(EYEDiscoverCell.cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as? EYEDiscoverCell
        cell?.model = models[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = models[indexPath.row]
        let detailController = EYEDiscoverDetailController(title: model.name, categoryId: model.id)
        detailController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailController, animated: true)
    }
}

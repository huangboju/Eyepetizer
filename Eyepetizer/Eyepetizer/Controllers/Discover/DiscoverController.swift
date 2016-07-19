//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class DiscoverController: UIViewController, LoadingPresenter, DataPresenter {
    var loaderView: LoaderView?
    let itemSize = SCREEN_WIDTH / 2 - 0.5
    
    var data: [DiscoverModel] = [DiscoverModel]()
    
    var endpoint: String = "" {
        willSet {
            netWork(newValue)
        }
    }
    var nextPageUrl: String?
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsZero
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.registerClass(DiscoverCell.self, forCellWithReuseIdentifier: DiscoverCell.cellID)
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupLoaderView()
        endpoint = APIHeaper.API_Discover
    }
    
    func onLoadSuccess(isPaging: Bool, json: DATA) {
        setLoaderViewHidden(false)
        if json != .null {
            let jsonArray = json.arrayValue
            self.data = jsonArray.map({ (dict) -> DiscoverModel in
                return DiscoverModel(dict: dict.rawValue as? [String : AnyObject] ?? [String : AnyObject]())
            })
            self.collectionView.reloadData()
        }
        self.setLoaderViewHidden(true)
    }
}

extension DiscoverController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(DiscoverCell.cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as? DiscoverCell
        cell?.model = data[indexPath.row]
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let model = data[indexPath.row]
        let detailController = DiscoverDetailController(title: model.name, categoryId: model.id)
        detailController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailController, animated: true)
    }
}

extension DiscoverController: UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return indexPath.row == 2 ? CGSize(width: SCREEN_WIDTH, height: itemSize)  : CGSize(width: itemSize, height: itemSize)
    }
}

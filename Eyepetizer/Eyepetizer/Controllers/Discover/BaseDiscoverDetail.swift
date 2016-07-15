//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class BaseDiscoverDetail: UIViewController, LoadingPresenter {
    var loaderView: LoaderView?
    var nextPageUrl: String?
    var models = [ItemModel]()
    var categoryId = 0
    var endpoint = ""
    
    lazy var collectionView: CollectionView = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: SCREEN_HEIGHT - TAB_BAR_HEIGHT - TOP_BAR_HEIGHT)
        var collectionView = CollectionView(frame: rect, collectionViewLayout:CollectionLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    convenience init(categoryId: Int) {
        self.init()
        self.categoryId = categoryId
    }

    final override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        setupLoaderView()
        onPrepare()
    }
    
    func onPrepare() {
        getData(endpoint, parameters: ["categoryId": categoryId])
        setLoaderViewHidden(false)
        collectionView.footerViewPullToRefresh { [unowned self] in
            if let url = self.nextPageUrl {
                self.getData(url)
            }
        }
    }
    
    func getData(url: String = "", parameters: [String : AnyObject]? = nil) {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BaseDiscoverDetail: UICollectionViewDelegate, UICollectionViewDataSource {
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
            (parentViewController as? DiscoverDetailController)?.selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? ChoiceCell
        }
        let model = models[indexPath.row]
        navigationController?.pushViewController(VideoDetailController(model: model), animated: true)
    }
}

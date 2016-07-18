//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class BaseDiscoverDetail: UIViewController, LoadingPresenter, DataPresenter {
    var loaderView: LoaderView?
    var nextPageUrl: String?
    var categoryId = 0
    
    //MARK: - 💛 DataPresenter 💛
    var endpoint = "" {
        willSet {
            netWork(newValue, parameters: ["categoryId": categoryId])
        }
    }
    
    var data: [ItemModel] = [ItemModel]() {
        willSet {
            if data.count != 0 {
                collectionView.footerViewEndRefresh()
            }
        }
        didSet {
            collectionView.reloadData()
            setLoaderViewHidden(true)
        }
    }
    
    lazy var collectionView: CollectionView = {
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: SCREEN_HEIGHT - TAB_BAR_HEIGHT - TOP_BAR_HEIGHT)
        let collectionView = CollectionView(frame: rect, collectionViewLayout:CollectionLayout())
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
        setLoaderViewHidden(false)
        collectionView.footerViewPullToRefresh { [unowned self] in
            if let nextPageUrl = self.nextPageUrl {
                self.netWork(nextPageUrl, parameters: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension BaseDiscoverDetail: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(ChoiceCell.cellID, forIndexPath: indexPath)
    }

    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        (cell as? ChoiceCell)?.model = data[indexPath.row]
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if parentViewController is DiscoverDetailController {
            (parentViewController as? DiscoverDetailController)?.selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? ChoiceCell
        }
        navigationController?.pushViewController(VideoDetailController(model: data[indexPath.row]), animated: true)
    }
}

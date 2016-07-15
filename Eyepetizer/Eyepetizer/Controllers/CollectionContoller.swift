//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class CollectionContoller: UIViewController, LoadingPresenter {
    var loaderView: LoaderView?
    var models = [ItemModel]()
    
    lazy var collectionView: CollectionView = {
        let rect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TAB_BAR_HEIGHT - CHARTS_HEIGHT - TOP_BAR_HEIGHT)
        let collectionView = CollectionView(frame: rect, collectionViewLayout:CollectionLayout())
        let layout = collectionView.collectionViewLayout as? CollectionLayout
        layout?.footerReferenceSize = CGSize(width: collectionView.frame.width, height: 50)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        onPrepare()
        view.addSubview(collectionView)
        listViewCreated()
        setupLoaderView()
        getData()
    }
    
    func onPrepare() {}
    
    func listViewCreated() {}
    
    func getData() {}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CollectionContoller: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(ChoiceCell.cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let cell = cell as? ChoiceCell
        cell?.model = models[indexPath.row]
        cell?.index = "\(indexPath.row + 1)"
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if parentViewController is PopularController {
            (parentViewController as? PopularController)?.selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? ChoiceCell
        }
        let model = models[indexPath.row]
        navigationController?.pushViewController(VideoDetailController(model: model), animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: PopularFooterView.reuseIdentifier, forIndexPath: indexPath)
            return footView
        }
        return UICollectionReusableView()
    }
}
//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class CollectionList: UIViewController, LoadingPresenter, DataPresenter, CollectionPresenter {
    var loaderView: LoaderView?
    var cellClass = UICollectionViewCell.self
    
    //MARK: - 💛 DataPresenter 💛
    var endpoint = "" {
        willSet {
            netWork(newValue, key: "videoList")
        }
    }
    
    var data: [ItemModel] = [ItemModel]() {
        willSet {
            if !data.isEmpty {
                collectionView.footerViewEndRefresh()
            }
        }
        didSet {
            collectionView.reloadData()
            setLoaderViewHidden(true)
        }
    }
    
    lazy var collectionView: CollectionView = {
        let rect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - TAB_BAR_HEIGHT - CHARTS_HEIGHT - TOP_BAR_HEIGHT)
        let collectionView = CollectionView(frame: rect, collectionViewLayout:CollectionLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    func onMap(results: [DATA]) -> [ItemModel] {
        return results.map({
            ItemModel(dict: $0.dictionary)
        })
    }
    
    func onLoadSuccess(isPaging: Bool, jsons: [ItemModel]) {
        if isPaging {
            data = jsons
        } else {
            data.appendContentsOf(jsons)
        }
    }
    
    final override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        listViewCreated()
        setupLoaderView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension CollectionList: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(ChoiceCell.cellID, forIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        onWillDisplayCell(collectionView, cell: cell, indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        onPerform(data[indexPath.row], indexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            let footView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: CollectionFooterView.reuseIdentifier, forIndexPath: indexPath)
            return footView
        }
        return UICollectionReusableView()
    }
}

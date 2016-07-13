//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEChoiceController: EYEBaseViewController, LoadingPresenter, MenuPresenter {
    var issueList = [IssueModel]()
    var nextPageUrl: String?
    var loaderView: EYELoaderView?
    var menuBtn: EYEMenuBtn?
    
    private lazy var collectionView: EYECollectionView = {
        var collectionView: EYECollectionView = EYECollectionView(frame: self.view.bounds, collectionViewLayout:EYECollectionLayout())
        collectionView.registerClass(EYEChoiceHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: EYEChoiceHeaderView.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    private lazy var presentationAnimator = GuillotineTransitionAnimation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        
        setupLoaderView()
        
        setLoaderViewHidden(false)
        
        setupMenuBtn()
    }
    
    func menuBtnDidClick() {
        
    }
}

extension EYEChoiceController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCellWithReuseIdentifier(EYEChoiceCell.reuseIdentifier, forIndexPath: indexPath)
    }
}

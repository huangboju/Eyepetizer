//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class CollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        backgroundColor = UIColor.whiteColor()
        registerClass(ChoiceCell.self, forCellWithReuseIdentifier: ChoiceCell.cellID)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYECollectionLayout: UICollectionViewFlowLayout {
    override init () {
        super.init()
        itemSize = CGSize(width: SCREEN_WIDTH, height: 200 * SCREEN_WIDTH / IPHONE5_WIDTH)
        sectionInset = UIEdgeInsetsZero
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

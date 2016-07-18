//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

public extension UICollectionView {
    func registerClass<T : UICollectionView where T : Reusable>(cellClass : T.Type) {
        registerClass(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
}

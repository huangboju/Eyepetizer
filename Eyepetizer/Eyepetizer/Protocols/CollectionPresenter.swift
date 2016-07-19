//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

protocol CollectionPresenter {
    associatedtype AbstractType
    func onPrepare()
    func listViewCreated()
    func onPerform(model: AbstractType, indexPath: NSIndexPath)
    func onWillDisplayCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath)
}

extension CollectionPresenter where Self: CollectionList {
    func onPrepare() {
    
    }
    
    func listViewCreated() {
    
    }
    
    func onPerform(model: Self.AbstractType, indexPath: NSIndexPath) {
        if parentViewController is PopularController {
            (parentViewController as? PopularController)?.selectCell = collectionView.cellForItemAtIndexPath(indexPath) as? ChoiceCell
        }
        navigationController?.pushViewController(VideoDetailController(model: (model as? ItemModel) ?? ItemModel()), animated: true)
    }
    
    func onWillDisplayCell(collectionView: UICollectionView, cell: UICollectionViewCell, indexPath: NSIndexPath) {
        (cell as? ChoiceCell)?.model = data[indexPath.row]
    }
}

//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class PopularHistoryController: CollectionContoller {
    
    override func onPrepare() {
        endpoint = APIHeaper.API_Popular_Historical
    }
    
    override func listViewCreated() {
        collectionView.registerClass(PopularFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PopularFooterView.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

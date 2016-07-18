//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class PopularWeekController: CollectionContoller {
    
    override func onPrepare() {
        endpoint = APIHeaper.API_Popular_Weakly
    }
    
    override func listViewCreated() {
        collectionView.registerClass(PopularFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PopularFooterView.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

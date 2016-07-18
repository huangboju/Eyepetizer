//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class PopularMonthController: CollectionContoller {
    
    override func onPrepare() {
        endpoint = APIHeaper.API_Popular_Monthly
    }
    
    override func listViewCreated() {
        collectionView.registerClass(ChoiceHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ChoiceHeaderView.reuseIdentifier)
        collectionView.registerClass(PopularFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PopularFooterView.reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

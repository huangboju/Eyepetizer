//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class DiscoverDetailTimeController: BaseDiscoverDetail {
    
    override func onPrepare() {
        super.onPrepare()
        endpoint = APIHeaper.API_Discover_Date
    }
}

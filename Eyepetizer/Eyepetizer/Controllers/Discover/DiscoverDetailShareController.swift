//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire
import SwiftyJSON

class DiscoverDetailShareController: BaseDiscoverDetail {
    
    override func onPrepare() {
        super.onPrepare()
        endpoint = APIHeaper.API_Discover_Share
    }
}

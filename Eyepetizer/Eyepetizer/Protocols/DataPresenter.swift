//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol DataPresenter: class {
    var data: [ItemModel] { set get }
    var nextPageUrl: String? { set get }
    func netWork(url: String, parameters: [String : AnyObject]?)
}

extension DataPresenter where Self: UIViewController {
    
    func netWork(url: String, parameters: [String : AnyObject]?) {
        Alamofire.request(.GET, url, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("✅✅✅", response.request?.URL)
                if let value = response.result.value {
                    self.onLoadSuccess(parameters, json: JSON(value))
                }
            case .Failure(let error):
                print("❌❌❌", response.request?.URL)
                self.onLoadFailure(error)
            }
        }
    }
    
     func onLoadSuccess(parameters: [String : AnyObject]?, json: JSON) {
        if let dataDict = json.rawValue as? [String : AnyObject] {
            nextPageUrl = dataDict["nextPageUrl"] as? String
            if let items = dataDict["videoList"] as? NSArray {
                let list = items.map({ (dict) -> ItemModel in
                    ItemModel(dict: dict as? [String : AnyObject])
                })
                if parameters != nil {
                    data = list
                } else {
                    data.appendContentsOf(list)
                }
            }
        }
    }
    
    func onLoadFailure(error: NSError) {
        print("❌❌❌", error.userInfo)
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    }
}

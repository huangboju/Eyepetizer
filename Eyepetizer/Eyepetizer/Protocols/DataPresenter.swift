//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire
import SwiftyJSON

protocol DataPresenter: class {
    var data: [ItemModel] { set get }
    var nextPageUrl: String? { set get }
    var endpoint: String { set get }
    
    //http://swifter.tips/protocol-extension/
    func netWork(url: String, parameters: [String : AnyObject]?)
    func onLoadSuccess(isPaging: Bool, json: JSON)
    func onLoadFailure(error: NSError)
}

extension DataPresenter {
    
    func netWork(url: String, parameters: [String : AnyObject]? = nil) {
        print(url)
        Alamofire.request(.GET, url, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success:
                print("✅✅✅", response.request?.URL)
                if let value = response.result.value {
                    self.success(parameters != nil, json: JSON(value))
                }
            case .Failure(let error):
                print("❌❌❌", response.request?.URL)
                self.failure(error)
            }
        }
    }
    
     func success(isPaging: Bool, json: JSON) {
        if let dataDict = json.rawValue as? [String : AnyObject] {
            nextPageUrl = dataDict["nextPageUrl"] as? String
            if let items = dataDict["videoList"] as? NSArray {
                let list = items.map({ (dict) -> ItemModel in
                    ItemModel(dict: dict as? [String : AnyObject])
                })
                if isPaging {
                    data = list
                } else {
                    data.appendContentsOf(list)
                }
                onLoadSuccess(isPaging, json: json)
            }
        }
    }
    
    func onLoadSuccess(isPaging: Bool, json: JSON) {
    
    }
    
    func failure(error: NSError) {
        onLoadFailure(error)
        print("❌❌❌", error.userInfo)
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    }
    
    func onLoadFailure(error: NSError) {
        
    }
}

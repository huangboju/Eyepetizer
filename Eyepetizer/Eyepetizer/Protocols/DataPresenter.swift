//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire
import SwiftyJSON

typealias DATA = JSON

protocol DataPresenter: class {
    associatedtype AbstractType
    var data: [AbstractType] { set get }
    var nextPageUrl: String? { set get }
    var endpoint: String { set get }
    
    //http://swifter.tips/protocol-extension/
    func netWork(url: String, parameters: [String : AnyObject]?)
    func onLoadSuccess(isPaging: Bool, json: DATA)
    func onLoadFailure(error: NSError)
}

extension DataPresenter {
    
    func netWork(url: String, parameters: [String : AnyObject]? = nil) {
        Alamofire.request(.GET, url, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    print("✅✅✅", response.request?.URL)
                    self.success(parameters != nil, json: JSON(value))
                }
            case .Failure(let error):
                print("❌❌❌", response.request?.URL)
                self.failure(error)
            }
        }
    }
    
     func success(isPaging: Bool, json: JSON) {
        onLoadSuccess(isPaging, json: json)
    }
    
    func onLoadSuccess(isPaging: Bool, json: DATA) {
        //这个方法给外部调用
    }
    
    func failure(error: NSError) {
        onLoadFailure(error)
        print("❌❌❌", error.userInfo)
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    }
    
    func onLoadFailure(error: NSError) {
        //这个方法给外部调用
    }
}

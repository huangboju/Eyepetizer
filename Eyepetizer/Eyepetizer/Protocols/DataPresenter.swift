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
    
    func netWork(url: String, parameters: [String : AnyObject]?, key: String)
    func onLoadSuccess(isPaging: Bool, jsons: [DATA])
    func onLoadFailure(error: NSError)
}

extension DataPresenter {
    
    var nextPageUrl: String? {
        set {
            nextPageUrl = nil
        }
        get {
            return nil
        }
    }
    
    func netWork(url: String, parameters: [String : AnyObject]? = nil, key: String) {
        Alamofire.request(.GET, url, parameters: parameters).validate().responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    print("✅✅✅", response.request?.URL)
                    self.success(parameters != nil, json: JSON(value), key: key)
                }
            case .Failure(let error):
                print("❌❌❌", response.request?.URL)
                self.failure(error)
            }
        }
    }
    
    func success(isPaging: Bool, json: JSON, key: String) {
        if let dict = json.dictionary {
            self.nextPageUrl = dict["nextPageUrl"]?.string
            if let jsons = dict[key]?.arrayValue {
                onLoadSuccess(isPaging, jsons: jsons)
            }
        } else if let jsons = json.array {
            onLoadSuccess(isPaging, jsons: jsons)
        }
    }
    
    func onLoadSuccess(isPaging: Bool, jsons: [DATA]) {
        //这个方法给外部调用
        //写在这里 外部就不必须调用
    }
    
    func failure(error: NSError) {
        onLoadFailure(error)
        print("❌❌❌", error.userInfo)
        print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
    }
    
    func onLoadFailure(error: NSError) {
        //这个方法给外部调用
        //写在这里 外部就不必须调用
    }
}

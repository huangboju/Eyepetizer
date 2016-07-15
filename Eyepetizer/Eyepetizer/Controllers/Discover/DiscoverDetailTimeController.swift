//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class DiscoverDetailTimeController: BaseDiscoverDetail {
    
    override func onPrepare() {
        endpoint = APIHeaper.API_Discover_Date
        super.onPrepare()
    }
    
    override func getData(url: String, parameters: [String : AnyObject]?) {
        print("📶📶📶📶📶📶", url, parameters, "📶📶📶📶📶📶")
        Alamofire.request(.POST, url, parameters: parameters).responseSwiftyJSON ({ [unowned self] (request, response, json, error) in
            // 字典转模型 刷新数据
            if json != .null && error == nil {
                let dataDict = json.rawValue as? [String : AnyObject]
                // 获取下一个url
                if let dataDict = dataDict {
                    self.nextPageUrl = dataDict["nextPageUrl"] as? String
                    let itemArray = dataDict["videoList"] as! NSArray
                    let list = itemArray.map({ (dict) -> ItemModel in
                        return ItemModel(dict: dict as? [String : AnyObject])
                    })
                    if parameters != nil {
                        // 第一次进入
                        self.models = list
                    } else {
                        self.models.appendContentsOf(list)
                        self.collectionView.footerViewEndRefresh()
                    }
                }
                
                self.collectionView.reloadData()
            }
            // 隐藏loadview
            self.setLoaderViewHidden(true)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class DiscoverDetailShareController: BaseDiscoverDetail {

    override func onPrepare() {
        endpoint = APIHeaper.API_Discover_Share
        super.onPrepare()
    }
    
    override func getData(url: String, parameters: [String : AnyObject]?) {
        Alamofire.request(.GET, url, parameters: parameters).responseSwiftyJSON ({ [unowned self](request, response, json, error) -> Void in
            // 字典转模型 刷新数据
            if json != .null && error == nil {
                let dataDict = json.rawValue as? [String : AnyObject]
                // 下一个url
                self.nextPageUrl = dataDict!["nextPageUrl"] as? String
                let itemArray = dataDict!["videoList"] as! NSArray
                // 字典转模型
                let list = itemArray.map({ (dict) -> ItemModel in
                    ItemModel(dict: dict as? [String : AnyObject])
                })
                
                if parameters != nil {
                    self.models = list
                } else {
                    self.models.appendContentsOf(list)
                    self.collectionView.footerViewEndRefresh()
                }
                self.collectionView.reloadData()
            }
            self.setLoaderViewHidden(true)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import Alamofire

class PopularMonthController: PopularBaseController {
    
    override func listViewCreated() {
        collectionView.registerClass(ChoiceHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ChoiceHeaderView.reuseIdentifier)
        collectionView.registerClass(PopularFooterView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: PopularFooterView.reuseIdentifier)
    }

    final override func getData() {
        setLoaderViewHidden(false)
        Alamofire.request(.GET, APIHeaper.API_Popular_Monthly).responseSwiftyJSON ({ [unowned self](request, response, json, error) in
            // 字典转模型 刷新数据
            if json != .null && error == nil {
                if let dataDict = json.rawValue as? [String : AnyObject] {
                    let itemArray = dataDict["videoList"] as! NSArray
                    self.models = itemArray.map({ (dict) -> ItemModel in
                        ItemModel(dict: dict as? [String : AnyObject])
                    })
                    self.collectionView.reloadData()
                }
            }
            self.setLoaderViewHidden(true)
            })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

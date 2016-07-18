//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

struct IssueModel {
    /// 时间
    var date: Int16!
    /// 发布时间
    var publishTime: Int16!
    /// 类型
    var type = ""
    /// 数量
    var cound = 0
    /// 是否有headerview
    var isHaveSectionView = false
    var headerTitle: String?
    var headerImage: String?
    
    var itemList = [ItemModel]()
    
    init(dict: [String : AnyObject]) {
        date = dict["date"] as? Int16 ?? 0
        publishTime = dict["publishTime"] as? Int16 ?? 0
        type = dict["type"] as? String ?? ""
        cound = dict["cound"] as? Int ?? 0
        if let itemArray = dict["itemList"] as? [[String : AnyObject]] {
            self.itemList = itemArray.map({ (dict) -> ItemModel in
                return ItemModel(dict: dict)
            })
        }
        
        // 判断是否有headerview
        let firstItemModel = itemList.first
        if firstItemModel?.type == "video" {
            isHaveSectionView = false
        } else if firstItemModel?.type == "textHeader" {
            isHaveSectionView = true
            itemList.removeFirst()
            headerTitle = firstItemModel?.text
        } else if firstItemModel?.type == "imageHeader" {
            isHaveSectionView = true
            itemList.removeFirst()
            headerImage = firstItemModel?.image
        } else {
            isHaveSectionView = false
        }
    }
}

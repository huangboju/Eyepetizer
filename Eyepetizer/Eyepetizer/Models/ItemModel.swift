//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

struct ItemModel {
    /// 类型
    var type = ""
    
    // data
    
    var image : String?
    var text : String?
    
    var id = 0
    /// 标题
    var title = ""
    /// 描述
    var description = ""
    /// 分类
    var category = ""
    /// 时间
    var duration = 0
    /// url
    var playUrl = ""
    /// 背景图
    var feed = ""
    /// 模糊背景
    var blurred = ""
    /// 副标题
    var subTitle: String {
        get {
          return "#\(category)  /  \(Int.durationToTimer(duration))"
        }
    }
    // 喜欢数
    var collectionCount = 0
    // 分享数
    var shareCount = 0
    // 评论数
    var replyCount = 0
    
    init(dict: [String : AnyObject]?) {
        self.type = dict!["type"] as? String ?? ""
        let dataDict = dict!["data"] as? NSDictionary ?? dict
        if let data = dataDict {
            image = data["image"] as? String ?? nil
            text = data["text"] as? String ?? nil
            id = data["id"] as? Int ?? 0
            title = data["title"] as? String ?? ""
            description = data["description"] as? String ?? ""
            category = data["category"] as? String ?? ""
            duration = data["duration"] as? Int ?? 0
            playUrl = data["playUrl"] as? String ?? ""
            
            // 图片
            let cover = data["cover"] as? [String : AnyObject] ?? nil
            if let coverDic = cover {
                feed = coverDic["feed"] as? String ?? ""
                blurred = coverDic["blurred"] as? String ?? ""
            }
            // 评论喜欢分享数量
            let consumptionDict = data["consumption"] as? [String : AnyObject]
            if let consumption = consumptionDict {
                collectionCount = consumption["collectionCount"] as? Int ?? 0
                shareCount = consumption["shareCount"] as? Int ?? 0
                replyCount = consumption["replyCount"] as? Int ?? 0
            }
            
        }
    }
}

struct IssueModel {
    /// 时间
    var date : Int16!
    /// 发布时间
    var publishTime : Int16!
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

struct EYEChoiceModel {
    var issueList = [IssueModel]()
    /// 下一个page的地址
    var nextPageUrl = ""
    /// 下次更新的时间
    var nextPublishTime : Int16!
    var newestIssueType = ""
    
    init(dict: [String : AnyObject]) {
        self.nextPageUrl = dict["nextPageUrl"] as? String ?? ""
        self.nextPublishTime = dict["nextPublishTime"] as? Int16 ?? 0
        self.newestIssueType = dict["newestIssueType"] as? String ?? ""
        
        let issueArray = dict["issueList"] as! [[String : AnyObject]]
        self.issueList = issueArray.map({ (dict) -> IssueModel in
            return IssueModel(dict: dict)
        })
    }
    
}

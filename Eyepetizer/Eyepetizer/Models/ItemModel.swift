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
    var subTitle = "" {
        get {
            if let _ = category,let _ = duration {
                return "#\(category!)  /  \(Int.durationToTimer(duration!))"
            } else {
                return ""
            }
        }
    }
    // 喜欢数
    var collectionCount = 0
    // 分享数
    var shareCount = 0
    // 评论数
    var replyCount = 0
    
    init(dict : NSDictionary?) {
        self.type = dict!["type"] as? String ?? ""
        let dataDict = dict!["data"] as? NSDictionary ?? dict
        if let data = dataDict {
            self.image = data["image"] as? String ?? nil
            //                    self.image = self.image?.stringByReplacingOccurrencesOfString("jpeg", withString: "png")
            self.text = data["text"] as? String ?? nil
            self.id = data["id"] as? Int ?? 0
            self.title = data["title"] as? String ?? ""
            self.description = data["description"] as? String ?? ""
            self.category = data["category"] as? String ?? ""
            self.duration = data["duration"] as? Int ?? 0
            self.playUrl = data["playUrl"] as? String ?? ""
            
            // 图片
            let cover = data["cover"] as? NSDictionary ?? nil
            if let coverDic = cover {
                self.feed = coverDic["feed"] as? String ?? ""
                self.blurred = coverDic["blurred"] as? String ?? ""
            }
            // 评论喜欢分享数量
            let consumptionDict = data["consumption"] as? NSDictionary
            if let consumption = consumptionDict {
                self.collectionCount = consumption["collectionCount"] as? Int ?? 0
                self.shareCount = consumption["shareCount"] as? Int ?? 0
                self.replyCount = consumption["replyCount"] as? Int ?? 0
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
    
    var itemList : [ItemModel] = [ItemModel]()
    
    init(dict : NSDictionary) {
        self.date = dict["date"] as? Int16 ?? 0
        self.publishTime = dict["publishTime"] as? Int16 ?? 0
        self.type = dict["type"] as? String ?? ""
        self.cound = dict["cound"] as? Int ?? 0
        
        let itemArray = dict["itemList"] as! [NSDictionary]
        self.itemList = itemArray.map({ (dict) -> ItemModel in
            return ItemModel(dict: dict)
        })
        
        // 判断是否有headerview
        let firstItemModel = itemList.first
        if firstItemModel?.type == "video" {
            self.isHaveSectionView = false
        } else if firstItemModel?.type == "textHeader" {
            self.isHaveSectionView = true
            self.itemList.removeFirst()
            self.headerTitle = firstItemModel?.text
        } else if firstItemModel?.type == "imageHeader" {
            self.isHaveSectionView = true
            self.itemList.removeFirst()
            self.headerImage = firstItemModel?.image
        } else {
            self.isHaveSectionView = false
        }
    }
}

struct EYEChoiceModel {
    var issueList : [IssueModel] = [IssueModel]()
    /// 下一个page的地址
    var nextPageUrl = ""
    /// 下次更新的时间
    var nextPublishTime : Int16!
    var newestIssueType = ""
    
    init(dict : NSDictionary) {
        self.nextPageUrl = dict["nextPageUrl"] as? String ?? ""
        self.nextPublishTime = dict["nextPublishTime"] as? Int16 ?? 0
        self.newestIssueType = dict["newestIssueType"] as? String ?? ""
        
        let issueArray = dict["issueList"] as! [NSDictionary]
        self.issueList = issueArray.map({ (dict) -> IssueModel in
            return IssueModel(dict: dict)
        })
    }
    
}

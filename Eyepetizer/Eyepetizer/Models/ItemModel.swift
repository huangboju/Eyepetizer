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
        guard let dict = dict else {
            return
        }
        self.type = dict["type"] as? String ?? ""
        let dataDict = dict["data"] as? [String : AnyObject] ?? dict
        image = dataDict["image"] as? String ?? nil
        text = dataDict["text"] as? String ?? nil
        id = dataDict["id"] as? Int ?? 0
        title = dataDict["title"] as? String ?? ""
        description = dataDict["description"] as? String ?? ""
        category = dataDict["category"] as? String ?? ""
        duration = dataDict["duration"] as? Int ?? 0
        playUrl = dataDict["playUrl"] as? String ?? ""
        
        // 图片
        let coverDict = dataDict["cover"] as? [String : AnyObject] ?? nil
        if let cover = coverDict {
            feed = cover["feed"] as? String ?? ""
            blurred = cover["blurred"] as? String ?? ""
        }
        // 评论喜欢分享数量
        let consumptionDict = dataDict["consumption"] as? [String : AnyObject]
        if let consumption = consumptionDict {
            collectionCount = consumption["collectionCount"] as? Int ?? 0
            shareCount = consumption["shareCount"] as? Int ?? 0
            replyCount = consumption["replyCount"] as? Int ?? 0
        }
    }
}

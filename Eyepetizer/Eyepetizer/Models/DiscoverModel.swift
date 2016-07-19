//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

struct DiscoverModel {
    var id = 0
    /// 分类名
    var name = ""
    /// 化名
    var alias = ""
    /// 背景图
    var bgPicture = ""
    /// 背景色
    var bgColor = ""
    
    init(dict: [String : AnyObject]?) {
        id = dict?["id"] as? Int ?? 0
        name = dict?["name"] as? String ?? ""
        alias = dict?["alias"] as? String ?? ""
        bgPicture = dict?["bgPicture"] as? String ?? ""
        bgColor = dict?["bgColor"] as? String ?? ""
    }
}

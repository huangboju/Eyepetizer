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
    
    init(dict: [String : DATA]?) {
        id = dict?["id"]?.int ?? 0
        name = dict?["name"]?.string ?? ""
        alias = dict?["alias"]?.string ?? ""
        bgPicture = dict?["bgPicture"]?.string ?? ""
        bgColor = dict?["bgColor"]?.string ?? ""
    }
}

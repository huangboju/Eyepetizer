//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

struct ChoiceModel {
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

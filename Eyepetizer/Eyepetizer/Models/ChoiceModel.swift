//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

struct ChoiceModel {
    var issueList = [IssueModel]()
    /// 下一个page的地址
    var nextPageUrl = ""
    /// 下次更新的时间
    var nextPublishTime: Int16!
    var newestIssueType = ""
    
    init(dict: [String : DATA]) {
        nextPageUrl = dict["nextPageUrl"]?.string ?? ""
        nextPublishTime = dict["nextPublishTime"]?.int16 ?? 0
        newestIssueType = dict["newestIssueType"]?.string ?? ""
        
        if let issueArray = dict["issueList"]?.array {
            issueList = issueArray.map({ (dict) -> IssueModel in
                return IssueModel(dict: dict.dictionary)
            })
        }
    }
    
}

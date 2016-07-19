//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

func getEndpoint(url: String, parameters: [String : AnyObject]) -> String {
    var enpoint = url
    
    for key in Array(parameters.keys) {
        enpoint += ("&" + key + "=" + "\(parameters[key]!)")
    }
    return enpoint
}

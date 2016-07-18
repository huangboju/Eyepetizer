//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

extension Int {
    static func durationToTimer(duration: Int) -> String {
        return "\(String(format: "%02d", duration / 60))' \(String(format: "%02d", duration % 60))\""
    }
}

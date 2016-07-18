//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

extension NSDate {
    class func getCurrentTimeStamp() -> String {
        return "\(Int64(floor(NSDate().timeIntervalSince1970 * 1000)))"
    }
    
    ///获取当前年月日
    class func getCurrentDate() -> String {
        let formatter = NSDateFormatter()
        formatter.dateFromString("yyyy-MM-dd")
        return formatter.stringFromDate(NSDate())
    }
    
    ///将时间转换为时间戳
    class func change2TimeStamp(date : String) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFromString("yyyy-MM-dd")
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        
        let dateNow = formatter.dateFromString(date)
        return "\(dateNow?.timeIntervalSince1970)000"
    }
    
    ///将时间戳转化成时间
    class func change2Date(timestamp: String) -> String {
        guard timestamp.length > 3 else {
            return ""
        }
        
        let newTimestamp = timestamp.substringFromIndex(timestamp.endIndex.advancedBy(-3))
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        formatter.dateFromString("yyyy-MM-dd HH:mm:ss")
        let dateStart = NSDate(timeIntervalSince1970: Double(newTimestamp)!)
        return formatter.stringFromDate(dateStart)
    }
}

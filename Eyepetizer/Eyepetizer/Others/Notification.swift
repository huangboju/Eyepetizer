//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

protocol Notifier {
    associatedtype Notification: RawRepresentable
}

extension Notifier where Notification.RawValue == String {

    static func nameFor(notification: Notification) -> String {
        return "\(self).\(notification.rawValue)"
    }
    
    func postNotification(notification: Notification, object: AnyObject? = nil) {
        Self.postNotification(notification, object: object)
    }
    
    func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        Self.postNotification(notification, object: object, userInfo: userInfo)
    }
    
    static func postNotification(notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        let name = nameFor(notification)
        
        NSNotificationCenter.defaultCenter().postNotificationName(name, object: object, userInfo: userInfo)
    }
    
    static func addObserver(observer: AnyObject, selector: Selector, notification: Notification) {
        let name = nameFor(notification)
        
        NSNotificationCenter.defaultCenter().addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    static func removeObserve(observe: AnyObject, nofification: Notification, object: AnyObject? = nil) {
        let name = nameFor(nofification)
        
        NSNotificationCenter.defaultCenter().removeObserver(observe, name: name, object: object)
    }
}

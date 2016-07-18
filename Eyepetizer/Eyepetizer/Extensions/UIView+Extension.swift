//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

extension UIView {
    public func viewAddTarget(target: AnyObject,action: Selector) {
        let tap = UITapGestureRecognizer(target: target, action: action)
        userInteractionEnabled = true
        addGestureRecognizer(tap)
    }
}

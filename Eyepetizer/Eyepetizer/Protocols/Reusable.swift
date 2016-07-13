//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(Self)
    }
}

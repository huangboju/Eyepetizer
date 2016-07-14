//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

extension UILabel {
    func boundingRectWithSize(size: CGSize) -> CGSize {
        return (text! as NSString).boundingRectWithSize(size, options: [.UsesLineFragmentOrigin, .UsesFontLeading], attributes: [NSFontAttributeName : font], context: nil).size
    }
}

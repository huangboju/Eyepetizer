//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class APPImageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .ScaleAspectFit
    }
    
    override init(image: UIImage?) {
        super.init(image: image)
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

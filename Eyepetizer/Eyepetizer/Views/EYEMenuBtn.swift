//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

public enum EYEMenuBtnType {
    case None, Date
}

class EYEMenuBtn: UIButton {
    private var type: EYEMenuBtnType = .None
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel?.font = UIFont.customFont_Lobster()
        setTitleColor(UIColor.blackColor(), forState: .Normal)
        setImage(R.image.ic_action_menu(), forState: .Normal)
    }
    
    convenience init(frame: CGRect, type: EYEMenuBtnType) {
        self.init(frame: frame)
        self.type = type
        
        if type == .Date {
            setTitle("Today", forState: .Normal)
        }
    }
    
    //注意：不要直接调用这些方法， 这些方法是你写给系统调用的。
    
    /// 指定文字标题边界
    override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
        if type == .Date {
            return CGRect(x: frame.height - MARGIN_10, y: 0, width: frame.width - frame.height + MARGIN_10, height: frame.height)
        }
        return CGRect.zero
    }
    
    ///指定按钮图像边界
    override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: frame.height, height: frame.height)
    }
    
    ///指定背景边界
    //    override func backgroundRectForBounds(bounds: CGRect) -> CGRect {
    //
    //    }
    
    /// 指定内容边界
//    override func contentRectForBounds(bounds: CGRect) -> CGRect {
//
//    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
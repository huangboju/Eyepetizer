//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class MenuHeaderView: UIView {
    private lazy var backgroundIconView: UIView = {
        let backgroundIconView = UIView()
        backgroundIconView.backgroundColor = UIColor.lightGrayColor()
        backgroundIconView.layer.borderColor = UIColor.whiteColor().CGColor
        backgroundIconView.layer.borderWidth = 2
        return backgroundIconView
    }()
    
    private lazy var IconView: UIImageView = {
        let IconView = UIImageView(image: R.image.ic_action_focus_white())
        IconView.contentMode = .ScaleAspectFit
        return IconView
    }()
    
    private lazy var loginLabel: UILabel = {
        let loginLabel = UILabel()
        loginLabel.text = "点击登录后可评论"
        loginLabel.textAlignment = .Center
        loginLabel.textColor = UIColor.blackColor()
        loginLabel.font = UIFont.customFont_FZLTXIHJW(fontSize: SYSTEM_FONT_SIZE)
        return loginLabel
    }()
    
    private lazy var lineView: UIView = {
        var lineView = UIView()
        lineView.backgroundColor = UIColor.lightGrayColor()
        return lineView
    }()
    
    private lazy var collectionLabel: UILabel = {
        let collectionLabel = UILabel()
        collectionLabel.textAlignment = .Center
        collectionLabel.text = "我的收藏"
        collectionLabel.font = UIFont.customFont_FZLTXIHJW(fontSize: SYSTEM_FONT_SIZE)
        collectionLabel.textColor = UIColor.blackColor()
        return collectionLabel
    }()
    
    private lazy var commentLabel: UILabel = {
        let commentLabel = UILabel()
        commentLabel.textAlignment = .Center
        commentLabel.text = "我的评论"
        commentLabel.font = UIFont.customFont_FZLTXIHJW(fontSize: SYSTEM_FONT_SIZE)
        commentLabel.textColor = UIColor.blackColor()
        return commentLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
        addSubview(backgroundIconView)
        backgroundIconView.snp_makeConstraints { [unowned self] make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(TINY_FONT_SIZE)
        }
        backgroundIconView.layer.cornerRadius = 50
        
        backgroundIconView.addSubview(IconView)
        IconView.snp_makeConstraints { (make) in
            make.edges.equalTo(backgroundIconView)
        }
        
        addSubview(loginLabel)
        loginLabel.snp_makeConstraints { [unowned self] (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(self.backgroundIconView.snp_bottom).offset(TINY_FONT_SIZE)
            make.height.equalTo(20)
        }
        
        addSubview(lineView)
        lineView.snp_makeConstraints { [unowned self] (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.loginLabel.snp_bottom).offset(MARGIN_20)
            make.width.equalTo(1)
            make.height.equalTo(20)
        }
        
        let width = (SCREEN_WIDTH - 2 * MARGIN_20 - 1) / 2
        
        addSubview(collectionLabel)
        collectionLabel.snp_makeConstraints { [unowned self] (make) in
            make.width.equalTo(width)
            make.right.equalTo(self.lineView.snp_left)
            make.top.equalTo(self.loginLabel.snp_bottom).offset(MARGIN_20)
            make.height.equalTo(20)
        }
        
        addSubview(commentLabel)
        commentLabel.snp_makeConstraints { [unowned self] (make) in
            make.size.equalTo(self.collectionLabel)
            make.top.equalTo(self.collectionLabel.snp_top)
            make.right.equalTo(self).offset(-MARGIN_20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

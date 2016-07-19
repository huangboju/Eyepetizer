//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import  SnapKit

class ChoiceCell: UICollectionViewCell {
    var model: ItemModel? {
        didSet {
            if let feed = model?.feed {
                backgroundImageView.yy_setImageWithURL(NSURL(string: feed)!, options: .ProgressiveBlur)
            } else {
                if let image = model?.image {
                    backgroundImageView.yy_setImageWithURL(NSURL(string: image)!, options: .ProgressiveBlur)
                    subTitleLabel.hidden = true
                }
            }
            titleLabel.text = model?.title
            subTitleLabel.text = model?.subTitle
        }
    }
    
    var index: String? {
        didSet {
            indexView.hidden = false
            indexLabel.text = index
        }
    }
    
    lazy var backgroundImageView: UIImageView = {
        let background = UIImageView()
        return background
    }()
    
    lazy var coverButton: UIButton = {
        let coverButton = UIButton()
        coverButton.userInteractionEnabled = false
        coverButton.backgroundColor = UIColor.blackColor()
        coverButton.alpha = 0.3
        return coverButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.text = "标题"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font = UIFont.customFont_FZLTZCHJW(fontSize: SYSTEM_FONT_SIZE)
        return titleLabel
    }()
    
    lazy var subTitleLabel: UILabel = {
        let subTitleLabel = UILabel()
        subTitleLabel.textAlignment = .Center
        subTitleLabel.text = "副标题"
        subTitleLabel.textColor = UIColor.whiteColor()
        subTitleLabel.font = UIFont.customFont_FZLTXIHJW()
        return subTitleLabel
    }()
    
    private lazy var topLine: UIView = {
        let topLine = UIView()
        topLine.backgroundColor = UIColor.whiteColor()
        return topLine
    }()
    
    private lazy var bottomLine: UIView = {
        var bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.whiteColor()
        return bottomLine
    }()
    
    private lazy var indexLabel: UILabel = {
        var indexLabel = UILabel()
        indexLabel.textColor = UIColor.whiteColor()
        indexLabel.textAlignment = .Center
        indexLabel.font = UIFont.customFont_Lobster(fontSize: SYSTEM_FONT_SIZE)
        return indexLabel
    }()
    
    private lazy var indexView: UIView = {
        let indexView = UIView()
        indexView.hidden = true
        indexView.backgroundColor = UIColor.clearColor()
        indexView.addSubview(self.indexLabel)
        indexView.addSubview(self.topLine)
        indexView.addSubview(self.bottomLine)
        return indexView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundImageView)
        contentView.addSubview(coverButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(indexView)
        
        backgroundImageView.snp_makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(contentView)
        }
        
        coverButton.snp_makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(contentView)
        }
        
        titleLabel.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(20)
            make.centerY.equalTo(contentView.center).offset(-10)
        }
        
        subTitleLabel.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(20)
            make.centerY.equalTo(contentView.center).offset(10)
        }
        
        indexView.snp_makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(contentView).offset(-30)
            make.height.equalTo(30)
        }
        
        indexLabel.snp_makeConstraints { (make) in
            make.edges.equalTo(indexView)
        }
        
        topLine.snp_makeConstraints { (make) in
            make.top.equalTo(indexView)
            make.height.equalTo(0.5)
            make.width.equalTo(30)
            make.centerX.equalTo(indexView.center)
        }
        
        bottomLine.snp_makeConstraints { (make) in
            make.bottom.equalTo(indexView)
            make.leading.trailing.equalTo(topLine)
            make.size.equalTo(topLine)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImageView.image = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

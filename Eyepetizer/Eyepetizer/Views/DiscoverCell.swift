//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class DiscoverCell: UICollectionViewCell {
    private var backgroundImageView: UIImageView = {
        let backgroundImageView = UIImageView()
        return backgroundImageView
    }()
    
    private lazy var coverButton: UIButton = {
        let coverButton = UIButton()
        coverButton.userInteractionEnabled = false
        coverButton.backgroundColor = UIColor.blackColor()
        coverButton.alpha = 0.3
        return coverButton
    }()
    
    private var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = .Center
        return titleLabel
    }()
    
    var model: DiscoverModel! {
        didSet {
            self.backgroundImageView.yy_setImageWithURL(NSURL(string: model.bgPicture)!, options: .ProgressiveBlur)
            self.titleLabel.text = model.name
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundImageView)
        backgroundImageView.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        contentView.addSubview(coverButton)
        coverButton.snp_makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(20)
            make.centerY.equalTo(contentView.center).offset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

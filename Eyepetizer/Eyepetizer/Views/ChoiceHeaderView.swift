//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class ChoiceHeaderView: UICollectionReusableView, Reusable {
    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textAlignment = .Center
        titleLabel.font = UIFont.customFont_Lobster(fontSize: LABEL_FONT_SIZE)
        return titleLabel
    }()
    
    private lazy var imageView: APPImageView = {
        let imageView = APPImageView()
        return imageView
    }()
    
    var title: String? {
        didSet {
            if let title = title {
                imageView.hidden = true
                titleLabel.hidden = false
                titleLabel.text = title
            } else {
                imageView.hidden = false
                titleLabel.hidden = true
            }
        }
    }
    
    var image: String? {
        didSet {
            if let image = image {
                titleLabel.hidden = true
                imageView.hidden = false
                imageView.yy_setImageWithURL(NSURL(string: image)!, options: .ProgressiveBlur)
            } else {
                titleLabel.hidden = false
                imageView.hidden = true
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
       
        addSubview(titleLabel)
        titleLabel.snp_makeConstraints { [unowned self] (make) in
            make.edges.equalTo(self)
        }
        
        addSubview(imageView)
        imageView.snp_makeConstraints { [unowned self] (make) in
            make.leading.trailing.equalTo(self)
            make.top.equalTo(self).offset(frame.height * 0.25)
            make.height.equalTo(frame.height * 0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

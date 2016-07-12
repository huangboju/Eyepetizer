//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

protocol EYEVideoDetailViewDelegate: class {
    func playImageViewDidClick()
    func backBtnDidClick()
}

class EYEVideoDetailView: UIView {
    weak var delegate: EYEVideoDetailViewDelegate!
    private var items = [BottomItemBtn]()
    private var bottomImages = [
        R.image.ic_action_favorites_without_padding(),
        R.image.ic_action_share_without_padding(),
        R.image.ic_action_reply_nopadding(),
        R.image.action_download_cut()
    ]
    
    lazy var albumImageView: UIImageView = {
        let photoW: CGFloat = 1222.0
        let photoH: CGFloat = 777.0
        let albumImageViewH = self.frame.height * 0.6
        let albumImageViewW = photoW * albumImageViewH / photoH
        let albumImageViewX = (albumImageViewW - self.frame.width) * 0.5
        let albumImageView = UIImageView(frame: CGRect(x: -albumImageViewX, y: 0, width: albumImageViewW, height: albumImageViewH))
        albumImageView.clipsToBounds = true
        albumImageView.contentMode = .ScaleAspectFill
        albumImageView.userInteractionEnabled = true
        return albumImageView
    }()
    
    lazy var blurImageView: UIImageView = {
        let blurImageView = UIImageView(frame: CGRect(x: 0, y: self.albumImageView.frame.height, width: self.frame.width, height: self.frame.height - self.albumImageView.frame.height))
        return blurImageView
    }()
    
    lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .Light)
        var blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.blurImageView.frame
        return blurView
    }()
    
    lazy var backBtn: UIButton = {
        let backBtn = UIButton(frame: CGRect(x: MARGIN_10, y: MARGIN_20, width: 40, height: 40))
        backBtn.setImage(R.image.play_back_full(), forState: .Normal)
        backBtn.addTarget(self, action: #selector(backBtnDidClick), forControlEvents: .TouchUpInside)
        return backBtn
    }()
    
    lazy var playImageView: UIImageView = {
        var playImageView = UIImageView(image: UIImage(named: "ic_action_play"))
        playImageView.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        playImageView.center = self.albumImageView.center
        playImageView.contentMode = .ScaleAspectFit
        playImageView.viewAddTarget(self, action: #selector(playImageViewDidClick))
        return playImageView
    }()
    
    lazy var videoTitleLabel: EYEShapeView = {
        let rect = CGRect(x: MARGIN_10, y: self.albumImageView.frame.maxY + MARGIN_10, width: self.frame.width - 2 * MARGIN_10, height: 20)
        let font = UIFont.customFont_FZLTZCHJW(fontSize: LABEL_FONT_SIZE)
        var videoTitleLabel = EYEShapeView(frame: rect)
        videoTitleLabel.font = font
        videoTitleLabel.fontSize = LABEL_FONT_SIZE
        return videoTitleLabel
    }()
    
    private lazy var lineView: UIView = {
        var lineView = UIView(frame: CGRect(x: MARGIN_10, y: self.videoTitleLabel.frame.maxY + MARGIN_10, width: self.frame.width - 2 * MARGIN_10, height: 0.5))
        lineView.backgroundColor = UIColor.whiteColor()
        return lineView
    }()
    
    lazy var classifyLabel: UILabel = {
        var classifyLabel = UILabel(frame: CGRect(x: MARGIN_10, y: self.lineView.frame.maxY + MARGIN_10, width: self.frame.width - 2 * MARGIN_10, height: 20))
        classifyLabel.textColor = UIColor.whiteColor()
        classifyLabel.font = UIFont.customFont_FZLTXIHJW()
        return classifyLabel
    }()
    
    lazy var describeLabel: UILabel = {
        var describeLabel = UILabel(frame: CGRect(x: MARGIN_10, y: self.classifyLabel.frame.maxY + MARGIN_10, width: self.frame.width - 2 * MARGIN_10, height: 200))
        describeLabel.numberOfLines = 0
        describeLabel.textColor = UIColor.whiteColor()
        describeLabel.font = UIFont.customFont_FZLTXIHJW()
        return describeLabel
    }()
    
    lazy var bottomToolView: UIView = {
        var bottomToolView = UIView(frame: CGRect(x: 0, y: self.frame.height - 50, width: self.frame.width, height: 30))
        bottomToolView.backgroundColor = UIColor.clearColor()
        return bottomToolView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(albumImageView)
        addSubview(blurImageView)
        addSubview(blurView)
        addSubview(backBtn)
        addSubview(playImageView)
        addSubview(videoTitleLabel)
        addSubview(lineView)
        addSubview(classifyLabel)
        addSubview(describeLabel)
        addSubview(bottomToolView)
    }
    
    var model: ItemModel! {
        didSet {
        }
    }
    
    func backBtnDidClick() {
        delegate.backBtnDidClick()
    }
    
    func playImageViewDidClick() {
        delegate.playImageViewDidClick()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private class BottomItemBtn: UIButton {
        private var title: String?
        private var image: UIImage?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor.clearColor()
            titleLabel?.font = UIFont.customFont_FZLTXIHJW()
            setTitleColor(UIColor.whiteColor(), forState: .Normal)
        }
        
        convenience init(frame: CGRect, title: String, image: UIImage) {
            self.init(frame: frame)
            self.title = title
            self.image = image
            
            setImage(image, forState: .Normal)
            setTitle(title, forState: .Normal)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private override func titleRectForContentRect(contentRect: CGRect) -> CGRect {
            return CGRect(x: frame.height - 8, y: 0, width: frame.width - frame.height + 8, height: frame.height)
        }
        
        private override func imageRectForContentRect(contentRect: CGRect) -> CGRect {
            return CGRect(x: 0, y: 8, width: frame.height - 16, height: frame.height - 16)
        }
    }
}

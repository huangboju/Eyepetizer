//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEPopularHeaderView: UIView {
    typealias HeaderViewBtnClickhandle = (targetBtn: UIButton, index : Int) -> Void
    private var titles = [String]()
    private var titleLabels = [UIButton]()
    private var handle: HeaderViewBtnClickhandle?
    private var isAnimation = false
    private var currentBtn: UIButton!
    
    private lazy var topLineView: UIView = {
        let topLineView = UIView()
        topLineView.backgroundColor = UIColor.blackColor()
        topLineView.frame = CGRect(x: 0, y: 0, width: 35, height: 0.5)
        topLineView.center = CGPoint(x: self.titleLabels.first!.center.x, y: 12)
        return topLineView
    }()
    
    private lazy var bottomLineView: UIView = {
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = UIColor.blackColor()
        bottomLineView.frame = CGRect(x: 0, y: 0, width: 35, height: 0.5)
        bottomLineView.center = CGPoint(x: self.titleLabels.first!.center.x, y: self.frame.height-12)
        return bottomLineView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clearColor()
    }
    
    convenience init(frame: CGRect, titles: [String]) {
        self.init(frame: frame)
        self.titles = titles
        let itemWidth = (frame.width - 2 * MARGIN_20) / CGFloat(titles.count)
        for i in 0..<titles.count {
            let title = titles[i]
            let titleButton = UIButton(frame: CGRect(x: MARGIN_20 + CGFloat(i) * itemWidth, y: 0, width: itemWidth, height: frame.height))
            titleButton.backgroundColor = UIColor.clearColor()
            titleButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            titleButton.tag = i
            titleButton.setTitle(title, forState: .Normal)
            titleButton.titleLabel?.font = UIFont.customFont_FZLTXIHJW()
            titleButton.addTarget(self, action: #selector(titleBtnDidClick), forControlEvents: .TouchUpInside)
            addSubview(titleButton)
            titleLabels.append(titleButton)
        }
        
        currentBtn = titleLabels.first
        
        addSubview(topLineView)
        addSubview(bottomLineView)
    }
    
    func titleBtnDidClick (sender: UIButton) {
        guard isAnimation == false && sender != self.currentBtn else {
            return
        }
        
        self.startAnimation(sender.tag)
        
        if let handle = handle {
            handle(targetBtn: sender, index: sender.tag)
        }
        
        currentBtn = sender
    }
    
    func headerViewTitleDidClick(handle: HeaderViewBtnClickhandle?) {
        self.handle = handle
    }
    
    private func startAnimation(index: Int) {
        self.isAnimation = true
        let button = self.titleLabels[index]
        UIView.animateWithDuration(0.4, delay: 0, options: .CurveEaseIn, animations: {
            self.topLineView.center.x = button.center.x
            self.bottomLineView.center.x = button.center.x
        }) { (_) in
            self.isAnimation = false
        }
    }
    
    func setupLineViewWidth(width: CGFloat) {
        bottomLineView.frame.size.width = width
        topLineView.frame.size.width = width
        bottomLineView.center = CGPoint(x: titleLabels.first!.center.x, y: frame.height-12)
        topLineView.center = CGPoint(x: titleLabels.first!.center.x, y: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

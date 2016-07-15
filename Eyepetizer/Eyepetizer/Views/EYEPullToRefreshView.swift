//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

var animationDuration: NSTimeInterval = 0.3
var pullToRefreshHeight: CGFloat = 80

let refreshHeaderTimeKey = "RefreshHeaderView"
let refreshContentOffset = "contentOffset"
let refreshContentSize = "contentSize"

enum PullToRefreshViewType {
    case  Header, Footer
}
enum PullToRefreshViewState {
    case  Normal, Pulling, Refreshing
}

//MARK: - EYEPullToRefreshView
class EYEPullToRefreshView: UIView {
    typealias beginRefreshingBlock = () -> Void
    var loadView: EYELoaderView!
    var beginRefreshingCallback: beginRefreshingBlock?
    var oldState: PullToRefreshViewState! = .Normal
    private var scrollView: UIScrollView!
    private var scrollViewOriginalInset: UIEdgeInsets!
    
    var state: PullToRefreshViewState = .Normal {
        willSet {
            self.state = newValue
        }
        didSet {
            guard state != oldState else {
                return
            }
            switch state {
            case .Normal:
                loadView.stopLoadingAnimation()
            case .Pulling:
                break
            case .Refreshing:
                loadView.startLoadingAnimation()
                if let beginRefreshingCallback = beginRefreshingCallback {
                    beginRefreshingCallback()
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadView = EYELoaderView(frame: CGRect(origin: CGPoint.zero, size: frame.size))
        loadView.center = center
        addSubview(loadView)
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if superview != nil {
            superview?.removeObserver(self, forKeyPath: refreshContentOffset)
        }
        if let newSuperview = newSuperview {
            newSuperview.addObserver(self, forKeyPath: refreshContentOffset, options: .New, context: nil)
            var rect = frame
            rect.size.width = newSuperview.frame.width
            rect.origin.x = 0
            frame = rect
            
            scrollView = newSuperview as? UIScrollView
            scrollViewOriginalInset = scrollView.contentInset
        }
    }
    
    func isRefresh() -> Bool {
        return state == .Refreshing
    }
    
    func beginRefreshing(){
        if window != nil {
            state = .Refreshing
        } else {
            state = .Normal
            super.setNeedsDisplay()
        }
    }
    
    func endRefreshing() {
        if state == .Normal {
            return
        }
        
        let delayInSeconds: Double = 0.3
        let popTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds))
        dispatch_after(popTime, dispatch_get_main_queue(), {
            self.state = .Normal
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - EYEPullToRefreshHeaderView
class EYEPullToRefreshHeaderView: EYEPullToRefreshView {
    override var state: PullToRefreshViewState {
        willSet {
            oldState = state
        }
        
        didSet {
            switch state {
            case .Normal:
                if PullToRefreshViewState.Refreshing == oldState {
                    UIView.animateWithDuration(animationDuration, animations: {
                        var contentInset = self.scrollView.contentInset
                        contentInset.top = self.scrollViewOriginalInset.top + TOP_BAR_HEIGHT
                        self.scrollView.contentInset = contentInset
                    })
                    
                }
                
            case .Pulling:
                break
            case .Refreshing:
                UIView.animateWithDuration(animationDuration, animations: {
                    let top:CGFloat = self.scrollViewOriginalInset.top + self.frame.height
                    var inset = self.scrollView.contentInset
                    inset.top = top + NAV_BAR_HEIGHT
                    self.scrollView.contentInset = inset
                    var offset = self.scrollView.contentOffset
                    offset.y = -top - NAV_BAR_HEIGHT
                    self.scrollView.contentOffset = offset
                })
            }
        }
    }
    
    class func headerView() -> EYEPullToRefreshHeaderView {
        return EYEPullToRefreshHeaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pullToRefreshHeight))
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        var rect = frame
        rect.origin.y = -pullToRefreshHeight
        frame = rect
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard state != .Refreshing else {
            return
        }
        
        guard refreshContentOffset == keyPath else {
            return
        }
        
        let currentOffsetY = scrollView.contentOffset.y + NAV_BAR_HEIGHT
        
        if currentOffsetY >= 0 {
            return
        }
        
        if self.scrollView.dragging {
            let happenOffSetY = fabs(currentOffsetY)
            if state == .Normal && happenOffSetY > pullToRefreshHeight {
                state = .Pulling
            } else if state == .Pulling && happenOffSetY <= pullToRefreshHeight {
                state = .Normal
            } else if state == .Normal && happenOffSetY < pullToRefreshHeight {
                state = .Normal
            }
        } else if state == .Pulling {
            state = .Refreshing
        }
    }
}

//MARK: - EYEPullToRefreshFooterView
class EYEPullToRefreshFooterView: EYEPullToRefreshView {
    
    private var lastRefreshCount = 0
    
    override var state: PullToRefreshViewState {
        willSet {
            oldState = state
        }
        
        didSet {
            switch state {
            case .Normal:
                if .Refreshing == oldState {
                    UIView.animateWithDuration(animationDuration, animations: {
                        self.scrollView.contentInset.bottom = self.scrollViewOriginalInset.bottom
                    })
                    
                    let deltaH = self.heightForContentBreakView()
                    let currentCount = self.totalDataCountInScrollView()
                    
                    if (deltaH > 0  && currentCount != self.lastRefreshCount) {
                        var offset = self.scrollView.contentOffset
                        offset.y = self.scrollView.contentOffset.y
                        self.scrollView.contentOffset = offset
                    }
                }
            case .Pulling:
                break
            case .Refreshing:
                lastRefreshCount = totalDataCountInScrollView()
                UIView.animateWithDuration(animationDuration, animations: { [unowned self] in
                    var bottom = self.frame.height + self.scrollViewOriginalInset.bottom
                    let deltaH = self.heightForContentBreakView()
                    if deltaH < 0 {
                        bottom = bottom - deltaH
                    }
                    var inset = self.scrollView.contentInset
                    inset.bottom = bottom
                    self.scrollView.contentInset = inset
                })
            }
        }
    }
    
    class func footerView() -> EYEPullToRefreshFooterView {
        return EYEPullToRefreshFooterView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: pullToRefreshHeight))
    }
    
    override func willMoveToSuperview(newSuperview: UIView?) {
        super.willMoveToSuperview(newSuperview)
        if let superview = superview {
            superview.removeObserver(self, forKeyPath: refreshContentSize)
        }
        if newSuperview != nil {
            newSuperview?.addObserver(self, forKeyPath: refreshContentSize, options: .New, context: nil)
            resetFrameWithContentSize()
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == refreshContentSize {
            resetFrameWithContentSize()
        } else if keyPath == refreshContentOffset {
            guard state != .Refreshing else {
                return
            }
            
            let currentOffsetY  = scrollView.contentOffset.y
            let happenOffsetY = self.happenOffsetY()
            
            if currentOffsetY <= happenOffsetY {
                return
            }
            
            if scrollView.dragging {
                let normal2pullingOffsetY =  happenOffsetY + self.frame.size.height
                if state == .Normal && currentOffsetY > normal2pullingOffsetY {
                    state = .Pulling
                } else if (state == .Pulling && currentOffsetY <= normal2pullingOffsetY) {
                    state = .Normal
                }
            } else if (state == .Pulling) {
                state = .Refreshing
            }
        }
    }
    
    private func resetFrameWithContentSize() {
        let contentHeight = scrollView.contentSize.height
        let scrollHeight = scrollView.frame.height  - scrollViewOriginalInset.top - scrollViewOriginalInset.bottom
        
        var rect = frame
        rect.origin.y =  contentHeight > scrollHeight ? contentHeight : scrollHeight
        frame = rect
    }
    
    private func heightForContentBreakView() -> CGFloat {
        let h  = scrollView.frame.height - scrollViewOriginalInset.bottom - scrollViewOriginalInset.top
        return scrollView.contentSize.height - h
    }
    
    private func happenOffsetY() -> CGFloat {
        let deltaH = heightForContentBreakView()
        return (deltaH > 0 ? deltaH  : 0) - scrollViewOriginalInset.top
    }
    
    private func totalDataCountInScrollView() -> Int {
        var totalCount: Int = 0
        if scrollView is UITableView {
            guard let tableView = self.scrollView as? UITableView else {
                return 0
            }
            
            for i in 0..<tableView.numberOfSections {
                totalCount = totalCount + tableView.numberOfRowsInSection(i)
            }
        } else if self.scrollView is UICollectionView {
            guard let collectionView = scrollView as? UICollectionView else {
                return 0
            }
            for i in 0..<collectionView.numberOfSections() {
                totalCount = totalCount + collectionView.numberOfItemsInSection(i)
            }
        }
        return totalCount
    }
}

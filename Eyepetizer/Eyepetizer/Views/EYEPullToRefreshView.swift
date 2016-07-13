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

class EYEPullToRefreshView: UIView {
    typealias beginRefreshingBlock = () -> Void
    var loadView: EYELoaderView!
    var beginRefreshingCallback: beginRefreshingBlock?
    var oldState: PullToRefreshViewState! = .Normal
    
    var state: PullToRefreshViewState = .Normal {
        willSet {
            self.state = newValue
        }
        didSet {
            guard state != oldState else {
                return
            }
            switch self.state {
            case .Normal:
                loadView.stopLoadingAnimation()
            case .Pulling:
                break
            case .Refreshing:
                loadView.startLoadingAnimation()
                
                if let callBack = beginRefreshingCallback {
                    callBack()
                }
            }
        }
    }
    
    
    private var scrollView: UIScrollView!
    private var scrollViewOriginalInset: UIEdgeInsets!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView = EYELoaderView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
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
    
    func endRefreshing(){
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

class EYEPullToRefreshHeaderView: EYEPullToRefreshView {
    <#code#>
}

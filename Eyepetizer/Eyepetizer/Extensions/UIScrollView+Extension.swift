//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

extension UIScrollView {
    //MARK: --------------------------- 下拉刷新 --------------------------
    func headerViewPulltoRefresh(handle: (() -> Void)?) {
        let headerView = EYEPullToRefreshHeaderView.headerView()
        headerView.beginRefreshingCallback = handle
        headerView.state = .Normal
        addSubview(headerView)
    }
    
    func headerViewBeginRefreshing() {
        getHeaderView {
            $0?.beginRefreshing()
        }
    }
    
    func headerViewEndRefresh() {
        getHeaderView {
            $0?.endRefreshing()
        }
    }
    
    //MARK: -------------------------  上拉加载更多 ------------------------
    func footerViewPullToRefresh(callback: (() -> Void)?) {
        let footView = EYEPullToRefreshFooterView.footerView()
        footView.beginRefreshingCallback = callback
        footView.state = .Normal
        addSubview(footView)
    }
    
    func footerBeginRefreshing() {
        getFooterView {
            $0?.beginRefreshing()
        }
    }
    
    func footerViewEndRefresh() {
        getFooterView {
            $0?.endRefreshing()
        }
    }
    
    func getHeaderView(handle: ((EYEPullToRefreshHeaderView?) -> Void)) {
        for subview in subviews {
            if subview is EYEPullToRefreshHeaderView {
                handle((subview as? EYEPullToRefreshHeaderView))
            }
        }
    }
    
    func getFooterView(handle: ((EYEPullToRefreshFooterView?) -> Void)) {
        for subview in subviews {
            if subview is EYEPullToRefreshFooterView {
                handle((subview as? EYEPullToRefreshFooterView))
            }
        }
    }
}

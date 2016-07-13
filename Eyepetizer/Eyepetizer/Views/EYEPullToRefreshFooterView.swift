//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

class EYEPullToRefreshHeaderView: EYEPullToRefreshView {
    class func footerView() -> EYEPullToRefreshFooterView {
        return EYEPullToRefreshFooterView(frame: CGRectMake(0, 0, UIConstant.SCREEN_WIDTH, pullToRefreshHeight))
    }
}

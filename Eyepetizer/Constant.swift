//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import XCGLogger

let log = XCGLogger.defaultInstance()

let IPHONE6P_WIDTH: CGFloat = 414
let IPHONE6P_HEIGHT: CGFloat = 736
let IPHONE6_WIDTH: CGFloat = 375
let IPHONE6_HEIGHT: CGFloat = 667
let IPHONE5_WIDTH: CGFloat = 320
let IPHONE5_HEIGHT: CGFloat = 568
let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
let SCREEN_WIDTH = SCREEN_BOUNDS.width
let SCREEN_HEIGHT = SCREEN_BOUNDS.height

let NAV_BAR_HEIGHT: CGFloat = 44
let STATUS_BAR_HEIGHT: CGFloat = 20
let TOP_BAR_HEIGHT = STATUS_BAR_HEIGHT + NAV_BAR_HEIGHT
let TAB_BAR_HEIGHT: CGFloat = 49

let ROW_HEIGHT: CGFloat = 44

// 周排行-月排行-总排行高度
let CHARTS_HEIGHT: CGFloat = 50

// 字体尺寸(不会受字体设置大小的影响)
///10.0
let TINY_FONT_SIZE: CGFloat = 10
///12.0
let SMALL_FONT_SIZE = UIFont.smallSystemFontSize()
///14.0
let SYSTEM_FONT_SIZE = UIFont.systemFontSize()
///17.0
let LABEL_FONT_SIZE = UIFont.labelFontSize()
///18.0
let BUTTON_FONT_SIZE = UIFont.buttonFontSize()

let TINY_FONT = UIFont.systemFontOfSize(TINY_FONT_SIZE)
let SMALL_FONT = UIFont.systemFontOfSize(SMALL_FONT_SIZE)
let LABEL_FONT = UIFont.systemFontOfSize(LABEL_FONT_SIZE)
let SYSTEM_FONT = UIFont.systemFontOfSize(SYSTEM_FONT_SIZE)
let BUTTON_FONT = UIFont.systemFontOfSize(BUTTON_FONT_SIZE)

// 间距
let MARGIN_5: CGFloat = 5
let MARGIN_10: CGFloat = 10
let MARGIN_15: CGFloat = 15
let MARGIN_20: CGFloat = 20

let launchImgKey = "launchImgKey"
let NotificationManager = NSNotificationCenter.defaultCenter()
let ApplicationManager = UIApplication.sharedApplication()

//MARK: - APIHeaper
struct APIHeaper {
    static let API_Service = "http://baobab.wandoujia.com/api/v2/"
    /// 一.每日精选api 参数 1.date:时间戳 2.num：数量(默认7)  date=1457883945551&num=7
    static let API_Choice = API_Service + "feed"
    /// 二.发现更多（分类） http://baobab.wandoujia.com/api/v2/categories
    static let API_Discover = API_Service + "categories"
    /// 三. 热门排行(周排行)
    static let API_Popular_Weakly = API_Service + "ranklist?strategy=weekly"
    /// 四.热门排行(月排行)
    static let API_Popular_Monthly = API_Service + "ranklist?strategy=monthly"
    /// 五.热门排行(总排行)
    static let API_Popular_Historical = API_Service + "ranklist?strategy=historical"
    /// 六.发现更多 - 按时间排序          参数：categoryId
    static let API_Discover_Date = API_Service + "videos?strategy=date"
    /// 七.发现更多 - 分享排行版          参数：categoryId
    static let API_Discover_Share = API_Service + "videos?strategy=shareCount"
}

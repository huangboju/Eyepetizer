//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

let IPHONE6P_WIDTH: CGFloat = 414
let IPHONE6P_HEIGHT: CGFloat = 736
let IPHONE6_WIDTH: CGFloat = 375
let IPHONE6_HEIGHT: CGFloat = 667
let IPHONE5_WIDTH: CGFloat = 320
let IPHONE5_HEIGHT: CGFloat = 568
let SCREEN_WIDTH = UIScreen.mainScreen().bounds.width
let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.height

let IS_6P = SCREEN_WIDTH == IPHONE6P_WIDTH

let NAV_BAR_HEIGHT: CGFloat = 44
let STATUS_BAR_HEIGHT: CGFloat = IS_6P ? 27 : 20
let TAB_BAR_HEIGHT: CGFloat = IS_6P ? (146 / 3) : 49

// 周排行-月排行-总排行高度
let CHARTS_HEIGHT: CGFloat = 50

// 字体尺寸(不会受字体设置大小的影响)
///12.0
let SMALL_FONT_SIZE = UIFont.smallSystemFontSize()
///14.0
let SYSTEM_FONT_SIZE = UIFont.systemFontSize()
///17.0
let LABEL_FONT_SIZE = UIFont.labelFontSize()
///18.0
let BUTTON_FONT_SIZE = UIFont.buttonFontSize()

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

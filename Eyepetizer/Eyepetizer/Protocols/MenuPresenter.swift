//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

protocol MenuPresenter: class {
    var menuBtn: EYEMenuBtn? { get set }
    func menuBtnDidClick()
}

extension MenuPresenter where Self: UIViewController {
    func setupMenuBtn(type: EYEMenuBtnType = .None) {
        menuBtn = EYEMenuBtn(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40)), type: type)
        menuBtn?.addTarget(self, action: Selector("menuBtnDidClick"), forControlEvents: .TouchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: menuBtn!)
    }
}

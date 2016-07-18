//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

protocol LoadingPresenter: class {
    var loaderView: LoaderView? { get set }
}

extension LoadingPresenter where Self: UIViewController {
    func setupLoaderView() {
        if  loaderView == nil {
            loaderView = LoaderView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 100))
            loaderView?.center = CGPoint(x: SCREEN_WIDTH * 0.5, y: SCREEN_HEIGHT * 0.4)
            view.addSubview(loaderView!)
        }
    }
    
    func setLoaderViewHidden(hidden : Bool) {
        if let loaderView = loaderView {
            loaderView.hidden = hidden
            if hidden {
                loaderView.stopLoadingAnimation()
            } else {
                loaderView.startLoadingAnimation()
            }
        }
    }
    
    func startLoadingAnimation () {
        if let loaderView = loaderView {
            loaderView.startLoadingAnimation()
        }
    }
    
    func stopLoadingAnimation() {
        if let loaderView = loaderView {
            loaderView.stopLoadingAnimation()
        }
    }
}

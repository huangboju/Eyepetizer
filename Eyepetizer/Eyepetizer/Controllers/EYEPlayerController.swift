//
//  Copyright © 2016年 xiAo_Ju. All rights reserved.
//

import AVFoundation

class EYEPlayerController: UIViewController {
    private enum PlayerState {
        case Buffering  //缓冲中
        case Playing    //播放中
        case Stopped    //停止播放
        case Pause      //暂停播放
    }
    
    private let keyPathes = [
        "status",
        "loadedTimeRanges",
        "playbackBufferEmpty" ,
        "playbackLikelyToKeepUp"
    ]
    
    private lazy var playView: EYEPlayerView = {
        let playView = EYEPlayerView.playerView()
        playView.titleLabel.text = self.videoTitle
        playView.frame = self.view.bounds
        return playView
    }()
    
    private var state: PlayerState = .Buffering {
        didSet {
            guard state == .Buffering else {
                return
            }
            playView.indicatorView.stopAnimating()
        }
    }
    
    private lazy var player: AVPlayer = {
        let player = AVPlayer(playerItem: self.playerItem)
        return player
    }()
    
    private var url: String!
    private var timer: NSTimer!
    private var videoTitle: String?
    private var isBuffering = false
    private var isLocalVideo = false
    private var isPauseByUser = false
    private var playerItem: AVPlayerItem!
    private var playerLayer: AVPlayerLayer!
    private var sliderLastValue: Float = 0
    
    convenience init(url: String, title: String) {
        self.init()
        self.url = url
        videoTitle = title
        // 播放状态
        state = .Stopped
        
        // 初始化playerItem
        playerItem  = AVPlayerItem(URL: NSURL(string: url)!)
        player.replaceCurrentItemWithPlayerItem(self.playerItem)
    }
    
    //隐藏状态栏
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(playView)
        ApplicationManager.setStatusBarOrientation( .LandscapeRight, animated: false)
        view.transform = CGAffineTransformMakeRotation(CGFloat(M_PI/2))
        view.bounds = SCREEN_BOUNDS
        playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = playView.bounds
        // AVLayerVideoGravityResize              非均匀模式。两个维度完全填充至整个视图区域
        // AVLayerVideoGravityResizeAspect        等比例填充，直到一个维度到达区域边界
        // AVLayerVideoGravityResizeAspectFill    等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspect
        
        // 添加playerLayer到self.layer
        playView.layer.insertSublayer(playerLayer, atIndex: 0)
    
        addObserverAndNotifacation()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(playerTimerAction), userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSRunLoopCommonModes)
        
        // 开始播放
        player.play()
        playView.startButton.selected = true
        
        playView.indicatorView.startAnimating()
    }
    
    func addObserverAndNotifacation() {
        NotificationManager.addObserver(self, selector: #selector(moviePlayDidEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object: player.currentItem)
        NotificationManager.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplicationWillResignActiveNotification, object: nil)
        NotificationManager.addObserver(self, selector: #selector(appDidEnterPlayGround), name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        playView.sliderView.addTarget(self, action: #selector(progressSliderTouchBegan), forControlEvents: .TouchDown)
        playView.sliderView.addTarget(self, action: #selector(progressSliderValueChanged), forControlEvents: .ValueChanged)
        playView.sliderView.addTarget(self, action: #selector(progressSliderTouchEnded), forControlEvents: [.TouchUpInside, .TouchCancel, .TouchUpOutside])
        playView.startButton.addTarget(self, action: #selector(startAction), forControlEvents: .TouchUpInside)
        playView.backBtn.addTarget(self, action: #selector(backButtonAction), forControlEvents: .TouchUpInside)
        
        keyPathes.forEach { (keyPath) in
            player.currentItem?.addObserver(self, forKeyPath: keyPath, options: .New, context: nil)
        }
    }
    
    private func unregisterNotifacation() {
        NotificationManager.removeObserver(self)
        keyPathes.forEach { (keyPath) in
           player.currentItem?.removeObserver(self, forKeyPath: keyPath)
        }
    }
    
    func startAction(button: UIButton) {
        button.selected = !button.selected
        isPauseByUser = !button.selected
        if button.selected {
            player.play()
            state = .Playing
        } else {
            player.pause()
            state = .Pause
        }
    }
    
    func moviePlayDidEnd(notification: NSNotification) {
        state = .Stopped
        playView.startButton.selected = false
    }
    
    func progressSliderTouchBegan(slide: UISlider) {
        if player.status == .ReadyToPlay {
            timer.fireDate = NSDate.distantFuture()
        }
    }
    
    //拖动改变视频播放进度
    func progressSliderValueChanged(slider: UISlider) {
        if player.status == .ReadyToPlay {
            var style = ""
            let value = slider.value - sliderLastValue
            if value > 0 {
                style = ">>"
            } else if value < 0{
                style = "<<"
            }
            
            sliderLastValue = slider.value
            player.pause()
            //计算出拖动的当前秒数
            let total = Float(self.playerItem.duration.value) / Float(playerItem.duration.timescale)
            let dragedSeconds = Int64(floorf(total*slider.value))
            //转换成CMTime才能给player来控制播放进度
            let dragedCMTime = CMTimeMake(dragedSeconds, 1)
            // 当前时长进度progress
            let proMin = Int64(CMTimeGetSeconds(dragedCMTime)) / 60
            let proSec = Int64(CMTimeGetSeconds(dragedCMTime)) % 60
            // duration 总时长
            let durMin = playerItem.duration.value / Int64(playerItem.duration.timescale) / 60
            let durSec = playerItem.duration.value / Int64(playerItem.duration.timescale) % 60
            
            let currentTime = String(format: "%02zd:%02zd", proMin,proSec)
            let totalTime = String(format: "%02zd:%02zd", durMin, durSec)
            
            if durSec > 0 {
                // 当总时长>0时候才能拖动slider
                self.playView.startLabel.text = currentTime
                self.playView.horizontalLabel.hidden = false
                self.playView.horizontalLabel.text = String(format:"%@ %@ / %@", style, currentTime, totalTime)
            } else {
                // 此时设置slider值为0
                slider.value = 0
            }
        } else {
            // player状态加载失败
            // 此时设置slider值为0
            slider.value = 0
        }
    }
    
    func progressSliderTouchEnded(slider: UISlider) {
        if player.status == .ReadyToPlay {
            // 继续开启timer
            timer.fireDate = NSDate()
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue()) {
                self.playView.horizontalLabel.hidden = true
            }
            // 结束滑动时候把开始播放按钮改为播放状态
            playView.startButton.selected = true
            isPauseByUser = false
            
            //计算出拖动的当前秒数
            let total = Float(self.playerItem.duration.value) / Float(playerItem.duration.timescale)
            let dragedSeconds = Int64(floorf(total * slider.value))
            //转换成CMTime才能给player来控制播放进度
            let dragedCMTime = CMTimeMake(dragedSeconds, 1)
            
            // 滑动结束视频跳转
            player.seekToTime(dragedCMTime, completionHandler: { (finish) in
                // 如果点击了暂停按钮
                if self.isPauseByUser == true {
                    return
                }
                
                self.player.play()
                
                if !self.playerItem.playbackLikelyToKeepUp && !self.isLocalVideo {
                    self.state = .Buffering
                    self.playView.indicatorView.startAnimating()
                }
            })
        }
    }
    
    func backButtonAction() {
        timer.invalidate()
        player.pause()
        state = .Stopped
        navigationController?.popViewControllerAnimated(false)
    }
    
    func appDidEnterBackground() {
        player.pause()
        state = .Pause
    }
    
    func appDidEnterPlayGround() {
        player.play()
        state = .Playing
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "status" {
            if player.status == .ReadyToPlay {
                playView.indicatorView.stopAnimating()
                state = .Playing
            } else if player.status == .Failed {
                playView.indicatorView.startAnimating()
            }
        } else if keyPath == "loadedTimeRanges" {
            let timeInterval = availableDuration()
            let duration = playerItem.duration
            let totalDuration = CMTimeGetSeconds(duration)
            playView.progressView.setProgress(Float(timeInterval) / Float(totalDuration), animated: false)
        } else if keyPath == "playbackBufferEmpty" {
            if playerItem.playbackBufferEmpty {
                state = .Buffering
                bufferingSomeSecond()
            }
        } else if keyPath == "playbackLikelyToKeepUp" {
            if playerItem.playbackLikelyToKeepUp {
                state = .Playing
            }
        }
    }
    
    func playerTimerAction() {
        guard playerItem.duration.timescale != 0 else {
            return
        }
        // 总共时长
        playView.sliderView.maximumValue = 1
        // 当前进度
        playView.sliderView.value = Float (CMTimeGetSeconds(playerItem.currentTime())) / (Float(playerItem.duration.value) / Float(playerItem.duration.timescale))
        // 当前时长进度progress
        let proMin = Int64(CMTimeGetSeconds(player.currentTime())) / 60
        let proSec = Int64(CMTimeGetSeconds(player.currentTime())) % 60
        // duration 总时长
        let durMin = playerItem.duration.value / Int64(playerItem.duration.timescale) / 60
        let durSec = playerItem.duration.value / Int64(playerItem.duration.timescale) % 60
        
        playView.startLabel.text = String(format: "%02zd:%02zd", proMin,proSec)
        playView.endLabel.text = String(format: "%02zd:%02zd", durMin, durSec)
    }
    
    private func availableDuration() -> NSTimeInterval {
        let loadedTimeRanges = player.currentItem?.loadedTimeRanges
        // 获取缓冲区域
        let timeRange = loadedTimeRanges?.first?.CMTimeRangeValue
        let startSeconds = CMTimeGetSeconds(timeRange!.start)
        let durationSeconds = CMTimeGetSeconds(timeRange!.duration)
        // 计算缓冲总进度
        return startSeconds + durationSeconds
    }
    
    private func bufferingSomeSecond() {
        playView.indicatorView.startAnimating()
        // 如果正在缓存就不往下执行
        guard !isBuffering else {
            return
        }
        
        isBuffering = true
        // 需要先暂停一小会之后再播放，否则网络状况不好的时候时间在走，声音播放不出来
        player.pause()
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            // 如果此时用户已经暂停了，则不再需要开启播放了
            guard self.isBuffering == false else {
                self.isBuffering = false
                return
            }
            
            self.player.play()
            // 如果执行了play还是没有播放则说明还没有缓存好，则再次缓存一段时间
            self.isBuffering = false
            if !self.playerItem.playbackLikelyToKeepUp {
                self.bufferingSomeSecond()
            }
        }
    }
    
    deinit {
        unregisterNotifacation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

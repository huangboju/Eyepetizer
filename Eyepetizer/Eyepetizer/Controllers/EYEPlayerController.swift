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
    private var videoTitle: String?
    private var state: PlayerState = .Buffering {
        didSet {
            guard state == .Buffering else {
                return
            }
            playView.indicatorView.stopAnimating()
        }
    }
    private lazy var playView: EYEPlayerView = {
        let playView = EYEPlayerView.playerView()
        playView.titleLabel.text = self.videoTitle
        playView.frame = self.view.bounds
        return playView
    }()
    private lazy var player: AVPlayer = {
        var player: AVPlayer = AVPlayer(playerItem: self.playerItem)
        return player
    }()
    private var playerItem: AVPlayerItem!
    private var timer: NSTimer!
    private var isPauseByUser = false
    private var sliderLastValue: Float = 0
    private var isLocalVideo = false
    private var isBuffering = false
    
    convenience init(url: String, title: String) {
        self.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(playView)
    }
    
    func addObserverAndNotifacation() {
        NotificationManager.addObserver(self, selector: #selector(moviePlayDidEnd), name: AVPlayerItemDidPlayToEndTimeNotification, object: self.player.currentItem)
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
    
    func moviePlayDidEnd(notification: NSNotification) {
        state = .Stopped
        playView.startButton.selected = false
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
    
    func progressSliderTouchBegan(slide: UISlider) {
        if player.status == .ReadyToPlay {
            timer.fireDate = NSDate.distantFuture()
        }
    }
    
    func progressSliderValueChanged(slider: UISlider) {
    
    }
    
    func progressSliderTouchEnded(slider: UISlider) {
    
    }
    
    func startAction(button: UIButton) {
        button.selected = !button.selected
        self.isPauseByUser = !button.selected
        if button.selected {
            player.play()
            state = .Playing
        } else {
            player.pause()
            state = .Pause
        }
    }
    
    func backButtonAction() {
        timer.invalidate()
        player.pause()
        state = .Stopped
        navigationController?.popViewControllerAnimated(false)
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

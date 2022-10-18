//
//  HowToUseVideoVC.swift
//  OSCAR
//
//  Created by Mostafa Samir on 13/12/2021.
//

import UIKit
import AVKit
import AVFoundation

class HowToUseVideoVC: UIViewController {

    var flag = 0
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            playVideo()
    }
    let playerController = AVPlayerViewController()
    private func playVideo() {
            guard let path = Bundle.main.path(forResource: "HowToVideo", ofType:"mp4") else {
                debugPrint("video.m4v not found")
                return
            }
            let player = AVPlayer(url: URL(fileURLWithPath: path))
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerController.player?.currentItem)
        NotificationCenter.default.addObserver(self, selector: #selector(playerisDismissed), name: NSNotification.Name.kAVPlayerViewControllerDismissingNotification, object: playerController.player?.currentItem)
            playerController.player = player
            present(playerController, animated: true) {
                player.play()
            }
        }
    @objc func playerDidFinishPlaying(note: NSNotification) {
        playerController.dismiss(animated: true, completion: nil)
        playerController.dismiss(animated: true, completion: nil)
        playerController.view.removeFromSuperview()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        if flag == 5 {
            push(LoginVC())
        }else {
            pop()
        }
    }
    @objc func playerisDismissed(note: NSNotification) {
        playerController.dismiss(animated: true, completion: nil)
        playerController.dismiss(animated: true, completion: nil)
        playerController.view.removeFromSuperview()
        self.presentedViewController?.dismiss(animated: true, completion: nil)
        if flag == 5 {
            push(LoginVC())
        }else {
            pop()
        }
    }
}
extension AVPlayerViewController {
    // override 'viewWillDisappear'
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // now, check that this ViewController is dismissing
        if self.isBeingDismissed == false {
            return
        }

        // and then , post a simple notification and observe & handle it, where & when you need to.....
        NotificationCenter.default.post(name: .kAVPlayerViewControllerDismissingNotification, object: nil)
    }
}
extension Notification.Name {
static let kAVPlayerViewControllerDismissingNotification = Notification.Name.init("dismissing")
}

//
//  SGLiveView.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit

class SGLiveView: UIView {
    var blinkInterval: Double = 0.5
    var liveLabel = UILabel()
    
    var timer: Timer!
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: blinkInterval * 2, repeats: true) { (_) in
            UIView.animate(withDuration: self.blinkInterval, animations: {
                self.liveLabel.alpha = 0
            }, completion: { (completed) in
                if completed {
                    UIView.animate(withDuration: self.blinkInterval) {
                        self.liveLabel.alpha = 1
                    }
                }
            })
        }
    }
    
    func stop() {
        timer.invalidate()
    }
}


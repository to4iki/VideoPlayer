import UIKit
import AVFoundation

final class PlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
        set {
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer {
        return self.layer as! AVPlayerLayer
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    deinit {
        let layer = playerLayer
        let qos = DispatchQoS.QoSClass.background
        DispatchQueue.global(qos: qos).async {
            layer.player = nil
        }
    }
}

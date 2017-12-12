import UIKit
import AVFoundation
import RxSwift
import RxCocoa

enum PlayerError: Error {
    case load
}

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

    private let _tapGesture = UITapGestureRecognizer()
    var tapGesture: Driver<Void> {
        return _tapGesture.rx.event
            .map { _ in }
            .asDriver(onErrorJustReturn: ())
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addGestureRecognizer(_tapGesture)
    }
    
    deinit {
        let layer = playerLayer
        let qos = DispatchQoS.QoSClass.background
        DispatchQueue.global(qos: qos).async {
            layer.player = nil
        }
    }
}

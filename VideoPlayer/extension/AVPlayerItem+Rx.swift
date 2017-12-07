import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayerItem {
    var didPlayToEnd: Observable<Notification> {
        return NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime, object: base)
    }
}

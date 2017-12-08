import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayerItem {
    var status: Observable<AVPlayerItemStatus> {
        return observe(AVPlayerItemStatus.self, #keyPath(AVPlayerItem.status))
            .map { $0 ?? .unknown }
    }

    var error: Observable<NSError?> {
        return observe(NSError.self, #keyPath(AVPlayerItem.error))
    }

    var duration: Observable<CMTime> {
        return observe(CMTime.self, #keyPath(AVPlayerItem.duration))
            .map { $0 ?? kCMTimeZero }
    }

    var didPlayToEnd: Observable<Notification> {
        return NotificationCenter.default.rx.notification(.AVPlayerItemDidPlayToEndTime, object: base)
    }
}

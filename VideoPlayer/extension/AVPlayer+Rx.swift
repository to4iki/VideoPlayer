import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayer {
    var status: Observable<AVPlayerStatus> {
        return observe(AVPlayerStatus.self, #keyPath(AVPlayer.status))
            .map { $0 ?? .unknown }
    }
}

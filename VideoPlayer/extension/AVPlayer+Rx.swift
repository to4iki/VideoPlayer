import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVPlayer {
    var rate: Observable<Float> {
        return observe(Float.self, #keyPath(AVPlayer.rate))
            .map { $0 ?? 0 }
    }

    var playing: Observable<Bool> {
        return rate.map { $0 != 0 }
    }

    var currentItem: Observable<AVPlayerItem?> {
        return observe(AVPlayerItem.self, #keyPath(AVPlayer.currentItem))
    }

    var status: Observable<AVPlayerStatus> {
        return observe(AVPlayerStatus.self, #keyPath(AVPlayer.status))
            .map { $0 ?? .unknown }
    }

    var error: Observable<NSError?> {
        return observe(NSError.self, #keyPath(AVPlayer.error))
    }

    func periodicTimeObserver(interval: CMTime) -> Observable<CMTime> {
        return Observable.create { observer in
            let time = self.base.addPeriodicTimeObserver(forInterval: interval, queue: nil) { time in
                observer.onNext(time)
            }
            return Disposables.create { self.base.removeTimeObserver(time) }
        }
    }
}

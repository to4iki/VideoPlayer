import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class PlayerViewModel {
    let didPlayToEnd: Driver<Bool>
    let current: Driver<Float>
    let duration: Driver<Float>
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    private let disposeBag = DisposeBag()

    init(player: AVPlayer) {
        self.didPlayToEnd = player.currentItem!.rx.didPlayToEnd
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)

        self.current = player.rx.periodicTimeObserver(interval: CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
            .filter { $0.isValid }
            .map { Float($0.seconds) }
            .filter { $0.isFinite }
            .asDriver(onErrorJustReturn: 0)

        self.duration = player.currentItem!.rx.duration
            .filter { $0.isValid }
            .map { Float($0.seconds) }
            .filter { $0.isFinite }
            .asDriver(onErrorJustReturn: 0)

        Observable.combineLatest(player.rx.status, Observable<Int>.timer(3.0, scheduler: MainScheduler.instance))
            .map { $0.0 != .readyToPlay }
            .asDriver(onErrorJustReturn: true)
            .drive(onNext: { [unowned self] done in
                self.isLoading.accept(done)
            })
            .disposed(by: disposeBag)
    }
}

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class PlayerViewModel {
    let didPlayToEnd: Driver<Bool>
    let isLoading: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private let disposeBag = DisposeBag()

    init(player: AVPlayer) {
        self.didPlayToEnd = player.currentItem!.rx.didPlayToEnd
            .map { _ in true }
            .asDriver(onErrorJustReturn: false)

        Observable.combineLatest(player.rx.status, Observable<Int>.timer(3.0, scheduler: MainScheduler.instance))
            .map { $0.0 == .readyToPlay }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [unowned self] done in
                self.isLoading.accept(done)
            })
            .disposed(by: disposeBag)
    }
}

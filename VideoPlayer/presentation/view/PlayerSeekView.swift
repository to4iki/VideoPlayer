import UIKit
import RxSwift
import RxCocoa

final class PlayerSeekView: UIStackView {
    @IBOutlet private weak var currentTimeLabel: UILabel!
    @IBOutlet private weak var slider: UISlider!
    @IBOutlet private weak var durationTimeLabel: UILabel!

    private let disposeBag = DisposeBag()

    func bind(current time: Driver<Float>, duration: Driver<Float>) {
        Driver.combineLatest(time, duration)
            .map(progress)
            .drive(slider.rx.value)
            .disposed(by: disposeBag)

        time
            .map { $0.format(template: .minutes) }
            .drive(currentTimeLabel.rx.text)
            .disposed(by: disposeBag)

        duration
            .map { $0.format(template: .minutes) }
            .drive(durationTimeLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func progress(current time: Float, duration: Float) -> Float {
        return min((time / duration), 1)
    }
}

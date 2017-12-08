import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    @IBOutlet private weak var playerView: PlayerView!

    private var viewModel: PlayerViewModel!
    private let videoPlayer = VideoPlayer(url: URL(string: "https://i.imgur.com/9rGrj10.mp4")!)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let player = AVPlayer(playerItem: videoPlayer.playerItem)
        playerView.player = player
        viewModel = PlayerViewModel(player: player)
        bind()
    }
    
    private func bind() {
        viewModel.didPlayToEnd
            .drive(onNext: { [unowned self] _ in
                print("item did play to end")
                self.backToStart()
            })
            .disposed(by: disposeBag)

        viewModel.isLoading.asDriver()
            .map { !$0 }
            .drive(playerView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isLoading.asDriver()
            .drive(indicatorView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isLoading.asDriver()
            .filter { $0 == true }
            .drive(onNext: { [unowned self] _ in
                print("item ready to play")
                self.playerView.player?.play()
            })
            .disposed(by: disposeBag)
    }

    private func backToStart() {
        playerView.player?.seek(to: kCMTimeZero)
        playerView.player?.play()
    }
}

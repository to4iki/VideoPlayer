import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    @IBOutlet private weak var playerView: PlayerView!
    @IBOutlet private weak var navigationView: PlayerNavigationView!
    @IBOutlet private weak var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: PlayerViewModel!
    private let video = Video(url: URL(string: "https://i.imgur.com/9rGrj10.mp4")!)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let player = AVPlayer(playerItem: video.playerItem)
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
            .drive(playerView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel.isLoading.asDriver()
            .map { !$0 }
            .drive(indicatorView.rx.isHidden)
            .disposed(by: disposeBag)

        viewModel.isLoading.asDriver()
            .filter { !$0 }
            .drive(onNext: { [unowned self] _ in
                print("item ready to play")
                self.playerView.player?.play()
            })
            .disposed(by: disposeBag)

        playerView.player!.rx.playing.asDriver(onErrorDriveWith: .empty())
            .drive(navigationView.rx.isHidden)
            .disposed(by: disposeBag)

        Driver.zip(playerView.player!.rx.playing.asDriver(onErrorDriveWith: .empty()), playerView.tapGesture)
            .drive(onNext: { [unowned self] (playing, _) in
                if playing {
                    self.playerView.player?.pause()
                } else {
                    self.playerView.player?.play()
                }
            })
            .disposed(by: disposeBag)

        navigationView.seekView.bind(current: viewModel.current, duration: viewModel.duration)
    }

    private func backToStart() {
        playerView.player?.seek(to: kCMTimeZero)
        playerView.player?.play()
    }
}

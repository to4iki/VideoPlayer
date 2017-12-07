import UIKit
import AVFoundation
import RxSwift
import RxCocoa

final class ViewController: UIViewController {
    @IBOutlet private weak var playerView: PlayerView!
    
    private let videoPlayer = VideoPlayer(url: URL(string: "https://i.imgur.com/9rGrj10.mp4")!)
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.player = AVPlayer(playerItem: videoPlayer.playerItem)
        bind()
    }
    
    private func bind() {
        playerView.player?.rx.status
            .filter { $0 == .readyToPlay }
            .subscribe(onNext: { [unowned self] status in
                print("item ready to play")
                self.playerView.player?.play()
            })
            .disposed(by: disposeBag)
        
        playerView.player?.currentItem?.rx.didPlayToEnd.subscribe(onNext: { [unowned self] _ in
            print("item did play to end")
            self.playerView.player?.seek(to: kCMTimeZero)
            self.playerView.player?.play()
        })
        .disposed(by: disposeBag)
    }
}

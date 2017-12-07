import AVFoundation

final class VideoPlayer {
    let asset: AVAsset
    let playerItem: AVPlayerItem
    
    init(url: URL) {
        self.asset = AVAsset(url: url)
        self.playerItem = AVPlayerItem(asset: asset)
    }
}

import UIKit

final class PlayerNavigationView: UIView {
    @IBOutlet private weak var propagationView: UIView!
    @IBOutlet private(set) weak var seekView: PlayerSeekView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if propagationView.frame.contains(point) {
            return false
        } else {
            return true
        }
    }

    private func commonInit() {
        let nib = UINib(nibName: "PlayerNavigationView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
        addSubview(view)
    }
}

import UIKit

final class PulseIconView: UIControl {
    private let shapeLayer = CAShapeLayer()
    private let glowLayer = CALayer()

    var index: Int = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = 16
        layer.masksToBounds = false
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        shapeLayer.fillColor = UIColor.white.withAlphaComponent(0.2).cgColor
        layer.addSublayer(shapeLayer)
        glowLayer.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.0).cgColor
        glowLayer.cornerRadius = 16
        layer.insertSublayer(glowLayer, below: shapeLayer)
        addTarget(self, action: #selector(tapped), for: .touchUpInside)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        glowLayer.frame = bounds
    }

    @objc private func tapped() {
        sendActions(for: .primaryActionTriggered)
    }

    func showPulse(active: Bool) {
        let color = active ? UIColor.systemYellow.withAlphaComponent(0.9) : UIColor.white.withAlphaComponent(0.15)
        UIView.animate(withDuration: active ? 0.15 : 0.25) {
            self.backgroundColor = color
            self.glowLayer.backgroundColor = (active ? UIColor.systemYellow.withAlphaComponent(0.35) : UIColor.clear).cgColor
            self.transform = active ? CGAffineTransform(scaleX: 1.05, y: 1.05) : .identity
        }
        if active {
            SoundManager.shared.playPulse()
            Haptic.light()
        }
    }
}
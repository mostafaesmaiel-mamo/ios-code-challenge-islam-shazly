//
//  UIView+Extensions.swift
//  
//

//

// swiftlint:disable all

import UIKit

// MARK: - Init
public extension UIView {

    convenience init(superView: UIView, padding: CGFloat) {
        self.init(frame: CGRect(x: superView.x + padding, y: superView.y + padding, width: superView.width - padding*2, height: superView.height - padding*2))
    }

    convenience init(superView: UIView) {
        self.init(frame: CGRect(origin: CGPoint.zero, size: superView.bounds.size))
    }
    
    func loadNibView() {
        self.loadNibView(name: String(describing: type(of: self)))
    }
    
    func loadNibView(name: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: name, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        nibView.frame = bounds
        nibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        nibView.translatesAutoresizingMaskIntoConstraints = true
        nibView.backgroundColor = .clear
        addSubview(nibView)
    }
    
}

// MARK: - Frame

public extension UIView {
    var x: CGFloat {
        get { return frame.x }
        set { frame = frame.with(x: newValue) }
    }

    var y: CGFloat {
        get { return frame.y }
        set { frame = frame.with(y: newValue) }
    }

    var width: CGFloat {
        get { return frame.width }
        set { frame = frame.with(width: newValue) }
    }

    var height: CGFloat {
        get { return frame.height }
        set { frame = frame.with(height: newValue) }
    }
    
    var left: CGFloat {
        get {
            return self.x
        } set(value) {
            self.x = value
        }
    }

    var right: CGFloat {
        get {
            return self.x + self.width
        } set(value) {
            self.x = value - self.width
        }
    }

    var top: CGFloat {
        get {
            return self.y
        } set(value) {
            self.y = value
        }
    }

    var bottom: CGFloat {
        get {
            return self.y + self.height
        } set(value) {
            self.y = value - self.height
        }
    }
    
    var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
    var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }
    
    var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }

    var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }
}

// MARK: - Position

public extension UIView {
    
    func centerXInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.x = parentView.width/2 - self.width/2
    }

    func centerYInSuperView() {
        guard let parentView = superview else {
            assertionFailure("EZSwiftExtensions Error: The view \(self) doesn't have a superview")
            return
        }

        self.y = parentView.height/2 - self.height/2
    }

    func centerInSuperView() {
        centerXInSuperView()
        centerYInSuperView()
    }
}

// MARK: Layer Extensions

public extension UIView {

    func makeRounded() {
        setCornerRadius(radius: width/2)
    }
    
    func setCornerRadius(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }

    func addShadow(offset: CGSize, radius: CGFloat, color: UIColor, opacity: Float, cornerRadius: CGFloat? = nil) {
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.shadowColor = color.cgColor
        if let r = cornerRadius {
            layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: r).cgPath
        }
    }

    func addBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.masksToBounds = true
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

// MARK: - Localizables

public extension UIView {

    func translateSubviews() {
        if subviews.isEmpty {
            return
        }

        for subview in subviews {
            translate(subview)
            if let stackView = subview as? UIStackView {
                stackView.arrangedSubviews.forEach {
                    self.translate($0)
                    $0.translateSubviews()
                }
            } else {
                subview.translateSubviews()
            }
        }
    }

    private func translate(_ subview: UIView) {
        if let label = subview as? UILabel {
            label.text = NSLocalizedString(label.text ?? "", comment: "")
        } else if let textField = subview as? UITextField {
            textField.text = NSLocalizedString(textField.text ?? "", comment: "")
            textField.placeholder = NSLocalizedString(textField.placeholder ?? "", comment: "")
        } else if let textView = subview as? UITextView {
            textView.text = NSLocalizedString(textView.text, comment: "")
        } else if let button = subview as? UIButton {
            let states: [UIControl.State] = [.normal, .selected, .highlighted, .disabled, .application, .reserved]
            for state in states where button.title(for: state) != nil {
                button.setTitle(NSLocalizedString(button.title(for: state) ?? "", comment: ""), for: state)
            }
        }
    }

}

// MARK: - Animation

public let UIViewDefaultFadeDuration: TimeInterval = 0.4

public extension UIView {

    func shakeViewForTimes(_ times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0 )),
            NSValue(caTransform3D: CATransform3DMakeTranslation( 5, 0, 0 ))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7/100

        self.layer.add(anim, forKey: nil)
    }
    
    func fadeIn(_ duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        fadeTo(1.0, duration: duration, delay: delay, completion: completion)
    }

    func fadeOut(_ duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        fadeTo(0.0, duration: duration, delay: delay, completion: completion)
    }

    func fadeTo(_ value: CGFloat, duration: TimeInterval? = UIViewDefaultFadeDuration, delay: TimeInterval? = 0.0, completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration ?? UIViewDefaultFadeDuration, delay: delay ?? UIViewDefaultFadeDuration, options: .curveEaseInOut, animations: {
            self.alpha = value
        }, completion: completion)
    }
}


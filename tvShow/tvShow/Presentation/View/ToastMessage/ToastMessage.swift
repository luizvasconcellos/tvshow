//
//  ToastMessage.swift
//  tvShow
//
//  Created by Luiz Vasconcellos on 29/11/21.
//

import UIKit

public class ToastMessage: UIView {
    
    public typealias CompleteHandler = (ToastMessage) -> Void
    
    // MARK: - Enum
    public enum TypeToast: CaseIterable {
        case error
        case info
        case success
    }
    
    public enum Position {
        case top
        case bottom
    }
    
    // MARK: - UI Elements
    private var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private let svContent: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .fill
        view.alignment = .center
        view.spacing = 5
        return view
    }()
    
    private let message: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        view.numberOfLines = 0
        view.setContentHuggingPriority(.fittingSizeLevel, for: .vertical)
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .custom)
        if let image = UIImage(named: "close-icon") {
            button.setImage(image, for: .normal)
        }
        button.tintColor = .white
        return button
    }()
    
    // MARK: - Properties
    private var topConstraint: NSLayoutConstraint?
    private var bottomConstraint: NSLayoutConstraint?
    private var action: CompleteHandler?
    private var shape = CAShapeLayer()
    private var duration: Double?
    private var position: Position = .top
    private var timer: Timer?
    private(set) var type: TypeToast = .error
    private(set) var config: ToastMessageConfig!
    
    public init(message: NSAttributedString,
                duration: Double? = 3.0,
                position: Position = .top,
                type: TypeToast = .success,
                config: ToastMessageConfig = ToastMessageConfig.shared) {
        
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        self.config = config
        self.message.attributedText = message
        self.type = type
        self.duration = duration
        self.position = position
        setup()
    }
    
    override public func draw(_ rect: CGRect) {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 8, height: 8))
        shape.frame = rect
        shape.path = path.cgPath
        shape.shadowColor = UIColor.gray.cgColor
        shape.shadowOffset = CGSize(width: 1, height: 1)
        shape.shadowRadius = 2
        shape.shadowOpacity = 0.1
    }
    
    // MARK: - Init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    private func setup() {
        backgroundColor = UIColor.clear
        
        contentView.frame = bounds
        contentView.layer.addSublayer(shape)
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalToConstant: min(400, UIScreen.main.bounds.width - 32)),
            contentView.heightAnchor.constraint(equalToConstant: config.sizeBox)
        ])
        
        message.font = config.messageFont
        message.textColor = config.messageColor
        svContent.addArrangedSubview(message)
        
        closeButton.addTarget(self, action: #selector(self.hideToast), for: .touchUpInside)
        
        svContent.addArrangedSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 24),
            closeButton.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        addSubview(svContent)
        NSLayoutConstraint.activate([
            svContent.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            svContent.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            svContent.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
        
        shape.fillColor = config.backgrounColors[type]?.cgColor
        shape.opacity = 0.9
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hideToast))
        isUserInteractionEnabled = true
        addGestureRecognizer(tap)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.onMoving(pan:)))
        addGestureRecognizer(pan)
        
        if let duration = duration {
            timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hideToast), userInfo: nil, repeats: false)
        }
    }
    
    // MARK: - Public Functions
    public convenience init(message: String,
                            duration: Double? = 3.0,
                            position: Position = .top,
                            type: TypeToast = .success,
                            config: ToastMessageConfig = ToastMessageConfig.shared) {
        
        let message = NSAttributedString(string: message, attributes: [.font: config.messageFont, .foregroundColor: config.messageColor])
        self.init(message: message, duration: duration, position: position, type: type, config: config)
    }
    
    @discardableResult public func show() -> ToastMessage {
        
        UIApplication.shared.keyWindow?.addSubview(self)
        
        if let superview = superview {
            topConstraint = topAnchor.constraint(equalTo: superview.topAnchor, constant: UIApplication.shared.statusBarFrame.maxY + 50)
            
            centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0).isActive = true
            
            if #available(iOS 11.0, *) {
                bottomConstraint = bottomAnchor.constraint(equalTo: superview.safeAreaLayoutGuide.bottomAnchor, constant: -16)
            } else {
                bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -16)
            }
        }
        
        if position == .top {
            bottomConstraint?.isActive = false
            topConstraint?.isActive = true
        } else {
            topConstraint?.isActive = false
            bottomConstraint?.isActive = true
        }
        
        self.alpha = 0.1
        self.transform = CGAffineTransform(scaleX: 3, y: 3)
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            self.alpha = 1
            self.transform = .identity
        }, completion: { ( _ ) in
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
                self.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            }, completion: { ( _ ) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.transform = .identity
                })
            })
            
        })
        
        return self
    }
    
    @objc public func hideToast() {
        
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve, .curveEaseInOut, .beginFromCurrentState], animations: {
            self.alpha = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }, completion: { ( _ ) in
            self.removeFromSuperview()
            self.action?(self)
        })
    }
    
    @objc func onMoving(pan: UIPanGestureRecognizer) {
        
        let point = pan.translation(in: UIApplication.shared.keyWindow!)
        if pan.state == .began {
            timer?.invalidate()
        } else if pan.state == .changed {
            let alpha = min(1 - (abs(point.x)/150.0), 1 - (abs(point.y)/150.0))
            
            self.alpha = alpha
            self.transform = CGAffineTransform(translationX: point.x, y: point.y)
            if alpha <= 0 {
                self.removeFromSuperview()
            }
            
        } else if pan.state == .ended {
            self.alpha = 1
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = .identity
            })
            
            if let duration = duration {
                timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(self.hideToast), userInfo: nil, repeats: false)
            }
        }
    }
    
    public func onDismiss(_ sender : @escaping CompleteHandler) {
        action = sender
    }
    
    @discardableResult public static func show(message: String,
                                               duration: Double? = 4.0 ,
                                               position: Position = .bottom,
                                               type: TypeToast = .success,
                                               config: ToastMessageConfig = ToastMessageConfig.shared) -> ToastMessage {
        
        let message = NSAttributedString(string: message, attributes: [.font: config.messageFont, .foregroundColor: config.messageColor])
        
        let msg = ToastMessage(message: message, duration: duration, position: position, type: type, config: config)
        msg.show()
        return msg
    }
    
    @discardableResult public static func show(message: NSAttributedString,
                                               duration: Double? = 4.0 ,
                                               position: Position = .top,
                                               type: TypeToast = .success) -> ToastMessage {
        let msg = ToastMessage(message: message, duration: duration, position: position, type: type, config: ToastMessageConfig.shared)
        msg.show()
        return msg
    }
    
    public static func hide() {
        
        for sub in UIApplication.shared.keyWindow!.subviews {
            if let msg = sub as? ToastMessage {
                msg.hideToast()
            }
        }
    }
}

//
//  LuminousDialogPortal.swift
//  TenFlip
//
//  Custom Alert Dialog with Mahjong Theme
//

import UIKit

class LuminousDialogPortal: UIView {
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = ArcaneConfiguration.ColorPalette.glassBackground
        view.layer.cornerRadius = ArcaneConfiguration.LayoutMetrics.glassCornerRadius
        view.layer.borderWidth = 2
        view.layer.borderColor = ArcaneConfiguration.ColorPalette.glassBorder.cgColor
        view.layer.shadowColor = ArcaneConfiguration.ColorPalette.neonPurple.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = ArcaneConfiguration.LayoutMetrics.neonGlowOpacity
        view.layer.shadowRadius = ArcaneConfiguration.LayoutMetrics.neonGlowRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.layer.cornerRadius = ArcaneConfiguration.LayoutMetrics.glassCornerRadius
        blurView.clipsToBounds = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 28, weight: .black)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        
        // Neon glow effect
        label.layer.shadowColor = ArcaneConfiguration.ColorPalette.neonCyan.cgColor
        label.layer.shadowRadius = 10
        label.layer.shadowOpacity = 0.8
        label.layer.shadowOffset = .zero
        label.layer.masksToBounds = false
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.white.withAlphaComponent(0.9)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private var storedActions: [DialogAction] = []
    
    init() {
        super.init(frame: .zero)
        configureInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureInterface() {
        backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        addSubview(containerView)
        containerView.addSubview(blurEffectView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(scrollView)
        scrollView.addSubview(messageLabel)
        containerView.addSubview(buttonStackView)
        
        // Create constraints with appropriate priorities
        let containerHeightConstraint = containerView.heightAnchor.constraint(lessThanOrEqualToConstant: 550)
        containerHeightConstraint.priority = .defaultHigh
        
        let scrollViewHeightConstraint = scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        scrollViewHeightConstraint.priority = .required
        
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.widthAnchor.constraint(equalToConstant: 320),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            containerHeightConstraint,
            
            blurEffectView.topAnchor.constraint(equalTo: containerView.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 28),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            scrollView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -16),
            scrollViewHeightConstraint,
            
            messageLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            messageLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            messageLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            buttonStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            buttonStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
            buttonStackView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    func manifestWithConfiguration(
        title: String,
        message: String,
        actions: [DialogAction]
    ) {
        storedActions = actions
        titleLabel.text = title
        messageLabel.text = message
        
        buttonStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, action) in actions.enumerated() {
            let button = createStyledButton(for: action)
            button.tag = index
            buttonStackView.addArrangedSubview(button)
        }
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        
        self.frame = window.bounds
        self.alpha = 0
        window.addSubview(self)
        
        containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.containerView.transform = .identity
            self.containerView.alpha = 1
        }
        
        // Update blur effect frame and button gradient layers
        DispatchQueue.main.async {
            self.blurEffectView.frame = self.containerView.bounds
            self.updateButtonGradientLayers()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        blurEffectView.frame = containerView.bounds
        updateButtonGradientLayers()
    }
    
    private func updateButtonGradientLayers() {
        for button in buttonStackView.arrangedSubviews {
            if let btn = button as? UIButton {
                if let gradientLayer = btn.layer.sublayers?.first(where: { $0 is CAGradientLayer }) as? CAGradientLayer {
                    gradientLayer.frame = btn.bounds
                }
            }
        }
    }
    
    private func createStyledButton(for action: DialogAction) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(action.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.layer.cornerRadius = 14
        button.translatesAutoresizingMaskIntoConstraints = false
        
        // Create gradient layer
        let gradientLayer = CAGradientLayer()
        
        switch action.style {
        case .primary:
            gradientLayer.colors = [
                ArcaneConfiguration.ColorPalette.startButtonGradientStart.cgColor,
                ArcaneConfiguration.ColorPalette.startButtonGradientEnd.cgColor
            ]
            button.setTitleColor(.white, for: .normal)
            button.layer.shadowColor = ArcaneConfiguration.ColorPalette.neonPink.cgColor
        case .secondary:
            gradientLayer.colors = [
                UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.8).cgColor,
                UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.8).cgColor
            ]
            button.setTitleColor(.white, for: .normal)
            button.layer.shadowColor = UIColor.gray.cgColor
        case .destructive:
            gradientLayer.colors = [
                UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1.0).cgColor,
                UIColor(red: 0.8, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
            ]
            button.setTitleColor(.white, for: .normal)
            button.layer.shadowColor = UIColor.red.cgColor
        }
        
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.cornerRadius = 14
        button.layer.insertSublayer(gradientLayer, at: 0)
        
        // Neon glow effect
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.6
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.masksToBounds = false
        
        // Update gradient frame
        DispatchQueue.main.async {
            gradientLayer.frame = button.bounds
        }
        
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        
        // Button press animation
        button.addTarget(self, action: #selector(dialogButtonPressed(_:)), for: .touchDown)
        button.addTarget(self, action: #selector(dialogButtonReleased(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        
        return button
    }
    
    @objc private func dialogButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }
    }
    
    @objc private func dialogButtonReleased(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            sender.transform = .identity
        }
    }
    
    @objc private func actionButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        guard index < storedActions.count else { return }
        
        let action = storedActions[index]
        dismissWithAnimation {
            action.handler?()
        }
    }
    
    func dismissWithAnimation(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            self.containerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }) { _ in
            self.removeFromSuperview()
            completion?()
        }
    }
}

// MARK: - Dialog Action
struct DialogAction {
    enum ActionStyle {
        case primary
        case secondary
        case destructive
    }
    
    let title: String
    let style: ActionStyle
    let handler: (() -> Void)?
    
    init(title: String, style: ActionStyle = .primary, handler: (() -> Void)? = nil) {
        self.title = title
        self.style = style
        self.handler = handler
    }
}


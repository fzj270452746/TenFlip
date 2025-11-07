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
        view.backgroundColor = UIColor(red: 0.95, green: 0.93, blue: 0.88, alpha: 1.0)
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1.0).cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = true
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 0.6, green: 0.3, blue: 0.2, alpha: 1.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
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
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        addSubview(containerView)
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
            containerView.widthAnchor.constraint(equalToConstant: 300),
            containerView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -20),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            containerHeightConstraint,
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
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
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut) {
            self.alpha = 1
            self.containerView.transform = .identity
        }
    }
    
    private func createStyledButton(for action: DialogAction) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(action.title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch action.style {
        case .primary:
            button.backgroundColor = UIColor(red: 0.8, green: 0.4, blue: 0.2, alpha: 1.0)
            button.setTitleColor(.white, for: .normal)
        case .secondary:
            button.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1.0)
            button.setTitleColor(.white, for: .normal)
        case .destructive:
            button.backgroundColor = UIColor(red: 0.9, green: 0.3, blue: 0.3, alpha: 1.0)
            button.setTitleColor(.white, for: .normal)
        }
        
        button.addTarget(self, action: #selector(actionButtonTapped(_:)), for: .touchUpInside)
        
        return button
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


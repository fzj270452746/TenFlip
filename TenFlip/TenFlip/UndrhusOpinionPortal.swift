

import UIKit

protocol OpinionValidator {
    func validate(_ content: String) -> Bool
    func validationMessage() -> String
}

class StandardOpinionValidator: OpinionValidator {
    func validate(_ content: String) -> Bool {
        return !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    func validationMessage() -> String {
        return "Please enter your feedback before submitting."
    }
}

class UndrhusOpinionPortal: UIViewController {
    
    private let validator: OpinionValidator = StandardOpinionValidator()
    private let resourceProvider = StandardResourceProvider()
    
    private lazy var backgroundTexture: UIImageView = {
        let iv = UIImageView()
        iv.image = resourceProvider.obtainBackgroundTexture()
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var dimmerOverlay: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var scrollContainer: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private lazy var contentArea: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var retreatButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("← Back", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        btn.layer.cornerRadius = 20
        btn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return btn
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Feedback"
        lbl.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "We value your feedback! Please share your thoughts, suggestions, or report any issues."
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = .white
        lbl.textAlignment = .center
        lbl.numberOfLines = 0
        lbl.shadowColor = UIColor.black.withAlphaComponent(0.5)
        lbl.shadowOffset = CGSize(width: 1, height: 1)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var opinionField: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        tv.textColor = .black
        tv.backgroundColor = ArcaneConfiguration.ColorPalette.neutralIvory.withAlphaComponent(0.95)
        tv.layer.cornerRadius = ArcaneConfiguration.LayoutMetrics.cornerRadius
        tv.layer.borderWidth = 2
        tv.layer.borderColor = ArcaneConfiguration.ColorPalette.shadowObsidian.cgColor
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private lazy var placeholderText: UILabel = {
        let lbl = UILabel()
        lbl.text = "Enter your feedback here..."
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        lbl.textColor = UIColor.lightGray
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var transmitButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Submit", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        btn.backgroundColor = ArcaneConfiguration.ColorPalette.primaryBronze
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = ArcaneConfiguration.LayoutMetrics.cornerRadius
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = ArcaneConfiguration.LayoutMetrics.shadowOffset
        btn.layer.shadowOpacity = ArcaneConfiguration.LayoutMetrics.shadowOpacity
        btn.layer.shadowRadius = ArcaneConfiguration.LayoutMetrics.shadowRadius
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(transmitOpinion), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assembleInterface()
        establishKeyboardHandlers()
        establishTapRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func assembleInterface() {
        view.addSubview(backgroundTexture)
        view.addSubview(dimmerOverlay)
        view.addSubview(scrollContainer)
        scrollContainer.addSubview(contentArea)
        
        contentArea.addSubview(titleLabel)
        contentArea.addSubview(descriptionLabel)
        contentArea.addSubview(opinionField)
        opinionField.addSubview(placeholderText)
        contentArea.addSubview(transmitButton)
        
        view.addSubview(retreatButton)
        
        NSLayoutConstraint.activate([
            backgroundTexture.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundTexture.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTexture.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundTexture.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dimmerOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            dimmerOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmerOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmerOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentArea.topAnchor.constraint(equalTo: scrollContainer.topAnchor),
            contentArea.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor),
            contentArea.trailingAnchor.constraint(equalTo: scrollContainer.trailingAnchor),
            contentArea.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor),
            contentArea.widthAnchor.constraint(equalTo: scrollContainer.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentArea.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor, constant: -20),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor, constant: 30),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor, constant: -30),
            
            opinionField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            opinionField.leadingAnchor.constraint(equalTo: contentArea.leadingAnchor, constant: 20),
            opinionField.trailingAnchor.constraint(equalTo: contentArea.trailingAnchor, constant: -20),
            opinionField.heightAnchor.constraint(equalToConstant: 200),
            
            placeholderText.topAnchor.constraint(equalTo: opinionField.topAnchor, constant: 12),
            placeholderText.leadingAnchor.constraint(equalTo: opinionField.leadingAnchor, constant: 16),
            placeholderText.trailingAnchor.constraint(equalTo: opinionField.trailingAnchor, constant: -16),
            
            transmitButton.topAnchor.constraint(equalTo: opinionField.bottomAnchor, constant: 30),
            transmitButton.centerXAnchor.constraint(equalTo: contentArea.centerXAnchor),
            transmitButton.widthAnchor.constraint(equalToConstant: 200),
            transmitButton.heightAnchor.constraint(equalToConstant: ArcaneConfiguration.LayoutMetrics.buttonHeight),
            transmitButton.bottomAnchor.constraint(equalTo: contentArea.bottomAnchor, constant: -40),
            
            retreatButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            retreatButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func establishKeyboardHandlers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillEmerge),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillRecede),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func establishTapRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissView() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillEmerge(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollContainer.contentInset = inset
        scrollContainer.scrollIndicatorInsets = inset
    }
    
    @objc private func keyboardWillRecede(notification: NSNotification) {
        scrollContainer.contentInset = .zero
        scrollContainer.scrollIndicatorInsets = .zero
    }
    
    @objc private func transmitOpinion() {
        let content = opinionField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !validator.validate(content) {
            displayValidationError()
            return
        }
        
        AncientVaultKeeper.shared.saveFeedbackEntry(content)
        displaySuccessConfirmation()
    }
    
    private func displayValidationError() {
        let portal = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "OK", style: .primary, handler: nil)
        ]
        portal.manifestWithConfiguration(
            title: "Empty Feedback",
            message: validator.validationMessage(),
            actions: actions
        )
    }
    
    private func displaySuccessConfirmation() {
        let portal = LuminousDialogPortal()
        let actions = [
            DialogAction(title: "OK", style: .primary) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
        ]
        portal.manifestWithConfiguration(
            title: "Thank You!",
            message: "Your feedback has been submitted successfully.",
            actions: actions
        )
        
        opinionField.text = ""
        placeholderText.isHidden = false
    }
}

extension UndrhusOpinionPortal: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderText.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderText.isHidden = !textView.text.isEmpty
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeholderText.isHidden = !textView.text.isEmpty
    }
}


//
//  LoginView.swift
//  eTVShow
//
//  Created by Aldair Carrillo on 23/12/22.
//

import UIKit
import Combine

/////////////////////// LOGIN VIEW PROTOCOL
protocol LoginViewProtocol: AnyObject {
    var presenter: LoginPresenterProtocol? { get set }
}

////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// LOGIN  VIEW
///////////////////////////////////////////////////////////////////////////////////////////////////

class LoginView: UIViewController {
    
    private let emptyMessage: String = "Required"
    
    private lazy var imgTop: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.image = UIImage(named: "topImage")
        return image
    }()
    
    private lazy var imgLogo: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.image = UIImage(named: "logoLogin")
        return image
    }()
    
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 15
        return stack
    }()
    private lazy var txtUser: TextFieldWithPadding = {
        let txt = TextFieldWithPadding()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Username"
        txt.configure()
        return txt
    }()
    
    private lazy var txtPassword: TextFieldWithPadding = {
        let txt = TextFieldWithPadding()
        txt.translatesAutoresizingMaskIntoConstraints = false
        txt.placeholder = "Password"
        txt.isSecureTextEntry = true
        txt.configure()
        return txt
    }()
    
    private lazy var lblUserError: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .red
        lbl.text = emptyMessage
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var lblPasswordError: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .red
        lbl.text = emptyMessage
        lbl.isHidden = true
        return lbl
    }()
    
    private lazy var btnLogin: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.backgroundColor = UIColor(named: "principal")?.cgColor
        btn.layer.borderWidth = 2
        btn.layer.cornerRadius = 8
        btn.addTarget(self, action: #selector(tappedAction), for: .touchUpInside)
        return btn
    }()
    
    var presenter: LoginPresenterProtocol?

    private var subscriptions = Set<AnyCancellable>()
    private var userValue: String?
    private var passwordValue: String?
    private let presenterInput: LoginPresenterInput = LoginPresenterInput()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundLogin")
        setupView()
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

private extension LoginView {
    
    func bind() {
        txtUser.textPublisher
            .sink(receiveValue: { [weak self] text in
                self?.lblUserError.isHidden = !text.isEmpty
                self?.userValue = text
            }).store(in: &subscriptions)
        
        txtPassword.textPublisher
            .sink(receiveValue: { [weak self] text in
                self?.lblPasswordError.isHidden = !text.isEmpty
                self?.passwordValue = text
            }).store(in: &subscriptions)
        
        let output = presenter?.bind(input: presenterInput)
        
        output?.loginDataErrorPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] error in
                self?.btnLogin.isEnabled = true
                self?.presentAlert("We are sorry, and error has ocurred!", message: error.localizedDescription)
        }).store(in: &subscriptions)
    }
    
    func setupView() {
        stackView.addArrangedSubview(lblUserError)
        stackView.addArrangedSubview(txtUser)
        stackView.addArrangedSubview(lblPasswordError)
        stackView.addArrangedSubview(txtPassword)
        
        view.addSubview(imgTop)
        view.addSubview(imgLogo)
        view.addSubview(stackView)
        view.addSubview(btnLogin)
        
        NSLayoutConstraint.activate([
            imgTop.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            imgTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            imgTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            imgTop.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.height / 3)),
            
            imgLogo.topAnchor.constraint(equalTo: imgTop.bottomAnchor, constant: 10),
            imgLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imgLogo.widthAnchor.constraint(equalToConstant: 150),
            imgLogo.heightAnchor.constraint(equalToConstant: 150),
            
            stackView.topAnchor.constraint(equalTo: imgLogo.bottomAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
            
            btnLogin.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            btnLogin.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 65),
            btnLogin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -65),
            btnLogin.heightAnchor.constraint(equalToConstant: 65)
        ])
    }
    
    @objc func tappedAction() {
        if let input = isInputValid(),
            input.0 {
            DispatchQueue.main.async {
                self.btnLogin.isEnabled = false
            }
            presenterInput.tapToLogin.send((input.1, input.2))
        }
    }
    
    func isInputValid() -> (Bool, String, String)? {
        guard let userValue = userValue,
              !userValue.isEmpty else {
            lblUserError.isHidden = false
            return nil
        }
        
        guard let passwordValue = passwordValue,
              !passwordValue.isEmpty else {
            lblPasswordError.isHidden = false
            return nil
        }
        
        return (true, userValue, passwordValue)
    }
    
    func presentAlert(_ title: String, message: String) {
        self.openAlert(title: title,
                              message: message,
                             alertStyle: .alert,
                              actionTitles: ["Ok"],
                              actionStyles: [.default],
                              actions: [ {_ in
                                            print("Ok")
                                        },])
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}

extension LoginView: LoginViewProtocol { }

//
//  LoginViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics
import IQKeyboardManagerSwift
import Zero

class LoginViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userView: UIStackView!
    @IBOutlet weak var userTextField: ZeroTextField!
    @IBOutlet weak var passwordView: UIStackView!
    @IBOutlet weak var passwordTextField: ZeroTextField!
    @IBOutlet weak var enterButton: ZeroContainedButton!
    
    var presenter: LoginPresenterDelegate?
    var alert = ZeroDialog()
    var userTextFieldController: ZeroTextFieldControllerFilled?
    var passwordTextFieldController: ZeroTextFieldControllerFilled?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTextFieldsStyle()
        loadOthersStyle()
        crashlyticsErrorSending()
        loadKeyboard()
    }
    
}

extension LoginViewController{
    
    func crashlyticsErrorSending(){
        guard let email = userTextField.text else {return}
        Crashlytics.crashlytics().setUserID(email)
        Crashlytics.crashlytics().setCustomValue(email, forKey: CrashlyticsConstants.key)
        Crashlytics.crashlytics().log(CrashlyticsConstants.Login.log)
    }
    
    func loadTextFieldsStyle(){
        userTextFieldController = ZeroTextFieldControllerFilled(textInput: userTextField)
        userTextFieldController?.placeholderText = HomeConstants.emailTitle
        userTextField.delegate = self
        passwordTextFieldController = ZeroTextFieldControllerFilled(textInput: passwordTextField)
        passwordTextFieldController?.placeholderText = HomeConstants.passwordTitle
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        userTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
    }
    
    func loadOthersStyle(){
        titleLabel.apply(ZeroTheme.Label.head2)
        userView.layer.cornerRadius = 3
        passwordView.layer.cornerRadius = 3
        navigationItem.backButtonTitle = HomeConstants.backButtonTitle
        titleLabel.text = HomeConstants.loginButtonTitle
        enterButton.setTitle(HomeConstants.enterButtonTitle, for: .normal)
    }
    
    func loadKeyboard(){
        IQKeyboardManager.shared.enable = true
        userTextField.keyboardType = .emailAddress
    }
}

extension LoginViewController{
    
    @IBAction func pressedEnterButton(_ sender: Any) {
        guard let email = userTextField.text, let password = passwordTextField.text else{return}
        if (password.isEmpty) && (email.isEmpty){
            createAlert(title: HomeConstants.emailAndPasswordError, message: HomeConstants.emailAndPasswordEmptyError)
        }else if email.isEmpty || email == ""{
            createAlert(title: HomeConstants.emailError, message: HomeConstants.emailEmptyError)
        }else if password.isEmpty {
            createAlert(title: HomeConstants.passwordError, message: HomeConstants.passwordEmptyError)
        }else{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {//Mal contra , UserNotFound, InvalidEmail
                    let parsedError = error as NSError
                    switch parsedError.code {
                    case FirebaseErrors.errorCodeInvalidEmail:
                        self.createAlert(title: HomeConstants.emailError, message: HomeConstants.invalidEmailError)
                    case FirebaseErrors.errorEmailAlreadyInUse:
                        self.createAlert(title: HomeConstants.emailError, message: HomeConstants.alreadyUsedEmailError)
                    case FirebaseErrors.errorCodeUserNotFound:
                        self.createAlert(title: HomeConstants.emailError, message: HomeConstants.userNotFoundError)
                    case FirebaseErrors.errorCodeWrongPassword:
                        self.createAlert(title: HomeConstants.passwordError, message: HomeConstants.wrongPasswordError)
                    default:
                        print("default error in login")
                    }
                }else {
                    self.presenter?.openMainTabBar()
                }
            }
        }
        
    }
    
    func createAlert(title: String, message: String){
        alert.show(
            title: title,
            info: message,
            titleOk: HomeConstants.okTitle,
            completionOk: nil
        )
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}

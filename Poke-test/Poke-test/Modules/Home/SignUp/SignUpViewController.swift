
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics
import IQKeyboardManagerSwift
import Zero

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userTextField: ZeroTextField!
    @IBOutlet weak var passwordTextField: ZeroTextField!
    @IBOutlet weak var enterButton: ZeroContainedButton!
    @IBOutlet weak var userView: UIStackView!
    @IBOutlet weak var passwordView: UIStackView!
    
    var alert = ZeroDialog()
    var userTextFieldController: ZeroTextFieldControllerFilled?
    var passwordTextFieldController: ZeroTextFieldControllerFilled?
    var presenter: SignUpPresenterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTextFieldsStyle()
        loadOthersStyle()
        crashlyticsErrorSending()
        loadKeyboard()
    }
    
}

extension SignUpViewController{
    
    func crashlyticsErrorSending(){
        guard let email = userTextField.text else {return}
        Crashlytics.crashlytics().setUserID(email)
        Crashlytics.crashlytics().setCustomValue(email, forKey: CrashlyticsConstants.key)
        Crashlytics.crashlytics().log(CrashlyticsConstants.SignUpWIndow.log)
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
        userView.layer.cornerRadius = 3
        passwordView.layer.cornerRadius = 3
        titleLabel.apply(ZeroTheme.Label.head2)
        navigationItem.backButtonTitle = HomeConstants.backButtonTitle
        titleLabel.text = HomeConstants.signUpButtonTitle
        enterButton.setTitle(HomeConstants.enterButtonTitle, for: .normal)
    }
    
    func loadKeyboard(){
        IQKeyboardManager.shared.enable = true
        userTextField.keyboardType = .emailAddress
    }
}


//MARK: - SignUpViewDelegate methods
extension SignUpViewController: SignUpViewDelegate {
    
    @IBAction func pressedEnterButton(_ sender: Any) {
        guard let email = userTextField.text, let password = passwordTextField.text else{return}
        let ref = Database.database().reference().root
        if (password.isEmpty) && (email.isEmpty){
            createAlert(title: HomeConstants.emailAndPasswordError, message: HomeConstants.emailAndPasswordEmptyError)
        }else if email.isEmpty || email == ""{
            createAlert(title: HomeConstants.emailError, message: HomeConstants.emailEmptyError)
        }else if password.isEmpty {
            createAlert(title: HomeConstants.passwordError, message: HomeConstants.passwordEmptyError)
        }else{
            Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                if let error = error{
                    let parsedError = error as NSError
                    switch parsedError.code {
                    case FirebaseErrors.errorCodeInvalidEmail:
                        self.createAlert(title: HomeConstants.emailError, message: HomeConstants.invalidEmailError)
                    case FirebaseErrors.errorEmailAlreadyInUse:
                        self.createAlert(title: HomeConstants.emailError, message: HomeConstants.alreadyUsedEmailError)
                    case FirebaseErrors.errorCodeWeakPassword:
                        self.createAlert(title: HomeConstants.passwordError, message: HomeConstants.weakPasswordError)
                    default:
                        print("default error in signing up!")
                    }
                }else{
                    guard let uid = user?.user.uid else{return}
                    ref.child("users").child(uid).setValue(email)
                    self.presenter?.openMainTabBar()
                }
            })
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

extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}

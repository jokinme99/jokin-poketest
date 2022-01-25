import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics
import IQKeyboardManagerSwift
import Zero


//MARK: - LoginViewController
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
        loadStyle()
        titleLabel.text = NSLocalizedString("Login", comment: "")
        enterButton.setTitle(NSLocalizedString("Enter", comment: ""), for: .normal)
        crashlyticsErrorSending()
        loadKeyboard()
        navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
    }
    
    func loadStyle(){
        userTextFieldController = ZeroTextFieldControllerFilled(textInput: userTextField)
        userTextFieldController?.placeholderText = NSLocalizedString("Email", comment: "")
        userTextField.delegate = self
        passwordTextFieldController = ZeroTextFieldControllerFilled(textInput: passwordTextField)
        passwordTextFieldController?.placeholderText = NSLocalizedString("Password", comment: "")
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        titleLabel.apply(ZeroTheme.Label.head2)
        userTextField.layer.cornerRadius = 5
        passwordTextField.layer.cornerRadius = 5
    }
}


//MARK: - ViewDidLoad methods
extension LoginViewController{
    
    
    //MARK: - crashlyticsErrorSending
    func crashlyticsErrorSending(){
        guard let email = userTextField.text else {return}
        //Enviar email del usuario
        Crashlytics.crashlytics().setUserID(email)
        //Enviar claves personalizadas
        Crashlytics.crashlytics().setCustomValue(email, forKey: "USER")
        //Enviar logs de errores
        Crashlytics.crashlytics().log("Error in LoginViewController")
    }
    
    
    //MARK: - loadKeyboard()
    func loadKeyboard(){
        IQKeyboardManager.shared.enable = true
        userTextField.keyboardType = .emailAddress
    }
}


//MARK: - LoginViewDelegate methods
extension LoginViewController: LoginViewDelegate {
    
    
    //MARK: - pressedEnterButton
    @IBAction func pressedEnterButton(_ sender: Any) {
        guard let email = userTextField.text, let password = passwordTextField.text else{return}
        if (password.isEmpty) && (email.isEmpty){
            createAlert(title: NSLocalizedString("email_and_password_error", comment: ""), message: NSLocalizedString("email_and_password_empty_error", comment: ""))
        }else if email.isEmpty || email == ""{
            createAlert(title: NSLocalizedString("email_error", comment: ""), message: NSLocalizedString("email_empty_error", comment: ""))
        }else if password.isEmpty {
            createAlert(title: NSLocalizedString("password_error", comment: ""), message: NSLocalizedString("password_empty_error", comment: ""))
        }else{
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if let error = error {//Mal contra , UserNotFound, InvalidEmail
                    let parsedError = error as NSError
                    switch parsedError.code {
                    case FirebaseErrors.errorCodeInvalidEmail:
                        self.createAlert(title: NSLocalizedString("email_error", comment: ""), message: NSLocalizedString("invalid_email_error", comment: ""))
                    case FirebaseErrors.errorEmailAlreadyInUse:
                        self.createAlert(title: NSLocalizedString("email_error", comment: ""), message: NSLocalizedString("already_in_use_email_error", comment: ""))
                    case FirebaseErrors.errorCodeUserNotFound:
                        self.createAlert(title: NSLocalizedString("email_error", comment: ""), message: NSLocalizedString("user_not_found_error", comment: ""))
                    case FirebaseErrors.errorCodeWrongPassword:
                        self.createAlert(title: NSLocalizedString("password_error", comment: ""), message: NSLocalizedString("wrong_password_error", comment: ""))
                    default:
                        print("default error in login")
                    }
                    //Compare codes if same error(localizated)
                }else {
                    self.presenter?.openMainTabBar()
                }
            }
        }
        
    }
    
    
    //MARK: - createAlert
    func createAlert(title: String, message: String){
        alert.show(
            title: title,
            info: message,
            titleOk: "OK",
            completionOk: nil
        )
    }
}


//MARK: - SignUpViewDelegate methods
extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.endEditing(true)
    }
}

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics


//MARK: - SignUpViewController
class SignUpViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    var presenter: SignUpPresenterDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userView.layer.cornerRadius = 10
        passwordView.layer.cornerRadius = 10
        enterButton.layer.cornerRadius = 10
        titleLabel.text = NSLocalizedString("Sign_Up", comment: "")
        userLabel.text = NSLocalizedString("Email", comment: "")
        passwordLabel.text = NSLocalizedString("Password", comment: "")
        enterButton.setTitle(NSLocalizedString("Enter", comment: ""), for: .normal)
        crashlyticsErrorSending()
    }
}


//MARK: - ViewDidLoad methods
extension SignUpViewController{
    
    
    //MARK: - crashlyticsErrorSending
    func crashlyticsErrorSending(){
        guard let email = userTextField.text else {return}
        //Enviar email del usuario
        Crashlytics.crashlytics().setUserID(email)
        //Enviar claves personalizadas
        Crashlytics.crashlytics().setCustomValue(email, forKey: "USER")
        //Enviar logs de errores
        Crashlytics.crashlytics().log("Error in SignUpViewController")
    }
}


//MARK: - SignUpViewDelegate methods
extension SignUpViewController: SignUpViewDelegate {
    
    
    //MARK: - pressedEnterButton
    @IBAction func pressedEnterButton(_ sender: Any) {
        guard let email = userTextField.text, let password = passwordTextField.text else{return}
        let ref = Database.database().reference().root
        if (password.isEmpty) && (email.isEmpty){
            createAlert(title: NSLocalizedString("email_and_password_error", comment: ""), message: NSLocalizedString("email_and_password_empty_error", comment: ""))
        }else if email.isEmpty || email == ""{
            createAlert(title: NSLocalizedString("email_error", comment: ""), message: NSLocalizedString("email_empty_error", comment: ""))
        }else if password.isEmpty {
            createAlert(title: NSLocalizedString("password_error", comment: ""), message: NSLocalizedString("password_empty_error", comment: ""))
        }else{
            Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                if let error = error{
                    let parsedError = error as NSError
                    switch parsedError.code {
                    case FirebaseErrors.errorCodeInvalidEmail:
                        self.createAlert(title: NSLocalizedString("email_error", comment: ""), message: NSLocalizedString("invalid_email_error", comment: ""))
                    case FirebaseErrors.errorEmailAlreadyInUse:
                        self.createAlert(title: NSLocalizedString("email_error", comment: ""), message: NSLocalizedString("already_in_use_email_error", comment: ""))
                    case FirebaseErrors.errorCodeWeakPassword:
                        self.createAlert(title: NSLocalizedString("password_error", comment: ""), message: NSLocalizedString("weak_password_error", comment: ""))
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
    
    
    //MARK: - createAlert
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
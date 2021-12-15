//
//  LoginViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics

class LoginViewController: UIViewController {

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
    var presenter: LoginPresenterDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        userView.layer.cornerRadius = 10
        passwordView.layer.cornerRadius = 10
        enterButton.layer.cornerRadius = 10
        titleLabel.text = NSLocalizedString("Login", comment: "")
        userLabel.text = NSLocalizedString("Email", comment: "")
        passwordLabel.text = NSLocalizedString("Password", comment: "")
        enterButton.setTitle(NSLocalizedString("Enter", comment: ""), for: .normal)
        crashlyticsErrorSending()
    }
}
//MARK: - ViewDidLoad methods
extension LoginViewController{
    func crashlyticsErrorSending(){
        guard let email = userTextField.text else {return}
        //Enviar email del usuario
        Crashlytics.crashlytics().setUserID(email)
        //Enviar claves personalizadas
        Crashlytics.crashlytics().setCustomValue(email, forKey: "USER")
        //Enviar logs de errores
        Crashlytics.crashlytics().log("Error in LoginViewController")
    }
}
//MARK: - Buttons methods
extension LoginViewController: LoginViewDelegate {
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
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

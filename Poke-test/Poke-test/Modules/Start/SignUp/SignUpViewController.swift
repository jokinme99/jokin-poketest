//
//  SignUpViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

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
    }
}

extension SignUpViewController: SignUpViewDelegate {
    
    @IBAction func pressedEnterButton(_ sender: Any) {
        guard let email = userTextField.text, let password = passwordTextField.text else{return}
        let ref = Database.database().reference().root
        if (password.isEmpty) && (email.isEmpty){
            createAlert(title: "Email and password error!", message: NSLocalizedString("email_and_password_empty_error", comment: ""))
        }else if email.isEmpty || email == ""{
            createAlert(title: "Email error!", message: NSLocalizedString("email_empty_error", comment: ""))
        }else if password.isEmpty {
            createAlert(title: "Password error!", message: NSLocalizedString("password_empty_error", comment: ""))
        }else{
            Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                if let error = error{
                    let parsedError = error as NSError
                    switch parsedError.code {
                    case FirebaseErrors.errorCodeInvalidEmail:
                        self.createAlert(title: "Email error!", message: NSLocalizedString("invalid_email_error", comment: ""))
                    case FirebaseErrors.errorEmailAlreadyInUse:
                        self.createAlert(title: "Email error!", message: NSLocalizedString("already_in_use_email_error", comment: ""))
                    case FirebaseErrors.errorCodeWeakPassword:
                        self.createAlert(title: "Password error!", message: NSLocalizedString("weak_password_error", comment: ""))
                    default:
                        print("default error in signing up!")
                    }
                }else{
                    ref.child("users").child((user?.user.uid)!).setValue(email)
                    self.presenter?.openMainTabBar()
                }
            })
            /*ref.child("users").observe(.value, with: { snapshot in
               ref.child("users").removeAllObservers()
                let savedEmails = snapshot.value as![String:Any]
                for selectedEmail in savedEmails{
                    if selectedEmail.value as! String  == email{
                        self.createAlert(title: "Email error!", message: "Email already exists.")
                        break
                    }else{
                        
                    }
                }
            })*/
        }
        
    }
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

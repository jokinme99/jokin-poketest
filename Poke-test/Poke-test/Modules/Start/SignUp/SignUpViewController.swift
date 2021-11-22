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
import ValidationComponents

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
        let isEmailValid = EmailValidationPredicate().evaluate(with: "\(email)")
        if (password.isEmpty || password == "") && (email.isEmpty || email == ""){
            createAlert(title: "Email and password error!", message: "Email and password don't have any value.")
        }else if email.isEmpty || email == ""{
            createAlert(title: "Email error!", message: "Enter an email please.")
        }else if password.isEmpty || password == "" {
            createAlert(title: "Password error!", message: "Enter a password please.")
        }else if password.count < 6 && isEmailValid == true{
            createAlert(title: "Password error!", message: "The password must have at least 6 characters.")
        }else if isEmailValid == false && password.count >= 6{
            createAlert(title: "Email error!", message: "Introduced email's format is not valid.")
        }else if password.count <= 6 && EmailValidationPredicate().evaluate(with: "\(email)") == false{
            createAlert(title: "Email and password error!", message: "Neither the introduced email's format is not valid, nor the password is at least 6 characters long.")
        }else{
            ref.child("users").observe(.value, with: { snapshot in                
               ref.child("users").removeAllObservers()
                let savedEmails = snapshot.value as![String:Any]
                for selectedEmail in savedEmails{
                    if selectedEmail.value as! String  == email{
                        self.createAlert(title: "Email error!", message: "Email already exists.")
                        break
                    }else{
                        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
                            if error == nil{
                                ref.child("users").child((user?.user.uid)!).setValue(email)
                                self.presenter?.openMainTabBar()
                            }
                        })
                    }
                }
            })
        }
        
    }
    func createAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

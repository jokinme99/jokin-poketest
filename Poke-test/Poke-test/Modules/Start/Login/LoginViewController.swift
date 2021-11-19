//
//  LoginViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit
//Colors
//Check if email and password correct, if not wrong(alert)
//Check if email exists, if not wrong(alert)
//If correct take to the mainTabBar with that user's favourite pokemons
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
    }
}

extension LoginViewController: LoginViewDelegate {

}

//
//  LoginOrSignUpViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/11/21.
//

import UIKit

class LoginOrSignUpViewController: UIViewController {

    var presenter: LoginOrSignUpPresenterDelegate?
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var toLoginMenuView: UIView!
    @IBOutlet weak var toLoginMenuButton: UIButton!
    @IBOutlet weak var toSignUpMenuView: UIView!
    @IBOutlet weak var toSignUpMenuButton: UIButton!
    @IBOutlet weak var notLoginOrSignUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toLoginMenuButton.setTitle("Login", for: .normal)
        toSignUpMenuButton.setTitle("Sign Up", for: .normal)
        toLoginMenuView.layer.cornerRadius = 10
        toSignUpMenuView.layer.cornerRadius = 10
    }
}
//MARK: - Buttons methods
extension LoginOrSignUpViewController: LoginOrSignUpViewDelegate{
    @IBAction func pressedToLoginMenuButton(_ sender: Any) {
        presenter?.openLoginWindow()
    }
    @IBAction func pressedToSignUpMenuButton(_ sender: Any) {
        presenter?.openSignUpWindow()
    }
    @IBAction func pressedNotLoginOrSignUpButton(_ sender: Any) {
        presenter?.openPokemonListWindow()
    }
    
}

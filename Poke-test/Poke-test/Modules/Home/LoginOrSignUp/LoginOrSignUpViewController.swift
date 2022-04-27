//
//  LoginOrSignUpViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 19/11/21.
//
import UIKit
import FirebaseCrashlytics
import Zero

class LoginOrSignUpViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var toLoginMenuButton: ZeroOutlineButton!
    @IBOutlet weak var toSignUpMenuButton: ZeroOutlineButton!
    @IBOutlet weak var notLoginOrSignUpButton: ZeroTextButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var presenter: LoginOrSignUpPresenterDelegate?
    var alert = ZeroDialog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadButtonsStyle()
        loadNavItemStyle()
        crashlyticsErrorSending()
    }
}

extension LoginOrSignUpViewController{
    
    func crashlyticsErrorSending(){
        Crashlytics.crashlytics().setCustomValue(CrashlyticsConstants.LoginOrSignUp.message, forKey: CrashlyticsConstants.key)
        Crashlytics.crashlytics().log(CrashlyticsConstants.LoginOrSignUp.log)
    }
    
    func loadButtonsStyle(){
        toLoginMenuButton.setTitle(HomeConstants.loginButtonTitle, for: .normal)
        toSignUpMenuButton.setTitle(HomeConstants.signUpButtonTitle, for: .normal)
        notLoginOrSignUpButton.setTitle(HomeConstants.noUserButtonTitle, for: .normal)
        toLoginMenuButton.layer.cornerRadius = 10
        toSignUpMenuButton.layer.cornerRadius = 10
        toSignUpMenuButton.backgroundColor = .customButtonBackgroundColor
        toLoginMenuButton.backgroundColor = .customButtonBackgroundColor
        toLoginMenuButton.apply(ZeroTheme.Button.outlined)
        toSignUpMenuButton.apply(ZeroTheme.Button.outlined)
        toSignUpMenuButton.layer.borderColor = UIColor.customButtonBackgroundColor?.cgColor
        toLoginMenuButton.layer.borderColor = UIColor.customButtonBackgroundColor?.cgColor
        notLoginOrSignUpButton.apply(ZeroTheme.Button.normal)
    }
    
    func loadNavItemStyle(){
        titleLabel.text = HomeConstants.welcomeTitle
        navigationItem.backButtonTitle = HomeConstants.backButtonTitle
        titleLabel.apply(ZeroTheme.Label.head1)
        titleLabel.textColor = ZeroColor.primary
        navigationItem.title = HomeConstants.navigationItemTitle
    }
}

extension LoginOrSignUpViewController{
    
    @IBAction func pressedToLoginMenuButton(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            presenter?.openLoginWindow()
        } else {
            alert.show(
                title: HomeConstants.noInternetTitle,
                info: HomeConstants.noInternetLogin,
                titleOk: HomeConstants.noInternetOKButtonTitle,
                titleCancel: HomeConstants.noInternetCancelButtonTitle,
                completionOk: {
                    self.openSettings()
                },
                completionCancel: nil
            )
        }
    }
    
    @IBAction func pressedToSignUpMenuButton(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            presenter?.openSignUpWindow()
        } else {
            alert.show(
                title: HomeConstants.noInternetTitle,
                info: HomeConstants.noInternetSignUp,
                titleOk: HomeConstants.noInternetOKButtonTitle,
                titleCancel: HomeConstants.noInternetCancelButtonTitle,
                completionOk: {
                    self.openSettings()
                },
                completionCancel: nil
            )
        }
        
    }
    
    @IBAction func pressedNotLoginOrSignUpButton(_ sender: Any) {
        presenter?.openPokemonListWindow()
    }
    
    func openSettings(){
        if let url = URL(string: UIApplication.openSettingsURLString){
            UIApplication.shared.open(url)
        }
    }
    
}


import UIKit
import FirebaseCrashlytics
import Zero

//MARK: - LoginOrSignUpViewController
class LoginOrSignUpViewController: UIViewController {

    var presenter: LoginOrSignUpPresenterDelegate?
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var toLoginMenuButton: ZeroOutlineButton!
    @IBOutlet weak var toSignUpMenuButton: ZeroOutlineButton!
    @IBOutlet weak var notLoginOrSignUpButton: ZeroTextButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadStyle()
        toLoginMenuButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        toSignUpMenuButton.setTitle(NSLocalizedString("Sign_Up", comment: ""), for: .normal)
        notLoginOrSignUpButton.setTitle(NSLocalizedString("Access_without_user", comment: ""), for: .normal)
        titleLabel.text = NSLocalizedString("Welcome", comment: "")
        toLoginMenuButton.layer.cornerRadius = 10
        toSignUpMenuButton.layer.cornerRadius = 10
        crashlyticsErrorSending()
        navigationItem.title = "POKE-TEST"
        navigationItem.backButtonTitle = NSLocalizedString("Back", comment: "")
    }
    
    func loadStyle(){
        toSignUpMenuButton.backgroundColor = UIColor(named: "grayColor")
        toLoginMenuButton.backgroundColor = UIColor(named: "grayColor")
        toLoginMenuButton.apply(ZeroTheme.Button.outlined)
        toSignUpMenuButton.apply(ZeroTheme.Button.outlined)
        toSignUpMenuButton.layer.borderColor = toSignUpMenuButton.backgroundColor?.cgColor
        toLoginMenuButton.layer.borderColor = toLoginMenuButton.backgroundColor?.cgColor
        notLoginOrSignUpButton.apply(ZeroTheme.Button.normal)
        titleLabel.apply(ZeroTheme.Label.head1)
    }
   
}


//MARK: - ViewDidLoad methods
extension LoginOrSignUpViewController{
    
    
    //MARK: - crashlyticsErrorSending
    func crashlyticsErrorSending(){
        //Enviar claves personalizadas
        Crashlytics.crashlytics().setCustomValue("not logged", forKey: "USER")
        //Enviar logs de errores
        Crashlytics.crashlytics().log("Error in MainTabBarViewController")
    }
}


//MARK: - LoginOrSignUpViewDelegate methods
extension LoginOrSignUpViewController: LoginOrSignUpViewDelegate{
    
    
    //MARK: - pressedToLoginMenuButton
    @IBAction func pressedToLoginMenuButton(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            presenter?.openLoginWindow()
        }else{
            let alert = UIAlertController(title: NSLocalizedString("No_internet_connection", comment: ""), message: NSLocalizedString("If_you_want_to_login_into_your_account_you_will_need_internet_connection", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - pressedToSignUpMenuButton
    @IBAction func pressedToSignUpMenuButton(_ sender: Any) {
        if Reachability.isConnectedToNetwork(){
            presenter?.openSignUpWindow()
        }else{
            let alert = UIAlertController(title: NSLocalizedString("No_internet_connection", comment: ""), message: NSLocalizedString("If_you_want_to_signUp_into_your_account_you_will_need_internet_connection", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    
    //MARK: - pressedNotLoginOrSignUpButton
    @IBAction func pressedNotLoginOrSignUpButton(_ sender: Any) {
        presenter?.openPokemonListWindow()
    }
    
}

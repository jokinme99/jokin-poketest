
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics
import Zero

//MARK: - MainTabBarViewController

class MainTabBarViewController: ZeroTabBarViewController {
    
    var presenter: MainTabBarPresenterDelegate?
    var list: UIViewController!
    var favourites: UIViewController!
    var collection: UIViewController!
    var titleLog: String?
    var isLogged: Bool?
    let user = Auth.auth().currentUser
    var alert = ZeroDialog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBar()
        crashlyticsErrorSending()
    }
}

//MARK: - ViewDidLoad methods
extension MainTabBarViewController{
    
    
    //MARK: - setLoggingSettings
    func setLoggingSettings(){
        if user != nil{
            titleLog = NSLocalizedString("Log_out", comment: "")
        }else{
            titleLog = NSLocalizedString("Log_in", comment: "")
        }
    }
    
    
    //MARK: - setTabBar
    func setTabBar(){
        list = PokemonListWireframe.createPokemonListModule()
        list.tabBarItem = UITabBarItem(title: NSLocalizedString("list", comment: ""), image: UIImage(named: "listNotSelected"), selectedImage: UIImage(named: "listSelected"))
        favourites = PokemonFavouritesWireframe.createPokemonFavouritesModule()
        favourites.tabBarItem = UITabBarItem(title: NSLocalizedString("FAVS", comment: ""), image: UIImage(named: "fullStar"), selectedImage: UIImage(named: "emptyStar"))
        setLoggingSettings()
        collection = PokemonCollectionWireframe.createPokemonCollectionModule()
        collection.tabBarItem = UITabBarItem(title: NSLocalizedString("collection", comment: ""), image: UIImage(named: "collectionNotSelected"), selectedImage: UIImage(named: "collectionSelected"))
        setViewControllers([list, collection, favourites], animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: titleLog, style: .plain, target: self, action: #selector(logMethod))
        navigationItem.title = "Pokedex"
        navigationItem.titleView?.apply(ZeroTheme.Label.head1)
        
    }
    
    
    //MARK: - crashlyticsErrorSending
    func crashlyticsErrorSending(){
        guard let email = user?.email else {return}
        Crashlytics.crashlytics().setUserID(email)
        Crashlytics.crashlytics().setCustomValue(email, forKey: "USER")
        Crashlytics.crashlytics().log("Error in MainTabBarViewController")
    }}


//MARK: - UITabBarControllerDelegate methods
extension MainTabBarViewController: MainTabBarViewDelegate{
}


//MARK: - LogIn/LogOut method
extension MainTabBarViewController{
    
    
    //MARK: - logMethod
    @objc func logMethod(){
        if self.titleLog == NSLocalizedString("Log_out", comment: ""){
            alert.show(
                title: NSLocalizedString("Logging_out", comment: "") + " \(user?.email ?? "default@default")",
                info: NSLocalizedString("You_are_going_to_close_this account_Are_you_sure", comment: ""),
                titleOk: NSLocalizedString("Yes", comment: ""),
                titleCancel: NSLocalizedString("No", comment: ""),
                completionOk: {
                    self.titleLog = NSLocalizedString("Log_in", comment: "")
                    self.logOut()
                    self.presenter?.openLoginSignUpWindow()
                },
                completionCancel: nil
            )
        }else{//log in
            self.presenter?.openLoginSignUpWindow()
        }
    }
    
    
    //MARK: - logOut
    func logOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
}

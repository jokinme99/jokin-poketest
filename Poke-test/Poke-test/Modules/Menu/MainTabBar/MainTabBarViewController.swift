
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics

//MARK: - MainTabBarViewController

class MainTabBarViewController: UITabBarController {
    
    var presenter: MainTabBarPresenterDelegate?
    var list: UIViewController!
    var favourites: UIViewController!
    var collection: UIViewController!
    var titleLog: String?
    var image: UIImage?
    var imageSelect: UIImage?
    var isLogged: Bool?
    let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
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
            image = UIImage(named: "logOut")
            imageSelect = UIImage(named: "logInSelected")
        }else{
            titleLog = NSLocalizedString("Log_in", comment: "")
            image = UIImage(named:"logInNotSelected")
            imageSelect = UIImage(named:"logInSelected")
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
        
    }
    
    
    //MARK: - crashlyticsErrorSending
    func crashlyticsErrorSending(){
        guard let email = user?.email else {return}
        Crashlytics.crashlytics().setUserID(email)
        Crashlytics.crashlytics().setCustomValue(email, forKey: "USER")
        Crashlytics.crashlytics().log("Error in MainTabBarViewController")
    }}


//MARK: - UITabBarControllerDelegate methods
extension MainTabBarViewController: MainTabBarViewDelegate, UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == NSLocalizedString("FAVS", comment: ""){
            navigationItem.title = NSLocalizedString("Favourites", comment: "")
        }else if item.title == NSLocalizedString("all", comment: ""){
            navigationItem.title = "Pokedex"
        }
    }
}


//MARK: - LogIn/LogOut method
extension MainTabBarViewController{
    
    
    //MARK: - logMethod
    @objc func logMethod(){
        if self.titleLog == NSLocalizedString("Log_out", comment: ""){//\(user?.email ?? "")
            //alerta si esta seguro
            let alert = UIAlertController(title: NSLocalizedString("Logging_out", comment: "") + " \(user?.email ?? "default@default")", message: NSLocalizedString("You_are_going_to_close_this account_Are_you_sure", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: ""), style: .destructive, handler: {(action) in
                self.titleLog = NSLocalizedString("Log_in", comment: "")
                self.logOut()
                self.presenter?.openLoginSignUpWindow()
            }))
            alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: ""), style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

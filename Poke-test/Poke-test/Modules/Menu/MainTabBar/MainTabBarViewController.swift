//
//  MainTabBarViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class MainTabBarViewController: UITabBarController {
    
    var presenter: MainTabBarPresenterDelegate?
    var list: UIViewController!
    var favourites: UIViewController!
    var userAdministration: UIViewController!
    var titleLog: String?
    var image: UIImage?
    var imageSelect: UIImage?
    var isLogged: Bool?
    let user = Auth.auth().currentUser
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setTabBar()
        if selectedIndex == 0{
            title = "Pokedex"
        }else if selectedIndex == 1{
            title = "Favourites"
        }
        
    }
}
//MARK: - ViewDidLoad methods
extension MainTabBarViewController{
    func setLoggingSettings(){
        if user != nil{
            titleLog = "LOG OUT"
            image = UIImage(named: "logOut")
            imageSelect = UIImage(named: "logInSelected")
        }else{
            titleLog = "LOG IN" //Change!
            image = UIImage(named:"logInNotSelected")
            imageSelect = UIImage(named:"logInSelected")
        }
    }
    func setTabBar(){
        list = PokemonListWireframe.createPokemonListModule()
        list.tabBarItem = UITabBarItem(title: "ALL", image: UIImage(named: "notSelected"), selectedImage: UIImage(named: "selected"))
        //error: #imageLiteral(resourceName:"favorites")
        favourites = PokemonFavouritesWireframe.createPokemonFavouritesModule()
        favourites.tabBarItem = UITabBarItem(title: "FAVS", image: UIImage(named: "fullStar"), selectedImage: UIImage(named: "emptyStar"))
        userAdministration = LoginOrSignUpWireframe.createLoginOrSignUpModule()//Cerrar sesion
        setLoggingSettings()
        userAdministration.tabBarItem = UITabBarItem(title: titleLog, image: image, selectedImage: imageSelect)
        setViewControllers([list, favourites,userAdministration], animated: true)
    }
}
//MARK: - UITabBarControllerDelegate methods
extension MainTabBarViewController: MainTabBarViewDelegate, UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == titleLog{
            if item.title == "LOG OUT"{
                let previousIndex = selectedIndex
                //alerta si esta seguro
                let alert = UIAlertController(title: "Logging out", message: "You are going to close \(user?.email ?? "")'s account. Are you sure?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {(action) in
                    item.title = "LOG IN"
                    let firebaseAuth = Auth.auth()
                    do {
                        try firebaseAuth.signOut()
                    } catch let signOutError as NSError {
                        print("Error signing out: %@", signOutError)
                    }
                    //logout() metodo que confirma que el usuario cierra sesion
                    //borrar los favoritos y no dejar guardar si no inicia sesion
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: {(action) in
                    self.selectedIndex = previousIndex
                    
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }else if item.title == "FAVS"{
            //check if there are any favourites
            if DDBBManager.shared.get(Favourites.self).isEmpty{
                let alert = UIAlertController(title: "Favourites", message: "You haven't added any favourites yet. Would you like to see all the available Pokemon, in order to add any of them?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Sure!", style: .default, handler: {(action) in
                    self.selectedIndex = 0
                }))
                alert.addAction(UIAlertAction(title: "Maybe later", style: .destructive, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        }
        
    }
}

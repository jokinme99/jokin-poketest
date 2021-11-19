//
//  MainTabBarViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    var presenter: MainTabBarPresenterDelegate?
    var list: UIViewController!
    var favourites: UIViewController!
    var userAdministration: UIViewController!
    var titleLog: String?
    var image: UIImage?
    var imageSelect: UIImage?
    var isLogged: Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        list = PokemonListWireframe.createPokemonListModule()
        list.tabBarItem = UITabBarItem(title: "ALL", image: UIImage(named: "notSelected"), selectedImage: UIImage(named: "selected"))
        //error: #imageLiteral(resourceName:"favorites")
        favourites = PokemonFavouritesWireframe.createPokemonFavouritesModule()
        favourites.tabBarItem = UITabBarItem(title: "FAVS", image: UIImage(named: "fullStar"), selectedImage: UIImage(named: "emptyStar"))
        userAdministration = LoginOrSignUpWireframe.createLoginOrSignUpModule()//Cerrar sesion
       
        if isLogged == true{
            titleLog = "LOG OUT"
            image = UIImage(named: "logOut")
            imageSelect = UIImage(named: "logInSelected")
        }else{
            titleLog = "LOG OUT"
            image = UIImage(named:"logInNotSelected")
            imageSelect = UIImage(named:"logInSelected")
        }
        userAdministration.tabBarItem = UITabBarItem(title: titleLog, image: image, selectedImage: imageSelect)
        setViewControllers([list, favourites,userAdministration], animated: true)
        
        
    }
}


extension MainTabBarViewController: MainTabBarViewDelegate, UITabBarControllerDelegate{
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.title == "LOG OUT"{
            //alerta si esta seguro
            let alert = UIAlertController(title: "Logging out", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                item.title = "LOG IN"
                //logout() metodo que confirma que el usuario cierra sesion
                //borrar los favoritos y no dejar guardar si no inicia sesion
            }))
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: {action in
                //Rechaza la peticion de cambiar al menu y se queda donde estaba
                //self.navigationController?.popToViewController(self.list, animated: true)
                self.navigationController?.popToRootViewController(animated: true)
                
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

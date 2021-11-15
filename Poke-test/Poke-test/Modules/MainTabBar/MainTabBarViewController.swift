//
//  MainTabBarViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 10/11/21.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    var presenter: MainTabBarPresenterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        let list = PokemonListWireframe.createPokemonListModule()
        list.tabBarItem = UITabBarItem(title: "ALL", image: UIImage(named: "notSelected"), selectedImage: UIImage(named: "selected"))
        //error: #imageLiteral(resourceName:"favorites")
        let favourites = PokemonFavouritesWireframe.createPokemonFavouritesModule()
        favourites.tabBarItem = UITabBarItem(title: "FAVS", image: UIImage(named: "fullStar"), selectedImage: UIImage(named: "emptyStar"))
        navigationItem.title = "POKEDEX"
        setViewControllers([list, favourites], animated: true)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        
    }
}

extension MainTabBarViewController: MainTabBarViewDelegate{
    

}

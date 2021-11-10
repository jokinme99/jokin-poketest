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
        list.tabBarItem = UITabBarItem(title: "List", image: UIImage(named: "fullStar"), selectedImage: nil)
        //error: #imageLiteral(resourceName:"favorites")
        let favorites = PokemonListWireframe.createPokemonListModule()
        favorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(named: "emptyStar"), selectedImage: nil)
        
        setViewControllers([list, favorites], animated: true)
    }
}

extension MainTabBarViewController: MainTabBarViewDelegate {

}

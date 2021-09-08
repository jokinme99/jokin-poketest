//
//  PokemonListViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit

class PokemonListViewController: UIViewController {

    var presenter: PokemonListPresenterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}

extension PokemonListViewController: PokemonListViewDelegate {

}

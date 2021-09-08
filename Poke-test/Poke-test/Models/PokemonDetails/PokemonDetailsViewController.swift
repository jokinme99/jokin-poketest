//
//  PokemonDetailsViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 8/9/21.
//

import UIKit

class PokemonDetailsViewController: UIViewController {

    var presenter: PokemonDetailsPresenterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
}

extension PokemonDetailsViewController: PokemonDetailsViewDelegate {

}

//
//  PokemonCell.swift
//  Poke-test
//
//  Created by Jokin Egia on 28/7/21.
//
import UIKit
import AlamofireImage
import Zero

protocol PokemonCellDelegate: AnyObject {
    var presenter: PokemonListPresenterDelegate? {get set}
    func updatePokemonInCell(pokemonToFetch: Results)
}

class PokemonCell: UITableViewCell {
    @IBOutlet weak var pokemonBubble: UIView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    var pokemon: Results?
    var view: PokemonListViewDelegate?
    var presenter: PokemonListPresenterDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        loadStyle()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundColor = .white
        pokemonNameLabel.text = nil
        idLabel.text = nil
    }
}

extension PokemonCell {
    func loadStyle() {
        idLabel.apply(ZeroTheme.Label.body1Bold)
        pokemonNameLabel.apply(ZeroTheme.Label.body2)
    }
}

extension PokemonCell: PokemonCellDelegate {

    func updatePokemonInCell(pokemonToFetch: Results) {
        self.pokemon = pokemonToFetch
        if Reachability.isConnectedToNetwork() {
            guard let name = pokemonToFetch.name else { return }
            PokemonManager.shared.fetchPokemon(pokemonSelectedName: name, { pokemonData, error in
                if let error = error {
                    print(error)
                } else {
                    guard let pokemonData = pokemonData else {return}
                    self.setColor((pokemonData.types[0].type?.name ?? ""), self.pokemonNameLabel)
                    self.idLabel.text = "#\(pokemonData.id)"
                    self.setColor((pokemonData.types[0].type?.name ?? ""), self.idLabel)
                }
                self.view?.updateTableView()
            })
        } else {
            let pokemonDataList = DDBBManager.shared.get(PokemonData.self)
            for pokemonData in pokemonDataList where pokemonData.name == pokemonToFetch.name {
                self.setColor((pokemonData.types[0].type?.name ?? ""), self.pokemonNameLabel)
                self.idLabel.text = "#\(pokemonData.id)"
                self.setColor((pokemonData.types[0].type?.name ?? ""), self.idLabel)
            }
        }
        self.pokemonNameLabel.text = pokemonToFetch.name?.capitalized
    }
}

extension PokemonCell {
    func setPokemonBackgroundColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ label: UILabel) {
        label.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    func setPokemonTextColor(_ color: UIColor) {
        pokemonNameLabel.textColor = color
    }
    func setColor(_ type: String, _ label: UILabel) {
        switch type {
        case TypeName.normal.rawValue:
            setPokemonBackgroundColor(168, 168, 120, label)
            setPokemonTextColor(.white)
        case TypeName.fighting.rawValue:
            setPokemonBackgroundColor(192, 48, 40, label)
            setPokemonTextColor(.white)
        case TypeName.flying.rawValue:
            setPokemonBackgroundColor(168, 144, 240, label)
            setPokemonTextColor(.white)
        case TypeName.poison.rawValue:
            setPokemonBackgroundColor(160, 64, 160, label)
            setPokemonTextColor(.white)
        case TypeName.ground.rawValue:
            setPokemonBackgroundColor(224, 192, 104, label)
            setPokemonTextColor(.black)
        case TypeName.rock.rawValue:
            setPokemonBackgroundColor(184, 160, 56, label)
            setPokemonTextColor(.black)
        case TypeName.bug.rawValue:
            setPokemonBackgroundColor(168, 184, 32, label)
            setPokemonTextColor(.white)
        case TypeName.ghost.rawValue:
            setPokemonBackgroundColor(112, 88, 152, label)
            setPokemonTextColor(.white)
        case TypeName.steel.rawValue:
            setPokemonBackgroundColor(184, 184, 208, label)
            setPokemonTextColor(.black)
        case TypeName.fire.rawValue:
            setPokemonBackgroundColor(240, 128, 48, label)
            setPokemonTextColor(.black)
        case TypeName.water.rawValue:
            setPokemonBackgroundColor(104, 144, 240, label)
            setPokemonTextColor(.white)
        case TypeName.grass.rawValue:
            setPokemonBackgroundColor(120, 200, 80, label)
            setPokemonTextColor(.white)
        case TypeName.electric.rawValue:
            setPokemonBackgroundColor(248, 208, 48, label)
            setPokemonTextColor(.black)
        case TypeName.psychic.rawValue:
            setPokemonBackgroundColor(248, 88, 136, label)
            setPokemonTextColor(.white)
        case TypeName.ice.rawValue:
            setPokemonBackgroundColor(152, 216, 216, label)
            setPokemonTextColor(.black)
        case TypeName.dragon.rawValue:
            setPokemonBackgroundColor(112, 56, 248, label)
            setPokemonTextColor(.white)
        case TypeName.dark.rawValue:
            setPokemonBackgroundColor(112, 88, 72, label)
            setPokemonTextColor(.white)
        case TypeName.fairy.rawValue:
            setPokemonBackgroundColor(238, 153, 172, label)
            setPokemonTextColor(.black)
        case TypeName.unknown.rawValue:
            setPokemonBackgroundColor(0, 0, 0, label)
            setPokemonTextColor(.white)
        case TypeName.shadow.rawValue:
            setPokemonBackgroundColor(124, 110, 187, label)
            setPokemonTextColor(.white)
        default:
            pokemonNameLabel.backgroundColor = #colorLiteral(red: 0.8454863429, green: 0.8979230523, blue: 0.9188942909, alpha: 1)
            setPokemonTextColor(.black)
        }
    }
}

//
//  CollectionCell.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/12/21.
//

import UIKit
import Zero

//MARK: - CollectionCellDelegate protocol
protocol CollectionCellDelegate: AnyObject{
    var presenter: PokemonCollectionPresenterDelegate? {get set}
    func updatePokemonCollection(pokemonToUpdate: Results)
}


//MARK: - CollectionCell
class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Results?
    var viewDelegate: PokemonCollectionViewDelegate?
    var presenter: PokemonCollectionPresenterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.apply(ZeroTheme.Label.body2)
        layer.cornerRadius = 5
    }
    override func prepareForReuse() {
        backgroundColor = .white
        imageView.image = nil
        nameLabel.backgroundColor = .white
        nameLabel.text = nil
    }
}


//MARK: - CollectionCellDelegate methods
extension CollectionCell: CollectionCellDelegate{
    func updatePokemonCollection(pokemonToUpdate: Results) {
        self.pokemon = pokemonToUpdate
        if Reachability.isConnectedToNetwork(){
            guard let name = pokemonToUpdate.name else{return}
            PokemonManager.shared.fetchPokemon(pokemonSelectedName: name, {
                pokemonData, error in
                if let error = error {
                    print(error)
                }else{
                    guard let pokemonData = pokemonData else {return}
                    //self.idLabel.text = "Id: \(pokemonData.id)"
                    self.nameLabel.text = "\(pokemonData.name?.capitalized ?? "default name")"
                    self.transformUrlToImage(url: pokemonData.sprites?.front_default ?? "")
                    self.setBackgroundColor(pokemonData.types[0].type?.name ?? "default", self.nameLabel)
                    self.backgroundColor = self.nameLabel.backgroundColor
                }
                self.viewDelegate?.updateCollectionView()
            })
        }else{
            let pokemonDataList = DDBBManager.shared.get(PokemonData.self)
            for pokemonData in pokemonDataList{
                if pokemonData.name == pokemonToUpdate.name{
                    self.setBackgroundColor(pokemonData.types[0].type?.name ?? "default", self.nameLabel)
                    //self.idLabel.text = "Id: \(pokemonData.id)"
                    self.nameLabel.text = "\(pokemonData.name?.capitalized ?? "default name")"
                }
            }
        }
    }
    
    
    //MARK: - transformUrlToImage
    func transformUrlToImage(url: String){
        if let downloadURL = URL(string: url){
            if Reachability.isConnectedToNetwork(){
                return self.imageView.af.setImage(withURL: downloadURL)
            }else{
                return self.imageView.af.setImage(withURL: downloadURL) // get data from DB
                //return DDBBManager(Image.self) // [Image](with all images) -> get the one that references(with the url)
            }
            
        }else {
            return
        }
    }
    func setBackgroundColor(_ type: String, _ label: UILabel){
        switch type{
        case TypeName.normal:
            setColor(168, 168, 120, label)
            setTextColor(.white, label)
        case TypeName.fighting:
            setColor(192, 48, 40, label)
            setTextColor(.white, label)
        case TypeName.flying:
            setColor(168, 144, 240, label)
            setTextColor(.white, label)
        case TypeName.poison:
            setColor(160, 64, 160, label)
            setTextColor(.white, label)
        case TypeName.ground:
            setColor(224, 192, 104, label)
            setTextColor(.black, label)
        case TypeName.rock:
            setColor(184, 160, 56, label)
            setTextColor(.black, label)
        case TypeName.bug:
            setColor(168, 184, 32, label)
            setTextColor(.white, label)
        case TypeName.ghost:
            setColor(112, 88, 152, label)
            setTextColor(.white, label)
        case TypeName.steel:
            setColor(184, 184, 208, label)
            setTextColor(.black, label)
        case TypeName.fire:
            setColor(240, 128, 48, label)
            setTextColor(.black, label)
        case TypeName.water:
            setColor(104, 144, 240, label)
            setTextColor(.white, label)
        case TypeName.grass:
            setColor(120, 200, 80, label)
            setTextColor(.white, label)
        case TypeName.electric:
            setColor(248, 208, 48, label)
            setTextColor(.black, label)
        case TypeName.psychic:
            setColor(248, 88, 136, label)
            setTextColor(.white, label)
        case TypeName.ice:
            setColor(152, 216, 216, label)
            setTextColor(.black, label)
        case TypeName.dragon:
            setColor(112, 56, 248, label)
            setTextColor(.white, label)
        case TypeName.dark:
            setColor(112, 88, 72, label)
            setTextColor(.white, label)
        case TypeName.fairy:
            setColor(238, 153, 172, label)
            setTextColor(.black, label)
        case TypeName.unknown:
            setColor(0, 0, 0, label)
            setTextColor(.white, label)
        case TypeName.shadow:
            setColor(124, 110, 187, label)
            setTextColor(.white, label)
        default:
            setColor(0.8454863429, 0.8979230523, 0.9188942909, label)
            setTextColor(.black, label)
        }
    }
    func setColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ label: UILabel){
        label.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        
    }
    func setTextColor(_ color : UIColor, _ label: UILabel){
        label.textColor = color
    }
}

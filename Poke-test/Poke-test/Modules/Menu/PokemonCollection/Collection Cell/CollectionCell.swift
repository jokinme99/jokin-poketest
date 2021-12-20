//
//  CollectionCell.swift
//  Poke-test
//
//  Created by Jokin Egia on 17/12/21.
//

import UIKit


//MARK: - CollectionCellDelegate protocol
protocol CollectionCellDelegate: AnyObject{
    var presenter: PokemonCollectionPresenterDelegate? {get set}
    func updatePokemonCollection(pokemonToUpdate: Results)
}


//MARK: - CollectionCell
class CollectionCell: UICollectionViewCell {
    @IBOutlet weak var collectionCellBackgroundView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UIView!
    //@IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var pokemon: Results?
    var view: PokemonCollectionViewDelegate?
    var presenter: PokemonCollectionPresenterDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionCellBackgroundView.layer.borderWidth = 1
        // Initialization code
        nameLabel.adjustsFontSizeToFitWidth = true
    }
    override func prepareForReuse() {
        backgroundColor = .white
        collectionCellBackgroundView.backgroundColor = .white
        imageView.image = nil
        textView.backgroundColor = .white
        //idLabel.text = nil
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
                    self.setBackgroundColor(pokemonData.types[0].type?.name ?? "default", self.textView)
                }
                self.view?.updateCollectionView()
            })
        }else{
            let pokemonDataList = DDBBManager.shared.get(PokemonData.self)
            for pokemonData in pokemonDataList{
                if pokemonData.name == pokemonToUpdate.name{
                    self.setBackgroundColor(pokemonData.types[0].type?.name ?? "default", self.textView)
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
    func setBackgroundColor(_ type: String, _ view: UIView){
        switch type{
        case TypeName.normal:
            setColor(168, 168, 120, view)
        case TypeName.fight:
            setColor(192, 48, 40, view)
        case TypeName.flying:
            setColor(168, 144, 240, view)
        case TypeName.poison:
            setColor(160, 64, 160, view)
        case TypeName.ground:
            setColor(224, 192, 104, view)
        case TypeName.rock:
            setColor(184, 160, 56, view)
        case TypeName.bug:
            setColor(168, 184, 32, view)
        case TypeName.ghost:
            setColor(112, 88, 152, view)
        case TypeName.steel:
            setColor(184, 184, 208, view)
        case TypeName.fire:
            setColor(240, 128, 48, view)
        case TypeName.water:
            setColor(104, 144, 240, view)
        case TypeName.grass:
            setColor(120, 200, 80, view)
        case TypeName.electric:
            setColor(248, 208, 48, view)
        case TypeName.psychic:
            setColor(248, 88, 136, view)
        case TypeName.ice:
            setColor(152, 216, 216, view)
        case TypeName.dragon:
            setColor(112, 56, 248, view)
        case TypeName.dark:
            setColor(112, 88, 72, view)
        case TypeName.fairy:
            setColor(238, 153, 172, view)
        case TypeName.unknown:
            setColor(0, 0, 0, view)
        case TypeName.shadow:
            setColor(124, 110, 187, view)
        default:
            setColor(0.8454863429, 0.8979230523, 0.9188942909, view)
        }
    }
    func setColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ view: UIView){
        view.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
        
    }
}

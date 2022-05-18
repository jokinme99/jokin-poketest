//
//  PokemonDetailsViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 15/9/21.
//
import UIKit
import AlamofireImage
import RealmSwift
import Firebase
import FirebaseDatabase
import FirebaseAuth
import FirebaseCrashlytics
import Zero

class PokemonDetailsViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var typesView: UIView!
    @IBOutlet weak var pokemonType1Label: UILabel!
    @IBOutlet weak var pokemonType2Label: UILabel!
    @IBOutlet weak var nextOrPreviewView: UIView!
    @IBOutlet weak var previewButton: ZeroContainedButton!
    @IBOutlet weak var nextButton: ZeroContainedButton!
    @IBOutlet weak var pokemonDescriptionView: UIView!
    @IBOutlet weak var pokemonIdLabel: UILabel!
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonNameLabel: UILabel!
    @IBOutlet weak var statsView: UIView!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var heightAndWeightView: UIView!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var ability1Label: UILabel!
    @IBOutlet weak var ability2Label: UILabel!
    @IBOutlet weak var hpLabel: UILabel!
    @IBOutlet weak var attackLabel: UILabel!
    @IBOutlet weak var defenseLabel: UILabel!
    @IBOutlet weak var specialAttackLabel: UILabel!
    @IBOutlet weak var specialDefenseLabel: UILabel!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var favouritesButton: ZeroOutlineButton!
    @IBOutlet weak var favouritesImage: UIImageView!
    @IBOutlet weak var favouritesView: UIView!
    @IBOutlet weak var favouriteConfirmationImage: UIImageView!

    var presenter: PokemonDetailsPresenterDelegate?
    var listPresenter: PokemonListPresenterDelegate?
    var selectedPokemon : Results?
    var previousPokemon: Results?
    var nextPokemon: Results?
    var favouritesList: [Favourites] = []
    var cell: PokemonCellDelegate?
    var filtered: [Results] = []
    var row : Int?
    let user = Auth.auth().currentUser
    var arrayOfNames: [String] = []
    var alert = ZeroDialog()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchFavourites()
        loadSelectedPokemon()
        loadMethods()
        guard let selectedPokemon = selectedPokemon else {return}
        row = (filtered.firstIndex(of: selectedPokemon))
        crashlyticsErrorSending()
        loadImageAction()
    }
    
}

extension PokemonDetailsViewController{
    
    func loadSelectedPokemon(){
        if let pokemonToFetch = selectedPokemon{
            presenter?.fetchPokemon(pokemon: pokemonToFetch)
        }else{
            return
        }
    }

    func loadMethods(){
        self.loadStyle()
        self.favouritesButton.addTarget(self, action: #selector(addToFavouritesPressed), for: .touchUpInside)
        self.previewButton.addTarget(self, action: #selector(previousPokemonButtonAction), for: .touchUpInside)
        self.nextButton.addTarget(self, action: #selector(nextPokemonButtonAction), for: .touchUpInside)
        if filtered.count < 2{
            nextButton.isHidden = true
            previewButton.isHidden = true
        }
        self.nextButton.setTitle(self.nextPokemon?.name?.capitalized, for: .normal)
        self.previewButton.setTitle(self.previousPokemon?.name?.capitalized, for: .normal)
    }
    
    func loadImageAction(){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        pokemonImage.isUserInteractionEnabled = true
        pokemonImage.addGestureRecognizer(tapGestureRecognizer)
    }

    func loadStyle(){
        self.previewButton.layer.cornerRadius = 5
        self.previewButton.layer.borderWidth = 2
        self.previewButton.layer.borderColor = UIColor.black.cgColor
        self.nextButton.layer.cornerRadius = 5
        self.nextButton.layer.borderWidth = 2
        self.nextButton.layer.borderColor = UIColor.black.cgColor
        self.statsView.layer.cornerRadius = 5
        self.favouritesView.layer.cornerRadius = 5
        self.favouritesButton.layer.borderWidth = 0
        self.pokemonType1Label.apply(ZeroTheme.Label.head2)
        self.pokemonType2Label.apply(ZeroTheme.Label.head2)
        self.nextButton.apply(ZeroTheme.Button.normal)
        self.previewButton.apply(ZeroTheme.Button.normal)
        self.previewButton.setTitleColor(.black, for: .normal)
        self.nextButton.setTitleColor(.black, for: .normal)
        self.pokemonIdLabel.apply(ZeroTheme.Label.head4)
        self.pokemonNameLabel.apply(ZeroTheme.Label.head4Bold)
        self.statsLabel.apply(ZeroTheme.Label.body1)
        self.weightLabel.apply(ZeroTheme.Label.body2)
        self.heightLabel.apply(ZeroTheme.Label.body2)
        self.ability1Label.apply(ZeroTheme.Label.body2Bold)
        self.ability2Label.apply(ZeroTheme.Label.body2Bold)
        self.hpLabel.apply(ZeroTheme.Label.body2)
        self.attackLabel.apply(ZeroTheme.Label.body2)
        self.defenseLabel.apply(ZeroTheme.Label.body2)
        self.specialAttackLabel.apply(ZeroTheme.Label.body2)
        self.specialDefenseLabel.apply(ZeroTheme.Label.body2)
        self.speedLabel.apply(ZeroTheme.Label.body2)
        self.favouritesButton.apply(ZeroTheme.Button.outlined)
    }

    func crashlyticsErrorSending(){
        guard let email = user?.email else {return}
        Crashlytics.crashlytics().setUserID(email)
        Crashlytics.crashlytics().setCustomValue(email, forKey: CrashlyticsConstants.key)
        Crashlytics.crashlytics().log(CrashlyticsConstants.Details.log)
    }
}

extension PokemonDetailsViewController: PokemonDetailsViewDelegate {
 
    func addFavourite(pokemon: Results) {
        favouritesButton.setTitle(MenuConstants.deleteFavouriteButtonTitle, for: .normal)
        favouritesImage.image = .customTabBarImageSelected2
        favouriteConfirmationImage.isHidden = false
    }

    func deleteFavourite(pokemon: Results) {
        let filt = filtered.map{$0.name}
        let fav = favouritesList.map{$0.name}
        if filt == fav{
            favouritesButton.setTitle(MenuConstants.addFavouriteButtonTitle, for: .normal)
            favouritesImage.image = .customTabBarImage2
            favouriteConfirmationImage.isHidden = true
            let index = filtered.firstIndex(of: pokemon)
            guard let index = index else {return}
            filtered.remove(at: index)
            presenter?.fetchFavourites()
            if filtered.count == 1{
                self.previewButton.isHidden = true
                self.nextButton.isHidden = true
            }
        }else{
            arrayOfNames.removeDuplicates()
            if arrayOfNames.isEmpty == false{
                let indexName = arrayOfNames.firstIndex(of: pokemon.name ?? "")
                arrayOfNames.remove(at: indexName ?? 0)
            }
            favouritesButton.setTitle(MenuConstants.addFavouriteButtonTitle, for: .normal)
            favouritesImage.image = .customTabBarImage2
            favouriteConfirmationImage.isHidden = true
            presenter?.fetchFavourites()
            
        }
        
    }

    func getSelectedPokemon(with pokemon: Results) {
        selectedPokemon = pokemon
    }
    
    func updateDetailsViewFavourites(favourites: [Favourites]) {
        arrayOfNames.removeAll()
        for fav in favourites{
            guard let name = fav.name else {return}
            arrayOfNames.append(name.lowercased())
        }
        arrayOfNames.removeDuplicates()
        guard let name = selectedPokemon?.name else{return}
        if arrayOfNames.contains(name){
            favouritesButton.setTitle(MenuConstants.deleteFavouriteButtonTitle, for: .normal)
            favouritesImage.image = .customTabBarImageSelected2
          favouriteConfirmationImage.isHidden = false

        }else{
            favouritesButton.setTitle(MenuConstants.addFavouriteButtonTitle, for: .normal)
            favouritesImage.image = .customTabBarImage2
            favouriteConfirmationImage.isHidden = true
            
        }
    }

    func updateDetailsView(pokemon: PokemonData) {
        paintWindow(pokemon)
    }

    func paintWindow(_ pokemon: PokemonData){
        let type = pokemon.types[0]
        self.pokemonNameLabel.text = pokemon.name?.uppercased()
        self.pokemonType1Label.text = type.type?.name?.uppercased()
        self.pokemonIdLabel.text = "# \(pokemon.id)"
        self.heightLabel.text = "\(MenuConstants.heightTitle) : \(pokemon.height) m"
        self.weightLabel.text = "\(MenuConstants.weightTitle) : \(pokemon.weight) kg"
        guard let abilityName = pokemon.abilities[0].ability?.name else{return}
        self.statsLabel.text = MenuConstants.statsLabelTitle
        self.ability1Label.text = abilityName.capitalized.uppercased()
        self.hpLabel.text = "\(MenuConstants.hpTitle) :\(pokemon.stats[0].base_stat)"
        self.attackLabel.text = "\(MenuConstants.attackTitle) :\(pokemon.stats[1].base_stat)"
        self.defenseLabel.text = "\(MenuConstants.defenseTitle) :\(pokemon.stats[2].base_stat)"
        self.specialAttackLabel.text = "\(MenuConstants.specialAttackTitle) :\(pokemon.stats[3].base_stat)"
        self.specialDefenseLabel.text = "\(MenuConstants.specialDefenseTitle) :\(pokemon.stats[4].base_stat)"
        self.speedLabel.text = "\(MenuConstants.speedTitle) :\(pokemon.stats[5].base_stat)"
        self.paintLabel(pokemon: pokemon)
        self.transformUrlToImage(url: pokemon.sprites?.front_default ?? "")
    }

    func transformUrlToImage(url: String){
        if let downloadURL = URL(string: url){
            if Reachability.isConnectedToNetwork(){
                return self.pokemonImage.af.setImage(withURL: downloadURL)
            }else{
                //No way to save all the images
                return self.pokemonImage.af.setImage(withURL: downloadURL)
            }
        }
    }
}

extension PokemonDetailsViewController{

    @objc func addToFavouritesPressed(_ sender: ZeroOutlineButton!) {
        if user != nil{
            guard let selectedPokemon = selectedPokemon else{return}
            if favouritesButton.titleLabel?.text == MenuConstants.addFavouriteButtonTitle{
                    presenter?.addFavourite(pokemon: selectedPokemon)
            } else if favouritesButton.titleLabel?.text == MenuConstants.deleteFavouriteButtonTitle{
                    presenter?.deleteFavourite(pokemon: selectedPokemon)
            }
        }else{
            alert.show(
                title: MenuConstants.favsListBar,
                info: MenuConstants.notAbleToAddFavourites,
                titleOk: MenuConstants.yesTitle,
                titleCancel: MenuConstants.noTitle,
                completionOk: {
                    self.presenter?.openLoginSignUpWindow()
                },
                completionCancel: nil
            )
        }
        
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        guard let imageToSave = tappedImage.image else{return}
        if self.saveImage(image: imageToSave) == true{
            self.presenter?.openARKitView()
        }else{
            print("Error when saving image!")
        }
        
        
    }

    @objc func nextPokemonButtonAction(_ sender: ZeroContainedButton!){
        guard let nextPokemon = nextPokemon else{return}
        presenter?.fetchPokemon(pokemon: nextPokemon)
        if row == filtered.count - 1{
            row = 0
        }else{
            row = row! + 1
        }
        nextOrPrevious()
    }
    
    @objc func previousPokemonButtonAction(_ sender: ZeroContainedButton!){
        guard let previousPokemon = previousPokemon else{return}
        presenter?.fetchPokemon(pokemon: previousPokemon)
        if row == 0{
            row = filtered.count - 1
        }else{
            row = row!  - 1
        }
        nextOrPrevious()
        
    }
    
    func nextOrPrevious(){
        guard let row = row else{return}
        if filtered.count < 3{
            if row == 0{
                self.selectedPokemon = filtered[row]
                self.previousPokemon = filtered.last
                self.nextPokemon = previousPokemon
            }else{
                self.selectedPokemon = filtered[row]
                self.nextPokemon = filtered.first
                self.previousPokemon = nextPokemon
            }
        }else if filtered.count == 1{
            
            self.previewButton.isHidden = true
            self.nextButton.isHidden = true
        }else{
            if row == 0{
                self.selectedPokemon = filtered[row]
                self.nextPokemon = filtered[row + 1]
                self.previousPokemon = filtered.last
            }else if row == filtered.count - 1{
                self.selectedPokemon = filtered[row]
                self.previousPokemon = filtered[row - 1]
                self.nextPokemon = filtered.first
            }else{
                self.nextPokemon = filtered[row  + 1]
                self.selectedPokemon = filtered[row]
                self.previousPokemon = filtered[row - 1]
            }
        }
        self.nextButton.setTitle(self.nextPokemon?.name?.capitalized, for: .normal)
        self.previewButton.setTitle(self.previousPokemon?.name?.capitalized, for: .normal)
        presenter?.fetchFavourites()
    }
}

extension PokemonDetailsViewController{
    func setName(type: String, to label : UILabel){
        switch type {
        case TypeName.normal.rawValue:
            label.text = TypeName.normal.localized
        case TypeName.fighting.rawValue:
            label.text = TypeName.fighting.localized
        case TypeName.flying.rawValue:
            label.text = TypeName.flying.localized
        case TypeName.poison.rawValue:
            label.text = TypeName.poison.localized
        case TypeName.ground.rawValue:
            label.text = TypeName.ground.localized
        case TypeName.rock.rawValue:
            label.text = TypeName.rock.localized
        case TypeName.bug.rawValue:
            label.text = TypeName.bug.localized
        case TypeName.ghost.rawValue:
            label.text = TypeName.ghost.localized
        case TypeName.steel.rawValue:
            label.text = TypeName.steel.localized
        case TypeName.fire.rawValue:
            label.text = TypeName.fire.localized
        case TypeName.water.rawValue:
            label.text = TypeName.water.localized
        case TypeName.grass.rawValue:
            label.text = TypeName.grass.localized
        case TypeName.electric.rawValue:
            label.text = TypeName.electric.localized
        case TypeName.psychic.rawValue:
            label.text = TypeName.psychic.localized
        case TypeName.ice.rawValue:
            label.text = TypeName.ice.localized
        case TypeName.dragon.rawValue:
            label.text = TypeName.dragon.localized
        case TypeName.dark.rawValue:
            label.text = TypeName.dark.localized
        case TypeName.fairy.rawValue:
            label.text = TypeName.fairy.localized
        case TypeName.unknown.rawValue:
            label.text = TypeName.unknown.localized
        case TypeName.shadow.rawValue:
            label.text = TypeName.shadow.localized
        default:
            print("DEFAULT ERROR")
        }
    }
    func paintLabel(pokemon: PokemonData){
        if pokemon.types.count >= 2{
            self.pokemonType2Label.isHidden = false
            self.pokemonDescriptionView.backgroundColor = .customButtonBackgroundColor
            guard let typeName_1 = pokemon.types[1].type?.name else{return}
            guard let typeName_0 = pokemon.types[0].type?.name else{return}
            self.pokemonType2Label.text = typeName_1
            self.paintType(label: self.pokemonType1Label)
            self.paintType(label: self.pokemonType2Label)
            self.setName(type: typeName_1, to: pokemonType2Label)
            self.setName(type: typeName_0, to: pokemonType1Label)
            
            //MARK: - Views' background
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.typesView)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.backgroundView)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.nextOrPreviewView)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.statsView)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.heightAndWeightView)
            
            
            
            //MARK: - Label's background
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.pokemonIdLabel)
            self.setBackgroundColor(from: self.pokemonDescriptionView, to: self.pokemonNameLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.heightLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.weightLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.statsLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.hpLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.attackLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.defenseLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.specialAttackLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.specialDefenseLabel)
            self.setBackgroundColor(from: self.pokemonType2Label, to: self.speedLabel)
            self.pokemonIdLabel.textColor = .black
            self.pokemonNameLabel.textColor = .black
            self.heightLabel.textColor = pokemonType2Label.textColor
            self.weightLabel.textColor = pokemonType2Label.textColor
            self.statsLabel.textColor = pokemonType2Label.textColor
            self.hpLabel.textColor = pokemonType2Label.textColor
            self.attackLabel.textColor = pokemonType2Label.textColor
            self.defenseLabel.textColor = pokemonType2Label.textColor
            self.specialAttackLabel.textColor = pokemonType2Label.textColor
            self.specialDefenseLabel.textColor = pokemonType2Label.textColor
            self.heightLabel.textColor = pokemonType2Label.textColor
            self.speedLabel.textColor = pokemonType2Label.textColor
            self.paintIfAbility(pokemon: pokemon)
            self.addBorder(statsLabel)
            
            
            //MARK: - Buttons' background
            self.setBackgroundColor(from: pokemonType1Label, to: favouritesView)
            self.setBackgroundColor(from: pokemonType1Label, to: favouritesButton)
            self.favouritesButton.setTitleColor(pokemonType1Label.textColor, for: .normal)
            self.nextButton.backgroundColor = pokemonDescriptionView.backgroundColor
            self.previewButton.backgroundColor = pokemonDescriptionView.backgroundColor

            
        } else{
            self.paintType(label: self.pokemonType1Label)
            guard let typeName = pokemon.types[0].type?.name else{return}
            self.setName(type: typeName, to: pokemonType1Label)
            self.pokemonType2Label.isHidden = true
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.pokemonDescriptionView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.typesView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.backgroundView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.nextOrPreviewView)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.nextButton)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.previewButton)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.pokemonIdLabel)
            self.setBackgroundColor(from: self.pokemonType1Label, to: self.pokemonNameLabel)
            
            self.statsView.backgroundColor = .customButtonBackgroundColor
            self.setBackgroundColor(from: self.statsView, to: self.hpLabel)
            self.hpLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.attackLabel)
            self.attackLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.defenseLabel)
            self.defenseLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.specialAttackLabel)
            self.specialAttackLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.specialDefenseLabel)
            self.specialDefenseLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.speedLabel)
            self.speedLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.statsLabel)
            self.statsLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.weightLabel)
            self.weightLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.heightLabel)
            self.heightLabel.textColor = .black
            self.setBackgroundColor(from: self.statsView, to: self.heightAndWeightView)
            self.paintIfAbility(pokemon: pokemon)
            self.addBorder(statsLabel)
            
            
            //MARK: - Buttons' background
            self.setBackgroundColor(from: statsView, to: favouritesView)
            self.setBackgroundColor(from: statsView, to: favouritesButton)
            self.favouritesButton.setTitleColor(hpLabel.textColor, for: .normal)
            self.nextButton.backgroundColor = pokemonDescriptionView.backgroundColor
            self.previewButton.backgroundColor = pokemonDescriptionView.backgroundColor
            
            
        }
    }
    func addBorder(_ label: UILabel){
        label.layer.borderColor = label.textColor.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = 5
    }
    func paintIfAbility(pokemon: PokemonData){
        if pokemon.types.count >= 2{
            if pokemon.abilities.count >= 2{
                guard let abilityName = pokemon.abilities[1].ability?.name else{return}
                self.setBackgroundColor(from: self.pokemonType2Label, to: self.ability1Label)
                self.setBackgroundColor(from: self.pokemonType2Label, to: self.ability2Label)
                self.ability1Label.textColor = pokemonType2Label.textColor
                self.ability2Label.textColor = pokemonType2Label.textColor
                self.ability2Label.text = abilityName.uppercased()
            }else{
                self.ability2Label.isHidden = true
            }
        }else{
            if pokemon.abilities.count >= 2{
                guard let abilityName = pokemon.abilities[1].ability?.name else{return}
                self.setBackgroundColor(from: self.statsView, to: self.ability1Label)
                self.setBackgroundColor(from: self.statsView, to: self.ability2Label)
                self.ability1Label.textColor = .black
                self.ability2Label.textColor = .black
                self.ability2Label.text = abilityName.uppercased()
            }else{
                self.ability2Label.isHidden = true
            }
        }

    }
    func paintType(label: UILabel){
        switch label.text?.lowercased() {
        case TypeName.normal.rawValue:
            setPokemonBackgroundColor(168, 168, 120, label)
            favouriteConfirmationImage.image = .customTabBarImage2
            setPokemonTextColor(.black, label)
        case TypeName.fighting.rawValue:
            setPokemonBackgroundColor(192, 48, 40, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.flying.rawValue:
            setPokemonBackgroundColor(168, 144, 240, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.poison.rawValue:
            setPokemonBackgroundColor(160, 64, 160, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.ground.rawValue:
            setPokemonBackgroundColor(224, 192, 104, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.rock.rawValue:
            setPokemonBackgroundColor(184, 160, 56, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.bug.rawValue:
            setPokemonBackgroundColor(168, 184, 32, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.ghost.rawValue:
            setPokemonBackgroundColor(112, 88, 152, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.steel.rawValue:
            setPokemonBackgroundColor(184, 184, 208, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.fire.rawValue:
            setPokemonBackgroundColor(240, 128, 48, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.water.rawValue:
            setPokemonBackgroundColor(104, 144, 240, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.grass.rawValue:
            setPokemonBackgroundColor(120, 200, 80, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.electric.rawValue:
            setPokemonBackgroundColor(248, 208, 48, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.psychic.rawValue:
            setPokemonBackgroundColor(248, 88, 136, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.ice.rawValue:
            setPokemonBackgroundColor(152, 216, 216, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = UIImage.customTabBarImage2
        case TypeName.dragon.rawValue:
            setPokemonBackgroundColor(112, 56, 248, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.dark.rawValue:
            setPokemonBackgroundColor(112, 88, 72, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.fairy.rawValue:
            setPokemonBackgroundColor(238, 153, 172, label)
            setPokemonTextColor(.black, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.unknown.rawValue:
            setPokemonBackgroundColor(0, 0, 0, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        case TypeName.shadow.rawValue:
            setPokemonBackgroundColor(124, 110, 187, label)
            setPokemonTextColor(.white, label)
            favouriteConfirmationImage.image = .customTabBarImage2
        default:
            setPokemonBackgroundColor(216, 229, 234, label)
            setPokemonTextColor(.black, label)
        }
    }
    func setPokemonBackgroundColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ label: UILabel){
        label.backgroundColor = .init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    func setPokemonTextColor(_ color: UIColor, _ label: UILabel){
        label.textColor = color
    }
    func setBackgroundColor(from: UIView, to: UIView){
        to.backgroundColor = from.backgroundColor
    }
    
}



//MARK: - Image saving method
extension PokemonDetailsViewController{
    //MARK: - saveImage
    func saveImage(image: UIImage) -> Bool {
        guard let data = image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

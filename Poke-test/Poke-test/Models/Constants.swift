//
//  Constants.swift
//  Poke-test
//
//  Created by Jokin Egia on 30/7/21.
//
import Foundation

enum TypeName: String{
    case all = "all"
    case normal = "normal"
    case fighting = "fighting"
    case flying = "flying"
    case poison = "poison"
    case ground = "ground"
    case rock = "rock"
    case bug = "bug"
    case ghost = "ghost"
    case steel = "steel"
    case fire = "fire"
    case water = "water"
    case grass = "grass"
    case electric = "electric"
    case psychic = "psychic"
    case ice = "ice"
    case dragon = "dragon"
    case dark = "dark"
    case fairy = "fairy"
    case unknown = "unknown"
    case shadow = "shadow"
    var localized:String{
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

struct FirebaseErrors{
    static let errorEmailAlreadyInUse = 17007
    static let errorCodeInvalidEmail = 17008
    static let errorCodeWrongPassword = 17009
    static let errorCodeUserNotFound = 17011
    static let errorCodeWeakPassword = 17026
}

struct HomeConstants{
    static let loginButtonTitle = NSLocalizedString("login", comment: "")
    static let signUpButtonTitle = NSLocalizedString("sign_up", comment: "")
    static let noUserButtonTitle = NSLocalizedString("access_no_user", comment: "")
    static let welcomeTitle = NSLocalizedString("welcome", comment: "")
    static let navigationItemTitle = NSLocalizedString("app_title", comment: "")
    static let backButtonTitle = NSLocalizedString("back", comment: "")
    static let noInternetTitle = NSLocalizedString("no_internet", comment: "")
    static let noInternetLogin = NSLocalizedString("no_internet_login", comment: "")
    static let noInternetSignUp = NSLocalizedString("no_internet_sign_up", comment: "")
    static let noInternetOKButtonTitle = NSLocalizedString("open_settings", comment: "")
    static let noInternetCancelButtonTitle = NSLocalizedString("later", comment: "")
    static let enterButtonTitle = NSLocalizedString("enter", comment: "")
    static let emailTitle = NSLocalizedString("email", comment: "")
    static let passwordTitle = NSLocalizedString("password", comment: "")
    static let emailAndPasswordError = NSLocalizedString("email_and_password_error", comment: "")
    static let emailAndPasswordEmptyError = NSLocalizedString("email_and_password_empty_error", comment: "")
    static let emailError = NSLocalizedString("email_error", comment: "")
    static let emailEmptyError = NSLocalizedString("email_empty_error", comment: "")
    static let passwordError = NSLocalizedString("password_error", comment: "")
    static let passwordEmptyError = NSLocalizedString("password_empty_error", comment: "")
    static let invalidEmailError = NSLocalizedString("invalid_email_error", comment: "")
    static let alreadyUsedEmailError = NSLocalizedString("already_in_use_email_error", comment: "")
    static let userNotFoundError = NSLocalizedString("user_not_found_error", comment: "")
    static let wrongPasswordError = NSLocalizedString("wrong_password_error", comment: "")
    static let okTitle = NSLocalizedString("ok", comment: "")
    static let weakPasswordError = NSLocalizedString("weak_password_error", comment: "")
}

struct MenuConstants{
    static let titleLogIn = NSLocalizedString("log_in", comment: "")
    static let titleLogOut = NSLocalizedString("log_out", comment: "")
    static let listTabBar = NSLocalizedString("list", comment: "")
    static let favsListBar = NSLocalizedString("favs", comment: "")
    static let collectionTabBar = NSLocalizedString("collection", comment: "")
    static let navigationItemTitle = NSLocalizedString("app_title", comment: "")
    static let loggingOutTitle = NSLocalizedString("logging_out_title", comment: "")
    static let loggingOutMessage = NSLocalizedString("logging_out_message", comment: "")
    static let yesTitle = NSLocalizedString("yes", comment: "")
    static let noTitle = NSLocalizedString("no", comment: "")
    static let customCell1Name = "PokemonNameCell"
    static let orderByNameButtonTitle = NSLocalizedString("order_by_name", comment: "")
    static let searchBarPlaceholder = NSLocalizedString("search_for_pokemons", comment: "")
    static let alreadyInFavourites = NSLocalizedString("already_in_favourites", comment: "")
    static let okTitle = NSLocalizedString("ok", comment: "")
    static let addButtonTitle = NSLocalizedString("add", comment: "")
    static let addedToFavourites = NSLocalizedString("added_to_favourites", comment: "")
    static let notAbleToAddFavourites = NSLocalizedString("not_able_to_add", comment: "")
    static let orderByIdButtonTitle = NSLocalizedString("order_by_id", comment: "")
    static let noFavouritesAdded = NSLocalizedString("no_favourites_added", comment: "")
    static let homeTitle = NSLocalizedString("home", comment: "")
    static let deletedFromFavourites = NSLocalizedString("deleted_from_favourites", comment: "")
    static let deleteFavouriteButtonTitle = NSLocalizedString("delete_from_favourites", comment: "")
    static let addFavouriteButtonTitle = NSLocalizedString("add_to_favourites", comment: "")
    static let heightTitle = NSLocalizedString("height", comment: "")
    static let weightTitle = NSLocalizedString("weight", comment: "")
    static let hpTitle = NSLocalizedString("hp", comment: "")
    static let attackTitle = NSLocalizedString("attack", comment: "")
    static let defenseTitle = NSLocalizedString("defense", comment: "")
    static let specialAttackTitle = NSLocalizedString("special_attack", comment: "")
    static let specialDefenseTitle = NSLocalizedString("special_defense", comment: "")
    static let speedTitle = NSLocalizedString("speed", comment: "")
    static let customCell2Name = "CollectionCell"
    static let saveDataTitle = NSLocalizedString("save_data_title", comment: "")
    static let saveDataInfo = NSLocalizedString("save_data_info", comment: "")
}





struct CrashlyticsConstants{
    static let key = "USER"
    struct LoginOrSignUp {
        static let message = "Not logged"
        static let log = "Error in MainTabBarViewController"
    }
    struct Login{
        static let log = "Error in LoginViewController"
    }
    struct SignUp{
        static let log = "Error in SignUpViewController"
    }
    struct TabBar{
        static let log = "Error in MainTabBarViewController"
    }
    struct List{
        static let log = "Error in PokemonListViewController"
    }
    struct Favourites{
        static let log = "Error in PokemonFavouritesViewController"
    }
    struct Details{
        static let log = "Error in PokemonDetailsViewController"
    }
    struct Collection{
        static let log = "Error in PokemonCollectionView"
    }
}





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




//MARK: - FirebaseErrors's constants
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


struct CrashlyticsConstants{
    static let key = "USER"
    struct LoginOrSignUpWindow {
        static let message = "Not logged"
        static let log = "Error in MainTabBarViewController"
    }
    struct LoginWindow{
        static let log = "Error in LoginViewController"
    }
    struct SignUpWIndow{
        static let log = "Error in SignUpViewController"
    }
}




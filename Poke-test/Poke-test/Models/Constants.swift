import Foundation
//MARK: - Types' constants
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

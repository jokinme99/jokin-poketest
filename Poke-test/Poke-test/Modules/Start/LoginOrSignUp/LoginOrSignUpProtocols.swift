
import UIKit


//MARK: - LoginOrSignUpViewDelegate
protocol LoginOrSignUpViewDelegate: AnyObject {
    var presenter: LoginOrSignUpPresenterDelegate? {get set}
}


//MARK: - LoginOrSignUpWireframeDelegate
protocol LoginOrSignUpWireframeDelegate: AnyObject {
    static func createLoginOrSignUpModule() -> UIViewController
    func openLoginWindow()
    func openSignUpWindow()
    func openPokemonListWindow()
}


//MARK: - LoginOrSignUpPresenterDelegate
protocol LoginOrSignUpPresenterDelegate: AnyObject {
    var view: LoginOrSignUpViewDelegate? {get set}
    var interactor: LoginOrSignUpInteractorDelegate? {get set}
    var wireframe: LoginOrSignUpWireframeDelegate? {get set}
    func openLoginWindow()
    func openSignUpWindow()
    func openPokemonListWindow()
}


//MARK: - LoginOrSignUpInteractorDelegate
protocol LoginOrSignUpInteractorDelegate: AnyObject {
    var presenter: LoginOrSignUpInteractorOutputDelegate? {get set}
}


//MARK: - LoginOrSignUpInteractorOutputDelegate
protocol LoginOrSignUpInteractorOutputDelegate: AnyObject {

}

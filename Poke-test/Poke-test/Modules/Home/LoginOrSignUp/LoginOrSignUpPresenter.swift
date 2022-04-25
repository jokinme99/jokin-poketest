
class LoginOrSignUpPresenter{
    
    var view: LoginOrSignUpViewDelegate?
    var interactor: LoginOrSignUpInteractorDelegate?
    var wireframe: LoginOrSignUpWireframeDelegate?
    
}

extension LoginOrSignUpPresenter: LoginOrSignUpPresenterDelegate{

    func openLoginWindow() {
        wireframe?.openLoginWindow()
    }
    
    func openSignUpWindow() {
        wireframe?.openSignUpWindow()
    }

    func openPokemonListWindow() {
        wireframe?.openPokemonListWindow()
    }
}

extension LoginOrSignUpPresenter: LoginOrSignUpInteractorOutputDelegate {

}

//MARK: - LoginOrSignUpPresenter
class LoginOrSignUpPresenter{
    var view: LoginOrSignUpViewDelegate?
    var interactor: LoginOrSignUpInteractorDelegate?
    var wireframe: LoginOrSignUpWireframeDelegate?
}


//MARK: - LoginOrSignUpPresenterDelegate methods
extension LoginOrSignUpPresenter: LoginOrSignUpPresenterDelegate{
    
    
    //MARK: - openLoginWindow
    func openLoginWindow() {
        wireframe?.openLoginWindow()
    }
    
    
    //MARK: - openSignUpWindow
    func openSignUpWindow() {
        wireframe?.openSignUpWindow()
    }
    
    
    //MARK: - openPokemonListWindow
    func openPokemonListWindow() {
        wireframe?.openPokemonListWindow()
    }
}


//MARK: - LoginOrSignUpInteractorOutputDelegate methods
extension LoginOrSignUpPresenter: LoginOrSignUpInteractorOutputDelegate {

}


class LoginPresenter{
    
    var view: LoginViewDelegate?
    var interactor: LoginInteractorDelegate?
    var wireframe: LoginWireframeDelegate?
    
}

extension LoginPresenter: LoginPresenterDelegate{
    func openMainTabBar() {
        wireframe?.openMainTabBar()
    }
}

extension LoginPresenter: LoginInteractorOutputDelegate {

}

//MARK: - LoginPresenter
class LoginPresenter{
    var view: LoginViewDelegate?
    var interactor: LoginInteractorDelegate?
    var wireframe: LoginWireframeDelegate?
}


//MARK: - LoginPresenterDelegate methods
extension LoginPresenter: LoginPresenterDelegate{
    
    
    //MARK: - openMainTabBar
    func openMainTabBar() {
        wireframe?.openMainTabBar()
    }
}


//MARK: - LoginInteractorOutputDelegate
extension LoginPresenter: LoginInteractorOutputDelegate {

}

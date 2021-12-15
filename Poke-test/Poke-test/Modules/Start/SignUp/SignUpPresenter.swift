//MARK: - SignUpPresenter
class SignUpPresenter{
    var view: SignUpViewDelegate?
    var interactor: SignUpInteractorDelegate?
    var wireframe: SignUpWireframeDelegate?
}


//MARK: - SignUpPresenterDelegate
extension SignUpPresenter: SignUpPresenterDelegate{
    
    
    //MARK: - openMainTabBar
    func openMainTabBar(){
        wireframe?.openMainTabBar()
    }
}


//MARK: - SignUpPresenter
extension SignUpPresenter: SignUpInteractorOutputDelegate {

}

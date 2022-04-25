
class SignUpPresenter{
    
    var view: SignUpViewDelegate?
    var interactor: SignUpInteractorDelegate?
    var wireframe: SignUpWireframeDelegate?
    
}

extension SignUpPresenter: SignUpPresenterDelegate{

    func openMainTabBar(){
        wireframe?.openMainTabBar()
    }
}

extension SignUpPresenter: SignUpInteractorOutputDelegate {
    
}

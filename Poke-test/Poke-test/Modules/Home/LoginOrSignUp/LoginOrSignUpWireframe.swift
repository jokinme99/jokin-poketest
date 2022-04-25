import UIKit

class LoginOrSignUpWireframe{
    
    var viewController: UIViewController?
    
}

extension LoginOrSignUpWireframe: LoginOrSignUpWireframeDelegate{
    
    static func createLoginOrSignUpModule() -> UIViewController {
        let presenter = LoginOrSignUpPresenter()
        let view = LoginOrSignUpViewController()
        let wireframe = LoginOrSignUpWireframe()
        let interactor = LoginOrSignUpInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
        
    }
    func openLoginWindow() {
        let loginModule = LoginWireframe.createLoginModule()
        viewController?.navigationController?.pushViewController(loginModule, animated: true)
    }
    
    func openSignUpWindow() {
        let signUpModule = SignUpWireframe.createSignUpModule()
        viewController?.navigationController?.pushViewController(signUpModule, animated: true)
    }
    
    func openPokemonListWindow() {
        let listModule = MainTabBarWireframe.createMainTabBarModule()
        viewController?.navigationController?.setViewControllers([listModule], animated: true)
        
    }
}


import UIKit

class SignUpWireframe{
    
    var viewController: UIViewController?
    
}

extension SignUpWireframe: SignUpWireframeDelegate{
    
    static func createSignUpModule() -> UIViewController {
        let presenter = SignUpPresenter()
        let view = SignUpViewController()
        let wireframe = SignUpWireframe()
        let interactor = SignUpInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
    
    func openMainTabBar() {
        let listModule = MainTabBarWireframe.createMainTabBarModule()
        let navigation = UINavigationController(rootViewController: listModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}

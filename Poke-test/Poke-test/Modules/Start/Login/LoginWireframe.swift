import UIKit


//MARK: - LoginWireframe
class LoginWireframe{

    var viewController: UIViewController?
}


//MARK: - LoginWireframeDelegate
extension LoginWireframe: LoginWireframeDelegate{
    
    
    //MARK: - createLoginModule
    static func createLoginModule() -> UIViewController {
        let presenter = LoginPresenter()
        let view = LoginViewController()
        let wireframe = LoginWireframe()
        let interactor = LoginInteractor()

        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
    
    
    //MARK: - Section heading
    func openMainTabBar() {
        let listModule = MainTabBarWireframe.createMainTabBarModule()
        let navigation = UINavigationController(rootViewController: listModule)
        let window = (UIApplication.shared.delegate as? AppDelegate)?.window
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
    }
}

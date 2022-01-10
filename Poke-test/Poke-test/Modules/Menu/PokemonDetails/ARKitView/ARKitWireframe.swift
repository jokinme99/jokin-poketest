import UIKit


//MARK: - ARKitWireframe
class ARKitWireframe{
    var viewController: UIViewController?
}


//MARK: - ARKitWireframeDelegate methods
extension ARKitWireframe: ARKitWireframeDelegate{
    
    
    //MARK: - createARKitModule
    static func createARKitModule() -> UIViewController {
        let presenter = ARKitPresenter()
        let view = ARKitViewController()
        let wireframe = ARKitWireframe()
        let interactor = ARKitInteractor()
        view.presenter = presenter
        presenter.view = view
        presenter.wireframe = wireframe
        presenter.interactor = interactor
        interactor.presenter = presenter

        wireframe.viewController = view

        return view
    }
}

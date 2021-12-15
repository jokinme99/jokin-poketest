
import UIKit


//MARK: - LoginViewDelegate
protocol LoginViewDelegate: AnyObject {
    var presenter: LoginPresenterDelegate? {get set}
}


//MARK: - LoginWireframeDelegate
protocol LoginWireframeDelegate: AnyObject {
    static func createLoginModule() -> UIViewController
    func openMainTabBar()
}


//MARK: - LoginPresenterDelegate
protocol LoginPresenterDelegate: AnyObject {
    var view: LoginViewDelegate? {get set}
    var interactor: LoginInteractorDelegate? {get set}
    var wireframe: LoginWireframeDelegate? {get set}
    func openMainTabBar()
}


//MARK: - LoginInteractorDelegate
protocol LoginInteractorDelegate: AnyObject {
    var presenter: LoginInteractorOutputDelegate? {get set}
}


//MARK: - LoginInteractorOutputDelegate
protocol LoginInteractorOutputDelegate: AnyObject {

}

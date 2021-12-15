import UIKit


//MARK: - SignUpViewDelegate
protocol SignUpViewDelegate: AnyObject {
    var presenter: SignUpPresenterDelegate? {get set}
}


//MARK: - SignUpWireframeDelegate
protocol SignUpWireframeDelegate: AnyObject {
    static func createSignUpModule() -> UIViewController
    func openMainTabBar()
}


//MARK: - SignUpPresenterDelegate
protocol SignUpPresenterDelegate: AnyObject {
    var view: SignUpViewDelegate? {get set}
    var interactor: SignUpInteractorDelegate? {get set}
    var wireframe: SignUpWireframeDelegate? {get set}
    func openMainTabBar()
}


//MARK: - SignUpInteractorDelegate
protocol SignUpInteractorDelegate: AnyObject {
    var presenter: SignUpInteractorOutputDelegate? {get set}
}


//MARK: - SignUpInteractorOutputDelegate
protocol SignUpInteractorOutputDelegate: AnyObject {

}

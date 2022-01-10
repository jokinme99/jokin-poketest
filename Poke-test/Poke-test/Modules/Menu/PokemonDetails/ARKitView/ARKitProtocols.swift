import UIKit


//MARK: - ARKitViewDelegate
protocol ARKitViewDelegate: AnyObject {
    var presenter: ARKitPresenterDelegate? {get set}
}


//MARK: - ARKitWireframeDelegate
protocol ARKitWireframeDelegate: AnyObject {
    static func createARKitModule() -> UIViewController
}


//MARK: - ARKitPresenterDelegate
protocol ARKitPresenterDelegate: AnyObject {
    var view: ARKitViewDelegate? {get set}
    var interactor: ARKitInteractorDelegate? {get set}
    var wireframe: ARKitWireframeDelegate? {get set}
}


//MARK: - ARKitInteractorDelegate
protocol ARKitInteractorDelegate: AnyObject {
    var presenter: ARKitInteractorOutputDelegate? {get set}
}


//MARK: - ARKitInteractorOutputDelegate
protocol ARKitInteractorOutputDelegate: AnyObject {

}



//MARK: - ARKitPresenter
class ARKitPresenter : ARKitPresenterDelegate {
    var view: ARKitViewDelegate?
    var interactor: ARKitInteractorDelegate?
    var wireframe: ARKitWireframeDelegate?
}


//MARK: - ARKitInteractorOutputDelegateMethods
extension ARKitPresenter: ARKitInteractorOutputDelegate {

}

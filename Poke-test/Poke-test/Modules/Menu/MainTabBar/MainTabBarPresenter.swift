
//MARK: - MainTabBarPresenter
class MainTabBarPresenter : MainTabBarPresenterDelegate {
    var view: MainTabBarViewDelegate?
    var interactor: MainTabBarInteractorDelegate?
    var wireframe: MainTabBarWireframeDelegate?
    func openLoginSignUpWindow() {
        wireframe?.openLoginSignUpWindow()
    }
}


//MARK: - MainTabBarInteractorOutuputDelegate methods
extension MainTabBarPresenter: MainTabBarInteractorOutputDelegate {

}

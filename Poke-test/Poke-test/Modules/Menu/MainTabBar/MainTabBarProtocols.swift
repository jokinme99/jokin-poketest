
import UIKit

//MARK: - MainTabBarViewDelegate methods
protocol MainTabBarViewDelegate: AnyObject {
    var presenter: MainTabBarPresenterDelegate? {get set}
}


//MARK: - MainTabBarWireframeDelegate methods
protocol MainTabBarWireframeDelegate: AnyObject {
    static func createMainTabBarModule() -> UIViewController
    func openLoginSignUpWindow()
}


//MARK: - MainTabBarPresenterDelegate methods
protocol MainTabBarPresenterDelegate: AnyObject {
    var view: MainTabBarViewDelegate? {get set}
    var interactor: MainTabBarInteractorDelegate? {get set}
    var wireframe: MainTabBarWireframeDelegate? {get set}
    func openLoginSignUpWindow()
}


//MARK: - MainTabBarInteractorDelegate methods
protocol MainTabBarInteractorDelegate: AnyObject {
    var presenter: MainTabBarInteractorOutputDelegate? {get set}
}


//MARK: - MainTabBarInteractorOutputDelegate methods
protocol MainTabBarInteractorOutputDelegate: AnyObject {

}

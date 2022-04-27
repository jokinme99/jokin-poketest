//
//  ARKitWireframe.swift
//  Poke-test
//
//  Created by Jokin Egia on 4/1/22.
//
import UIKit

protocol ARKitWireframeDelegate: AnyObject {
    static func createARKitModule() -> UIViewController
}
class ARKitWireframe{
    
    var viewController: UIViewController?
    
}

extension ARKitWireframe: ARKitWireframeDelegate{

    static func createARKitModule() -> UIViewController {
        let view = ARKitViewController()
        let wireframe = ARKitWireframe()
        wireframe.viewController = view
        return view
    }
}

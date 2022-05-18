//
//  ARKitViewController.swift
//  Poke-test
//
//  Created by Jokin Egia on 4/1/22.
//
import UIKit
import ARKit

class ARKitViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    var imagePok: UIImage?
    var anchors: [ARAnchor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setSceneView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let currentFrame = sceneView.session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = -0.3
            let transform = simd_mul(currentFrame.camera.transform, translation)
            let anchor = ARAnchor(transform: transform)
            if anchors.count >= 1{
                guard let anchorToRemove = anchors.first else{return}
                sceneView.session.remove(anchor: anchorToRemove)
                anchors.removeAll()
                sceneView.session.add(anchor: anchor)
                anchors.append(anchor)
            }else{
                sceneView.session.add(anchor: anchor)
                anchors.append(anchor)
            }
        }
    }
    
}

extension ARKitViewController{

    func setSceneView(){
        sceneView.delegate = self
        imagePok = getSavedImage(named: "fileName")
        sceneView.session.run(configuration)
    }

    func getSavedImage(named: String) -> UIImage? {
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
            }else{
                return nil
            }
    }
}

extension ARKitViewController: ARSCNViewDelegate{
    
    func make2dNode(image: UIImage, width: CGFloat = 0.1, height: CGFloat = 0.1) -> SCNNode {
           let plane = SCNPlane(width: width, height: height)
           plane.firstMaterial!.diffuse.contents = image
           let node = SCNNode(geometry: plane)
           node.constraints = [SCNBillboardConstraint()]
           return node
       }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let imagePok = imagePok else {return}
        node.addChildNode(make2dNode(image: imagePok))
    }
}

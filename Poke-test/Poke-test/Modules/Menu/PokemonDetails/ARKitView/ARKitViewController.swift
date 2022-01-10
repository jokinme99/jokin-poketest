import UIKit
import ARKit


//MARK: - ARKitViewController
class ARKitViewController: UIViewController {
    @IBOutlet weak var sceneView: ARSCNView!
    var presenter: ARKitPresenterDelegate?
    let augmentedRealitySession = ARSession()
    let configuration = ARWorldTrackingConfiguration()
    
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setSceneView()
       
    }
    
    
    //MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    //MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
}


//MARK: - viewDidLoad methods
extension ARKitViewController{
    
    
    //MARK: - setSceneView
    func setSceneView(){
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        sceneView.session = augmentedRealitySession
        configuration.planeDetection = .vertical
        augmentedRealitySession.run(configuration, options: [.resetTracking, .removeExistingAnchors])

    }
    
    
    //MARK: - getSavedImage
    func getSavedImage(named: String) -> UIImage? {
            if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
                return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
            }else{
                return nil
            }
    }
    
}


//MARK: - ARSCNViewDelegate methods
extension ARKitViewController: ARSCNViewDelegate, ARKitViewDelegate{
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) { }
}


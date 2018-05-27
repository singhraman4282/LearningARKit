//
//  FloorIsLava.swift
//  WorldTracking
//
//  Created by Raman Singh on 2018-05-26.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import ARKit

class FloorIsLava: UIViewController, ARSCNViewDelegate {
    let configuration = ARWorldTrackingConfiguration()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    setupSceneView()
    }//lood

    

    
    func setupSceneView() {
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.delegate = self
        
//        self.sceneView.scene.rootNode.addChildNode(lavaNode)
    }//setupSceneView
    
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planceAnchor = anchor as? ARPlaneAnchor else { return }
        print("new flat surface detected")
        
        let lavaNode = createLave(planeAnchor: planceAnchor)
        node.addChildNode(lavaNode)
        
    }//didAdd
    
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planceAnchor = anchor as? ARPlaneAnchor else { return }
        print("updating floor anchor")
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
        let lavaNode = createLave(planeAnchor: planceAnchor)
        node.addChildNode(lavaNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        print("removed anchor")
        node.enumerateChildNodes { (childNode, _) in
            childNode.removeFromParentNode()
        }
    }
    
    func createLave(planeAnchor:ARPlaneAnchor) ->SCNNode {
    
        let lavaNode = SCNNode(geometry: SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z)))
        lavaNode.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "sunDiffuse")
        lavaNode.position = SCNVector3(planeAnchor.center.x,planeAnchor.center.y,planeAnchor.center.z)
        lavaNode.geometry?.firstMaterial?.isDoubleSided = true
        lavaNode.eulerAngles = SCNVector3(90.degreesToRadians, 0,0)
        
        return lavaNode
    }//createLave
    
    
}//end

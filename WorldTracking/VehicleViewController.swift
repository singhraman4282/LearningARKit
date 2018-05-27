//
//  VehicleViewController.swift
//  WorldTracking
//
//  Created by Raman Singh on 2018-05-27.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import ARKit

class VehicleViewController: UIViewController, ARSCNViewDelegate {
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
        let body = SCNPhysicsBody.static()
        lavaNode.physicsBody = body 
        
        return lavaNode
    }//createLave
    
    
    @IBAction func addCarClicked(_ sender: Any) {
        guard let pointOfView = self.sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        
        let scene = SCNScene(named: "Car-Scene.scn")
        let carNode = (scene?.rootNode.childNode(withName: "car", recursively: false))!
        
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: carNode, options: [SCNPhysicsShape.Option.keepAsCompound: true]))
        carNode.physicsBody = body
        
        carNode.position = currentPositionOfCamera
        self.sceneView.scene.rootNode.addChildNode(carNode)
    
    }//addCarClicked
    
    
    
    
    
    
    
    
    
    
    
    
    
}//end

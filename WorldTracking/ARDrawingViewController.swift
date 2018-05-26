//
//  ARDrawingViewController.swift
//  WorldTracking
//
//  Created by Raman Singh on 2018-05-26.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import ARKit

class ARDrawingViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var draw: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupSceneView()
       
    }//load


    func setupSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.session.run(configuration)
        self.sceneView.showsStatistics = true
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.delegate = self
    }//setupSceneView
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = self.sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        
        let currentPositionOfCamera = orientation + location
        
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.02))
                pointer.name = "pointer"
                pointer.position = currentPositionOfCamera
                
                self.sceneView.scene.rootNode.enumerateChildNodes({ (node, _) in
                    if node.name == "pointer" {
                    node.removeFromParentNode()
                    }
                })
                
                self.sceneView.scene.rootNode.addChildNode(pointer)
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
        }//mainQueue
        
        
        
    }//renderer
    
    
}//end

func +(left:SCNVector3, right:SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

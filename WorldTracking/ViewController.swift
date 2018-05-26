//
//  ViewController.swift
//  WorldTracking
//
//  Created by Raman Singh on 2018-05-26.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        
        self.sceneView.autoenablesDefaultLighting = true
        
        
    }//load
    
    
    @IBAction func addButtonClicked(_ sender: UIButton) {
        
        let node = boxNode()
        self.sceneView.scene.rootNode.addChildNode(node)
        
    }//addButtonClicked
    
    
    @IBAction func resetButtonClicked(_ sender: UIButton) {
        restartSession()
    }//resetButtonClicked
    
    func restartSession() {
        self.sceneView.session.pause()
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }//block
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum:CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }//randomNumbers
    
    func planeNode() -> SCNNode{
        let node = SCNNode()
        node.geometry = SCNPlane(width: 0.2, height: 0.2)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        node.position = SCNVector3(0,0,-0.5)
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0, y:0))
//        path.addLine(to: CGPoint(x: 0, y: 0.2))
//        path.addLine(to: CGPoint(x: 0.2, y: 0.3))
//        path.addLine(to: CGPoint(x: 0.4, y: 0.2))
//        path.addLine(to: CGPoint(x: 0.4, y: 0))
//        let shape = SCNShape(path: path, extrusionDepth: 0.2)
//        node.geometry = shape
//
        
        return node
    }//planeNode

    func boxNode() ->SCNNode {
        let node = SCNNode()
        node.geometry = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.03)
        node.geometry?.firstMaterial?.specular.contents = UIColor.white
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
        let x = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        let y = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        let z = randomNumbers(firstNum: -0.3, secondNum: 0.3)
        node.position = SCNVector3(x,y,z)
        return node
    }//boxNode
    
    
}//end

extension Int {
    
    var degreesToRadians: Double { return Double(self) * .pi/180}
}



//
//  ProjectilesViewController.swift
//  WorldTracking
//
//  Created by Raman Singh on 2018-05-27.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import ARKit
import Each

class ProjectilesViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var planeDetected: UILabel!
    
    var basketAdded:Bool = false
    
    var power:Float = 1.0
    let timer = Each(0.05).seconds
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        planeDetected.isHidden = true
        self.sceneView.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        
    }//load
    
    @objc func handleTap(sender:UITapGestureRecognizer) {
        guard let sceneView = sender.view as? ARSCNView else { return }
        let touchLocation = sender.location(in: sceneView)
        let hitTestResult = sceneView.hitTest(touchLocation, types: [.existingPlaneUsingExtent])
        if !hitTestResult.isEmpty {
            addBasket(hitTestResult: hitTestResult.first!)
        }
    }//handleTap
    
    func addBasket(hitTestResult:ARHitTestResult) {
        if basketAdded == false {
        let basketScene = SCNScene(named: "Basketball.scnassets/BasketballScene.scn")
        let basketNode = (basketScene?.rootNode.childNode(withName: "Basket", recursively: false))!
        let positionOfPlane = hitTestResult.worldTransform.columns.3
        basketNode.position = SCNVector3(positionOfPlane.x,positionOfPlane.y,positionOfPlane.z)
        basketNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(node: basketNode, options: [SCNPhysicsShape.Option.keepAsCompound:true, SCNPhysicsShape.Option.type:SCNPhysicsShape.ShapeType.concavePolyhedron]))
        self.sceneView.scene.rootNode.addChildNode(basketNode)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.basketAdded = true
        }//dispatch
            
        }//if no basket added yet
        
    }//addBasket
    
    
    
    func setupScene() {
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        sceneView.autoenablesDefaultLighting = true
    }//setupScene
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        DispatchQueue.main.async {
            self.planeDetected.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.planeDetected.isHidden = true
        }
        
    }//didAdd
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.basketAdded == true {
            self.timer.perform(closure: {() -> NextStep in
                self.power = self.power + 1
                return .continue
            })
        }//if there's a basket
    }//touchesBegan
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.basketAdded == true {
            self.timer.stop()
            self.shootBall()
            self.power = 1
            
        }//if there's a basket
    }//touchesEnded
    
    
    func shootBall() {
        removeEveryOtherBall()
        guard let pointOfView = self.sceneView.pointOfView else { return }
        let transform = pointOfView.transform
        let orientation = SCNVector3(-transform.m31,-transform.m32, -transform.m33)
        let location = SCNVector3(transform.m41, transform.m42, transform.m43)
        let currentPositionOfCamera = orientation + location
        
        let myBall = SCNNode(geometry: SCNSphere(radius: 0.25))
        myBall.position = currentPositionOfCamera
        myBall.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "ball")
        let body = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: myBall))
        body.restitution = 0.2
        myBall.physicsBody = body
        myBall.name = "Basketball"
        myBall.physicsBody?.applyForce(SCNVector3(orientation.x*self.power,orientation.y*self.power,orientation.z*self.power), asImpulse: true)
        self.sceneView.scene.rootNode.addChildNode(myBall)
    }//shootBall
    
    func removeEveryOtherBall() {
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "Basketball" {
            node.removeFromParentNode()
            }
        }//enumerateChildNodes
    }//removeEveryOtherBall
    
    
    
    
    
    
    
    
    
    
    
    
    deinit {
        self.timer.stop()
    }

    
}//end

//
//  JellyFishViewController.swift
//  WorldTracking
//
//  Created by Raman Singh on 2018-05-26.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import ARKit
import UIKit
import Each
class JellyFishViewController: UIViewController {
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var playOutlet: UIButton!
    var timer = Each(1).seconds
    var countdown = 40
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()

    setupSceneView()
    }//load

    
    @IBAction func playButtonClicked(_ sender: Any) {
        addNode()
        self.setTimer()
        playOutlet.isHidden = true
    }//playButtonClicked
    
    
    
    @IBAction func resetButtonClicked(_ sender: Any) {
//        playOutlet.isHidden = false
        self.timer.stop()
        resetTimer()
        
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
            node.removeFromParentNode()
        }
        self.sceneView.session.pause()
        self.sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
    }//resetButtonClicked
    

    func setupSceneView() {
        
        sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.session.run(configuration)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
        
        
    }//setupSceneView
    
    func addNode() {
        let jellyFishScene = SCNScene(named: "art.scnassets/Android.scn")
        let jellyFishNode = jellyFishScene?.rootNode.childNode(withName: "Body", recursively: true)
        let x = randomNumbers(firstNum: -1, secondNum: 0.3)
        let y = randomNumbers(firstNum: -3, secondNum: 3)
        let z = randomNumbers(firstNum: -3, secondNum: 3)
        
        
        jellyFishNode?.position = SCNVector3(x,y,z)
        jellyFishNode?.scale = SCNVector3(0.1, 0.1, 0.1)
        self.sceneView.scene.rootNode.addChildNode(jellyFishNode!)
        
        
        let action = SCNAction.rotateBy(x: CGFloat(360.degreesToRadians), y: CGFloat(360.degreesToRadians), z: CGFloat(360.degreesToRadians), duration: 8)
        let forever = SCNAction.repeatForever(action)
        jellyFishNode?.runAction(forever)
        print("node added")

    }//addNode
    
    @objc func handleTap(sender:UITapGestureRecognizer) {
        
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        
        if hitTest.isEmpty {
            print("Didn't touch anything")
        } else {
            
            print("touched an android")
            let results = hitTest.first!
            let node = results.node
            self.animateNode(node: node)
            
            if node.animationKeys.isEmpty {
            SCNTransaction.begin()
                self.playOutlet.isHidden = false
            SCNTransaction.completionBlock = {
            node.removeFromParentNode()
                
                self.addNode()
                self.resetTimer()
            }
            SCNTransaction.commit()
            }//ifAnimationKeyEmpty
            
               
            
        }//else
        
        
    }//handleTap
    
    func animateNode(node:SCNNode) {
        let spin = CABasicAnimation(keyPath: "position")
        spin.fromValue = node.presentation.position
        spin.toValue = SCNVector3(0, 0, node.presentation.position.z - 2)
        spin.duration = 0.3
        spin.autoreverses = true
        node.addAnimation(spin, forKey: "position")
        
        
    }
    
    func randomNumbers(firstNum: CGFloat, secondNum:CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }//randomNumbers
    
    func setTimer() {
        self.timer.perform(closure: {() -> NextStep in
            self.countdown -= 1
            self.timerLabel.text = "\(self.countdown)"
            if self.countdown == 0 {
            self.timerLabel.text = "You loose Nigga"
                self.resetTimer()
                self.playOutlet.isHidden = false
                return .stop
                
            }
            return .continue
        })
    }//setTimer
    
    func resetTimer() {
        self.countdown = 40
        self.timerLabel.text = "\(self.countdown)"
        
//        playOutlet.isHidden = false
    }//resetTimer
}//end

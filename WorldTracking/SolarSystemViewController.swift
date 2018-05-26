//
//  SolarSystemViewController.swift
//  WorldTracking
//
//  Created by Raman Singh on 2018-05-26.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import ARKit

class SolarSystemViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSceneView()
        self.sceneView.autoenablesDefaultLighting = true
        
        let sun = createSun()
        self.sceneView.scene.rootNode.addChildNode(sun)
        
        let earthParent = SCNNode()
        let venusParent = SCNNode()
        
        earthParent.position = SCNVector3(0,0,-1)
        venusParent.position = SCNVector3(0,0,-1)
        
        self.sceneView.scene.rootNode.addChildNode(earthParent)
        self.sceneView.scene.rootNode.addChildNode(venusParent)
        
        let earth = createPlanet(geometry: SCNSphere(radius: 0.2), diffuse: #imageLiteral(resourceName: "earthDay"), specular: #imageLiteral(resourceName: "earthSpecular"), emission: #imageLiteral(resourceName: "earthClouds"), normal: #imageLiteral(resourceName: "earthNormal"), position: SCNVector3(1.2,0,0))
        let venus = createPlanet(geometry: SCNSphere(radius: 0.1), diffuse: #imageLiteral(resourceName: "venusSurface"), specular: nil, emission: nil, normal: #imageLiteral(resourceName: "venusAtmosphere"), position: SCNVector3(0.7,0,0))
        earthParent.addChildNode(earth)
        venusParent.addChildNode(venus)
        
        
        let eathParentRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 14)
        let venusParentRotation = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 10)
        let foreverEathParentRotation = SCNAction.repeatForever(eathParentRotation)
        let foreverVenusParentRotation = SCNAction.repeatForever(venusParentRotation)
        
        earthParent.runAction(foreverEathParentRotation)
        venusParent.runAction(foreverVenusParentRotation)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        sun.runAction(forever)
        
        
        
        
    }//load
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        
        
        
        
        
        
    }
    
    
    
    
    
    
    func setupSceneView() {
        
        let configuration = ARWorldTrackingConfiguration()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        
    }//setupSceneView
    
    func createEarth() -> SCNNode {
        let earth = SCNNode()
        earth.geometry = SCNSphere(radius: 0.2)
        earth.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "earthDay")
        earth.geometry?.firstMaterial?.emission.contents = #imageLiteral(resourceName: "earthClouds")
        earth.geometry?.firstMaterial?.normal.contents = #imageLiteral(resourceName: "earthNormal")
        
        //        earth.geometry?.firstMaterial?.specular.contents = #imageLiteral(resourceName: "earthSpecular")
        earth.position = SCNVector3(1.2, 0, 0)
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
       // earth.runAction(forever)
        
        
        
        return earth
        
    }//createEarth
    
    func createSun() ->SCNNode {
        let sun = SCNNode()
        sun.geometry = SCNSphere(radius: 0.35)
        sun.geometry?.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "sunDiffuse")
        sun.position = SCNVector3(0,0,-1)
        return sun
    }//createSun
    
    func createPlanet(geometry:SCNGeometry, diffuse:UIImage, specular:UIImage?, emission:UIImage?, normal:UIImage, position:SCNVector3) -> SCNNode {
        
        let planet = SCNNode()
        planet.geometry = geometry
        planet.geometry?.firstMaterial?.diffuse.contents = diffuse
        planet.geometry?.firstMaterial?.emission.contents = emission
        planet.geometry?.firstMaterial?.normal.contents = normal
        
        planet.geometry?.firstMaterial?.specular.contents = specular
        planet.position = position
        
        let action = SCNAction.rotateBy(x: 0, y: CGFloat(360.degreesToRadians), z: 0, duration: 8)
        let forever = SCNAction.repeatForever(action)
        // earth.runAction(forever)
        
        return planet
        
    }//createPlanet
    
    
    
}//end

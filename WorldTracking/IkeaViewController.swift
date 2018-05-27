//
//  IkeaViewController.swift
//  WorldTracking
//
//  Created by Raman Singh on 2018-05-27.
//  Copyright © 2018 Raman Singh. All rights reserved.
//

import UIKit
import ARKit

class IkeaViewController: UIViewController {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet var collectionView: UICollectionView!
    
    let configuration = ARWorldTrackingConfiguration()
    
    let itemsArray = ["cup", "vase", "boxing", "table"]
    var selectedItem:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
       registerGestureRecognizer()
    }//load

    func setupScene() {
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        self.configuration.planeDetection = .horizontal
        sceneView.session.run(configuration)
        
    }//setupScene
    
    func registerGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }//registerGestureRecognizer
    
    @objc func tapped(sender:UITapGestureRecognizer) {
        
        
        let sceneView = sender.view as! ARSCNView
        let tapLocation = sender.location(in: sceneView)
        let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
        if !hitTest.isEmpty {
            print("touched horizontal surface")
            addItem(hitTestResult: hitTest.first!)
        } else {
            print("no match")
        }
        
        
    }//tapped
    
    func addItem(hitTestResult:ARHitTestResult) {
        
        if let selectedItem = self.selectedItem {
        let scene = SCNScene(named: "Models.scnassets/\(selectedItem).scn")
            let node = (scene?.rootNode.childNode(withName: selectedItem, recursively: false))!
            let transform = hitTestResult.worldTransform
            let thirdColum = transform.columns.3
            node.position = SCNVector3(thirdColum.x, thirdColum.y, thirdColum.z)
            self.sceneView.scene.rootNode.addChildNode(node)
        }
    }//addItem
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}//end


extension IkeaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ItemCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ItemCell
        cell.itemLabel.text = itemsArray[indexPath.row]
        cell.backgroundColor = UIColor.orange
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.green
        selectedItem = itemsArray[indexPath.row]
        print(selectedItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.orange
    }
}//extension

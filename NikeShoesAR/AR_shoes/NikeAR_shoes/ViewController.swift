//
//  ViewController.swift
//  Uwai
//
//  Created by Lucas Lazarre on 7/27/21.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // MARK: The ARSession delegate has to be assigned in the .viewdidAppear
        arView.session.delegate = self
        
        setupARview()
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:))))
    }
    
    // MARK: AR View setup function, line 19
    
    func setupARview() {
        // This gets rid of the standard stuff.
        arView.automaticallyConfigureSession = false
        // This sets config equal to that, which tracks everything in the camera
        let configuration = ARWorldTrackingConfiguration()
        // All of the horizontal and vertical values are stored in config.planeDetection
        // Is this a struct? I'm not sure, but it's written like one in C.
        configuration.planeDetection = [.horizontal, .vertical]
        // This adds a layer of realness to the AR experience automatically.
        configuration.environmentTexturing = .automatic
        // This runs the ARview
        arView.session.run(configuration)
    }
    
    // MARK: Object placement, line 21
    // When someone taps the screen, this function is called.
    @objc
    func handleTap(recognizer: UITapGestureRecognizer) {
        // This gets the location in ARview.
        let location = recognizer.location(in: arView )
        // The results are equal to the location of the raycast, or that point in space that the user points to with their finger.
        let results = arView.raycast(from: location, allowing: .estimatedPlane , alignment: .horizontal)
        
        // MARK: Did it hit a surface?
        if let firstResult = results.first {
            // In order to add objects in AR, we need to anchor them.
            // This line reads:
            // The anchor is equal to the 3D asset and its position in space.
            let anchor = ARAnchor(name: "mysteryBlock", transform: firstResult.worldTransform)
            arView.session.add(anchor: anchor)
        } else {
            print("Placement failure: Make sure your environment is visible.");
        }
    }
    // MARK: This is the function for the extension.
    func placeObject(named entityName: String, for anchor: ARAnchor) {
        // Create anchor entity using .loadmodel
        let entity = try! ModelEntity.loadModel(named: entityName)
        
        // MARK: This allows for the user to drag the object around and rotate it.
        entity.generateCollisionShapes(recursive: true)
        arView.installGestures([.rotation, .translation], for: entity)
        
        
         // Now, let's add our "mysteryblock to anchor entity. All of the things that exist in the AR space are entities."
        // Once this is done, we add it to our arView.scene
        
        let anchorEntity = AnchorEntity(anchor: anchor)
        anchorEntity.addChild(entity)
        arView.scene.addAnchor(anchorEntity)
    }
}

// MARK: This extensions places the anchor in the session.
extension ViewController: ARSessionDelegate {
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        for anchor in anchors {
            if let anchorName = anchor.name, anchorName == "mysteryBlock" {
                placeObject(named: anchorName, for: anchor)
            }
        }
    }
}

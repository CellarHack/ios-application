//
//  CHCameraViewController.swift
//  CellarHack
//
//  Created by stant on 02/07/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

protocol CHCameraViewControllerDelegate {
    
    func cameraViewControllerEnded()
    
}

class CHCameraViewController: UIViewController {
    
    var delegate:CHCameraViewControllerDelegate?
    
    override func loadView() {
        let view = CCCameraView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.delegate?.cameraViewControllerEnded()
    }
    
}

extension CHCameraViewController: CCCameraViewDelegate {
    
    func imageCaptured(image: UIImage) {
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), { () -> () in
            self.navigationController.popViewControllerAnimated(true)
            return
        })
    }
    
    func cancelled() {
        let delay = 1 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue(), { () -> () in
            self.navigationController.popViewControllerAnimated(true)
            return
        })
    }
    
}

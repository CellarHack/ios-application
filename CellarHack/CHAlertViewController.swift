//
//  CHAlertViewController.swift
//  CellarHack
//
//  Created by stant on 27/06/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

/*******************************
*
* View delegate protocol
*/

protocol CHAlertViewDelegate {
    
}

/*******************************
*
* View implementation
*/

class CHAlertView: UIView {
    
    let alertList: UITableView = UITableView()
    
    var delegate: CHAlertViewDelegate?
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.blackColor()
        
        self.setupAlertList()
        self.setupConstraints()
    }
    
}

// setup methods
extension CHAlertView {
    
    func setupAlertList() {
        alertList.setTranslatesAutoresizingMaskIntoConstraints(false)
        alertList.separatorColor = UIColor.whiteColor()
        alertList.backgroundColor = UIColor.clearColor()
        alertList.rowHeight = 150
        self.addSubview(alertList)
    }
    
    func setupConstraints() {
        
        let views = ["alertList": alertList]
        
        let horizontalAlertListConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[alertList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalAlertListConstraints)
        
        let verticalAlertListConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[alertList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(verticalAlertListConstraints)

    }
    
}

/*******************************
*
* ViewController implementation
*/

class CHAlertViewController: UIViewController {
    
    override func loadView() {
        let view = CHAlertView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET("http://192.168.11.40:8000/api/event/", parameters: nil, success: {(request: AFHTTPRequestOperation!, result: AnyObject!) -> Void in
            NSLog("\(result)")
        }, failure: {(request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
        })
    
    }
    
}

//CHAlertViewDelegate methods
extension CHAlertViewController: CHAlertViewDelegate {
    
}
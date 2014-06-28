//
//  CHSleepViewController.swift
//  CellarHack
//
//  Created by stant on 11/06/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

/*******************************
*
* View delegate protocol
*/

@class_protocol protocol CHSleepViewDelegate {
    
    func viewPressed()
    
}

/*******************************
*
* View implementation
*/

class CHSleepView : UIView {
    
    weak var delegate: CHSleepViewDelegate?
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.blackColor()
        
        self.setupLabel()
        self.setupGesture()
    }
    
}

// setup methods
extension CHSleepView {
    
    func setupLabel() {
        let label = UILabel()
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.textColor = UIColor.whiteColor()
        label.font = UIFont(name: "HelveticaNeue-UltraLightItalic", size: 40)
        label.text = NSLocalizedString("LOREM_IPSUM", bundle: NSBundle.mainBundle(), value: "", comment: "")
        label.numberOfLines = 100
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.addSubview(label)
        
        let horizontalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraint)
        
        let verticalConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraint(verticalConstraint)
        
        let widthConstraint = NSLayoutConstraint(item: label, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -100)
        self.addConstraint(widthConstraint)
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: "tapGesture:")
        self.addGestureRecognizer(tapGesture)
    }
    
}

// target methods
extension CHSleepView {
    
    func tapGesture(tapGesture: UITapGestureRecognizer) {
        
        self.delegate?.viewPressed()
        
    }
    
}

/*******************************
*
* ViewController implementation
*/

class CHSleepViewController: UIViewController {
    
    override func loadView() {
        let view = CHSleepView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// CHSleepViewDelegate
extension CHSleepViewController: CHSleepViewDelegate {
    
    func viewPressed() {
        NSLog("pouet");
    }
    
}

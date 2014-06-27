//
//  CHAddWineViewController.swift
//  CellarHack
//
//  Created by stant on 16/06/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

/*******************************
*
* View delegate protocol
*/

protocol CHAddWineViewDelegate {
    
    func searchCameraPressed()
    
}

/*******************************
*
* View implementation
*/

class CHAddWineView : UIView {
    
    let searchField = UITextField()
    let searchCamera = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    let searchList = UITableView()
    var delegate: CHAddWineViewDelegate?
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.blackColor()
        
        self.setupSearchField()
        self.setupSearchList()
        
        self.setupConstraints()
    }
    
}

// setup methods
extension CHAddWineView {
    
    func setupSearchField() {
        searchField.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchField.layer.borderColor = UIColor.whiteColor().CGColor
        searchField.layer.borderWidth = 1
        searchField.textColor = UIColor.whiteColor()
        searchField.font = UIFont(name: "HelveticaNeue-Light", size: 40)
        searchField.layer.cornerRadius = 10
        self.addSubview(searchField)
        
        let cameraIcon = UIImage(named: "icon_camera.png")
        NSLog("\(cameraIcon.size)")
        searchCamera.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchCamera.addTarget(self, action: "searchCameraPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        searchCamera.backgroundColor = UIColor.clearColor()
        searchCamera.setImage(cameraIcon, forState: UIControlState.Normal)
        self.addSubview(searchCamera)
    }
    
    func setupSearchList() {
        searchList.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchList.separatorColor = UIColor.whiteColor()
        searchList.backgroundColor = UIColor.clearColor()
        searchList.rowHeight = 150
        self.addSubview(searchList)
    }
    
    func setupConstraints() {
        let views = ["searchField" : searchField, "searchCamera" : searchCamera, "searchList" : searchList]
        
        // Search items horizontal constraints
        let horizontalSearchFieldConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[searchField]-[searchCamera(==75)]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalSearchFieldConstraints)
        
        let horizontalSearchListConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[searchList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalSearchListConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[searchField(==75)]-[searchList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(verticalConstraints)
        
        let heightSearchCameraConstraint = NSLayoutConstraint(item: searchCamera, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: searchField, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        self.addConstraint(heightSearchCameraConstraint)
        
        let verticalSearchCameraConstraint = NSLayoutConstraint(item: searchCamera, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: searchField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraint(verticalSearchCameraConstraint)
    }
}

// target methods
extension CHAddWineView {

    func searchCameraPressed(sender:UIButton) {
        self.delegate?.searchCameraPressed()
    }
    
}

/*******************************
*
* ViewController implementation
*/

class CHAddWineViewController: UIViewController {
    
    override func loadView() {
        let view = CHAddWineView()
        view.delegate = self
        view.searchList.delegate = self
        view.searchList.dataSource = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// CHAddWineViewDelegate
extension CHAddWineViewController: CHAddWineViewDelegate {
    
    func searchCameraPressed() {
        
    }
    
}

// UITableViewDelegate
extension CHAddWineViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
}

extension CHAddWineViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let view = self.view as CHAddWineView
        let cell = view.searchList.dequeueReusableCellWithIdentifier("") as UITableViewCell
        return cell
    }
    
}

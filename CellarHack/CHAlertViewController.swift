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
* View utils
*/

class CHAlertViewTableViewCell: UITableViewCell {
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!)  {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        self.detailTextLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.imageView.frame
        frame.size = CGSize(width: 100, height: self.bounds.size.height)
        self.imageView.frame = frame
        
        var textFrame = self.textLabel.frame
        textFrame.origin.x = frame.size.width + 20
        self.textLabel.frame = textFrame
        
        var detailFrame = self.detailTextLabel.frame
        detailFrame.origin.x = textFrame.origin.x + 20
        self.detailTextLabel.frame = detailFrame
    }
    
}

/*******************************
*
* View delegate protocol
*/

@objc protocol CHAlertViewDelegate {
    
}

/*******************************
*
* View implementation
*/

class CHAlertView: UIView {
    
    let alertList: UITableView = UITableView()
    
    weak var delegate: CHAlertViewDelegate!
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor(hexString: "#ecf0f1", alpha: 1)
        
        self.setupAlertList()
        self.setupConstraints()
    }
    
}

// setup methods
extension CHAlertView {
    
    func setupAlertList() {
        alertList.registerClass(CHAlertViewTableViewCell.self, forCellReuseIdentifier: "cell")
        alertList.setTranslatesAutoresizingMaskIntoConstraints(false)
        alertList.separatorColor = UIColor.whiteColor()
        alertList.backgroundColor = UIColor.clearColor()
        alertList.separatorColor = UIColor.blackColor()
        alertList.rowHeight = 150
        self.addSubview(alertList)
    }
    
    func setupConstraints() {
        
        let views = ["alertList": alertList]
        
        let horizontalAlertListConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[alertList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalAlertListConstraints)
        
        let verticalAlertListConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==64)-[alertList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(verticalAlertListConstraints)

    }
    
}

/*******************************
*
* ViewController implementation
*/

class CHAlertViewController: UIViewController {
    
    var eventList:Array<Dictionary<String, AnyObject>>? = nil
    
    override func loadView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let view = CHAlertView()
        view.delegate = self
        view.alertList.delegate = self
        view.alertList.dataSource = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError?
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET("\(CHServerUrl)/event/", parameters: nil, success: {(request: AFHTTPRequestOperation!, result: AnyObject!) in
            if let resultArray = result as? Array<Dictionary<String, AnyObject>> {
                self.eventList = resultArray
                (self.view as CHAlertView).alertList.reloadData()
            }
        }, failure: {(request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            NSLog("Error: \(request.request.URL)")
        })
    
    }
    
}

//CHAlertViewDelegate methods
extension CHAlertViewController: CHAlertViewDelegate {
    
}

//UITableView delegate/dataSource methods
extension CHAlertViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if let count = self.eventList?.count {
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = (self.view as CHAlertView).alertList.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        let messages: Dictionary<String, Array<String>> = ["DOOR_EVENT_OPEN": ["Porte ouverte", "door.png", "#2ecc71"], "DOOR_EVENT_CLOSE": ["Porte fermée", "door.png", "#e74c3c"], "LIGHT": ["Exposition à la lumière trop importante", "light.png", "#f1c40f"], "BOTTLE_OLD": ["Changer le bouchon", "time.png", "#9b59b6"], "BOTTLE_IN": ["Bouteille rentrée", "wine.png", "#3498db"], "BOTTLE_OUT": ["Bouteille sortie", "wine.png", "#27ae60"], "TEMPERATURE_UP": ["Température trop élevée", "temp.png", "#e67e22"], "TEMPERATURE_DOWN": ["Température trop basse", "temp.png", "#2980b9"]]
        
        if let event:Dictionary<String, AnyObject> = self.eventList?[indexPath.row] {
            let e: AnyObject? = event["event"]
            if let e = e as? String {
                let message = messages[e]
                NSLog("\(object_getClassName(message))")
                if let message = message {
                    cell.textLabel.text = message[0]
                    cell.imageView.image = UIImage(named: message[1])
                    cell.imageView.backgroundColor = UIColor(hexString: message[2])
                }
            }
        }
        return cell
    }
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        
    }
    
}
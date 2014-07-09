//
//  CHCellarContentViewController.swift
//  CellarHack
//
//  Created by stant on 02/07/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

/*******************************
*
* View utils
*/

class CHCellarContentViewTableViewCell: UITableViewCell {
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!)  {
        super.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
        self.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 25)
        self.detailTextLabel.font = UIFont(name: "HelveticaNeue", size: 17)
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.imageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = self.imageView.frame
        frame.size = CGSize(width: 100, height: self.bounds.size.height)
        self.imageView.frame = frame
        
        var textFrame = self.textLabel.frame
        textFrame.origin.x = frame.size.width + 10
        self.textLabel.frame = textFrame
        
        var detailFrame = self.detailTextLabel.frame
        detailFrame.origin.x = textFrame.origin.x + 10
        self.detailTextLabel.frame = detailFrame
    }
    
}

/*******************************
*
* View delegate protocol
*/

@objc protocol CHCellarContentViewDelegate {
    
}

/*******************************
*
* View implementation
*/

class CHCellarContentView : UIView {

    let wineList = UITableView()
    
    weak var delegate: CHCellarContentViewDelegate!
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor(hexString: "#ecf0f1", alpha: 1)

        self.setupwineList()
        
        self.setupConstraints()
    }
    
}

// setup methods
extension CHCellarContentView {
    
    func setupwineList() {
        wineList.setTranslatesAutoresizingMaskIntoConstraints(false)
        wineList.registerClass(CHCellarContentViewTableViewCell.self, forCellReuseIdentifier: "cell")
        wineList.separatorColor = UIColor(hexString: "#2c3e50")
        wineList.backgroundColor = UIColor.clearColor()
        wineList.rowHeight = 150
        self.addSubview(wineList)
    }
    
    func setupConstraints() {
        let views = ["wineList" : wineList]
        
        let horizontalwineListConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[wineList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalwineListConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(100)-[wineList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(verticalConstraints)
    }
}

// target methods
extension CHCellarContentView {

    
}

/*******************************
*
* ViewController implementation
*/

class CHCellarContentViewController: UIViewController {
    
    var wines: Array<Dictionary<String, AnyObject>>?
    
    override func loadView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let view = CHCellarContentView()
        view.delegate = self
        view.wineList.delegate = self
        view.wineList.dataSource = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWines()
    }
    
    func loadWines() {
        var error: NSError?
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET("\(CHServerUrl)/wine/", parameters: ["inside": "1"], success: {(request: AFHTTPRequestOperation!, result: AnyObject!) in
            if !result {
                NSLog("result is nil !!!")
                return
            }
            if let resultArray = result as? Array<Dictionary<String, AnyObject>> {
                self.wines = resultArray
                (self.view as CHCellarContentView).wineList.reloadData()
            }
        }, failure: {(request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            NSLog("Error: \(request.request.URL)")
        })
    }
    
}

// CHCellarContentViewDelegate
extension CHCellarContentViewController: CHCellarContentViewDelegate {
    
}

// UITableViewDelegate/UITableViewDataSource
extension CHCellarContentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if let wine = self.wines?[indexPath.row] {
            let name: AnyObject? = wine["name"]
            let id: AnyObject? = wine["identifier"]
            if let id = id as? String {
                let detailViewController = CHDetailViewController(wineId: id.toInt()!)
                self.navigationController.pushViewController(detailViewController, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if let count = self.wines?.count {
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let view = self.view as CHCellarContentView
        let cell = view.wineList.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if let wine = self.wines?[indexPath.row] {
            let name: AnyObject? = wine["name"]
            let title: AnyObject? = wine["title"]
            if let title = title as? String {
                cell.textLabel.text = title
            }
            
            if let name = name as? String {
                cell.detailTextLabel.text = name
            }
            
            let image:AnyObject? = wine["image"]
            
            if let image = image as? String {
                if image != "" {
                    NSLog("\(CHStaticServerUrl)/\(image)")
                    (cell as UITableViewCell).imageView.setImageWithURL(NSURL(string: "\(CHStaticServerUrl)/\(image)"))
                    let url = NSURL(string: "\(CHStaticServerUrl)/\(image)")
                    (cell as UITableViewCell).imageView.setImageWithURLRequest(NSURLRequest(URL: url), placeholderImage: nil, success: {(request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                            (cell as UITableViewCell).setNeedsLayout()
                        }, failure: nil)
                } else {
                    (cell as UITableViewCell).imageView.image = UIImage(named: "default_bottle.jpg")
                }
            }
        }
        return cell
    }
    
}
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
 * View utils
 */

class CHAddViewTableViewCell: UITableViewCell {
    
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

@objc protocol CHAddWineViewDelegate {
    
    func searchCameraPressed()
    
    func textFieldChanged(result:String)
    
}

/*******************************
*
* View implementation
*/

class CHAddWineView : UIView {
    
    let searchField = UITextField()
    let searchCamera = CHColorButton(color: UIColor(hexString: "#1abc9c"), highlightedColor: UIColor(hexString: "#16a085"))
    let searchList = UITableView()
    
    weak var delegate: CHAddWineViewDelegate!
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor(hexString: "#ecf0f1", alpha: 1)
        
        self.setupSearchField()
        self.setupSearchList()
        
        self.setupConstraints()
    }
    
}

// setup methods
extension CHAddWineView {
    
    func setupSearchField() {
        searchField.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchField.layer.borderColor = UIColor(hexString: "#2c3e50").CGColor
        searchField.delegate = self
        searchField.layer.borderWidth = 2
        searchField.textColor = UIColor(hexString: "#2c3e50")
        searchField.font = UIFont(name: "HelveticaNeue-Light", size: 45)
        searchField.layer.cornerRadius = 10
        self.addSubview(searchField)
        
        let leftView = UIView()
        leftView.frame = CGRectMake(0, 0, 30, 0)
        searchField.leftView = leftView
        searchField.leftViewMode = UITextFieldViewMode.Always
        
        let rightView = UIView()
        rightView.frame = CGRectMake(0, 0, 30, 0)
        searchField.rightView = rightView
        searchField.rightViewMode = UITextFieldViewMode.Always
        
        let cameraIcon = UIImage(named: "icon_camera.png")
        NSLog("\(cameraIcon.size)")
        searchCamera.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchCamera.addTarget(self, action: "searchCameraPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        searchCamera.setImage(cameraIcon, forState: UIControlState.Normal)
        self.addSubview(searchCamera)
    }
    
    func setupSearchList() {
        searchList.setTranslatesAutoresizingMaskIntoConstraints(false)
        searchList.registerClass(CHAddViewTableViewCell.self, forCellReuseIdentifier: "cell")
        searchList.separatorColor = UIColor(hexString: "#2c3e50")
        searchList.backgroundColor = UIColor.clearColor()
        searchList.rowHeight = 150
        self.addSubview(searchList)
    }
    
    func setupConstraints() {
        let views = ["searchField" : searchField, "searchCamera" : searchCamera, "searchList" : searchList]
        
        // Search items horizontal constraints
        let horizontalSearchFieldConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[searchField]-[searchCamera(==90)]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalSearchFieldConstraints)
        
        let horizontalSearchListConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[searchList]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalSearchListConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(==84)-[searchField(==90)]-[searchList]-|", options: nil, metrics: nil, views: views)
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
        self.delegate.searchCameraPressed()
    }
    
}

extension CHAddWineView: UITextFieldDelegate {
    
    func textField(textField: UITextField!, shouldChangeCharactersInRange range: NSRange, replacementString string: String!) -> Bool {
        let result = textField.text.bridgeToObjectiveC().stringByReplacingCharactersInRange(range, withString: string)
        self.delegate?.textFieldChanged(result)
        return true
    }
    
}

/*******************************
*
* ViewController implementation
*/

class CHAddWineViewController: UIViewController {
    
    var currentSearchTerms: String?
    var searchResults: Array<Dictionary<String, AnyObject>>?
    
    override func loadView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
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
        let cameraViewController = CHCameraViewController()
        cameraViewController.delegate = self
        self.navigationController!.pushViewController(cameraViewController, animated: true)
    }
    
    func textFieldChanged(result:String) {
        let loadSearchTerms = self.currentSearchTerms == nil
        self.currentSearchTerms = result
        if loadSearchTerms {
            self.loadSearchTerms()
        }
    }
    
    func loadSearchTerms() {
        if !self.currentSearchTerms {
            return
        }
        
        var error: NSError?
        let manager = AFHTTPRequestOperationManager()
        let searchTerms = self.currentSearchTerms!
        
        func loadNextOrDont() {
            if searchTerms != self.currentSearchTerms {
                self.loadSearchTerms()
            } else {
                self.currentSearchTerms = nil
            }
        }
        
        manager.GET("\(CHServerUrl)/wine/", parameters: ["search": searchTerms], success: {(request: AFHTTPRequestOperation!, result: AnyObject!) in
            if let resultArray = result as? Array<Dictionary<String, AnyObject>> {
                self.searchResults = resultArray
                (self.view as CHAddWineView).searchList.reloadData()
            }
            loadNextOrDont()
        }, failure: {(request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            loadNextOrDont()
            NSLog("Error: \(request.request.URL)")
        })
    }
    
}

// UITableViewDelegate/UITableViewDataSource
extension CHAddWineViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        if let wine = self.searchResults?[indexPath.row] {
            let name: AnyObject? = wine["name"]
            let id: AnyObject? = wine["identifier"]
            if let id = id as? String {
                let detailViewController = CHDetailViewController(wineId: id.toInt()!)
                self.navigationController.pushViewController(detailViewController, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if let count = self.searchResults?.count {
            return count
        }
        return 0
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let view = self.view as CHAddWineView
        let cell = view.searchList.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        if let wine = self.searchResults?[indexPath.row] {
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
                } else {
                    (cell as UITableViewCell).imageView.image = UIImage(named: "default_bottle.jpg")
                }
            }
        }
        return cell
    }
    
}

extension CHAddWineViewController: CHCameraViewControllerDelegate {
    
    func cameraViewControllerEnded() {
        let detailViewController = CHDetailViewController(wineId: 1253)
        self.navigationController.pushViewController(detailViewController, animated: true)
    }
    
}

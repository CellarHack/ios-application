//
//  CHMetricViewController.swift
//  CellarHack
//
//  Created by stant on 01/07/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

/*******************************
*
* View delegate protocol
*/

protocol CHMetricViewDelegate {
    
}

/*******************************
*
* View implementation
*/

class CHMetricView: UIView {
    
    let graphView = JBLineChartView()
    let label = UILabel()
    
    var delegate:CHMetricViewDelegate!
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor(hexString: "#ecf0f1", alpha: 1)
        
        self.setupGraphView()
        self.setupLabel()
        self.setupLayout()
    }
    
    // setup methods
    func setupGraphView() {
        self.graphView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.graphView.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.graphView)
    }
    
    func setupLabel() {
        label.setTranslatesAutoresizingMaskIntoConstraints(false)
        label.backgroundColor = UIColor.clearColor()
        label.textColor = UIColor.blackColor()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 200)
        label.text = "--"
        self.addSubview(self.label)
    }
    
    func setupLayout() {
        let views = ["graphView": self.graphView]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[graphView]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(110)-[graphView(300)]", options: nil, metrics: nil, views: views)
        self.addConstraints(verticalConstraints)
        
        let horizontalLabelConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        self.addConstraint(horizontalLabelConstraint)
        
        let verticalLabelConstraint = NSLayoutConstraint(item: self.label, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1.5, constant: 0)
        self.addConstraint(verticalLabelConstraint)
    }
    
}

/*******************************
*
* ViewController implementation
*/

class CHMetricViewController: UIViewController {
    
    var metrics: Array<Dictionary<String, AnyObject>>? = nil
    
    let metricKey: String
    let postFix: String
    
    init(metricKey: String, postFix: String) {
        self.metricKey = metricKey
        self.postFix = postFix
        super.init(coder: nil)
    }
    
    override func loadView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let view = CHMetricView()
        view.delegate = self
        view.graphView.delegate = self
        view.graphView.dataSource = self
        self.view = view
        
        if self.metricKey == "temp" {
            view.graphView.minimumValue = 0
            view.graphView.maximumValue = 20
        } else {
            view.graphView.minimumValue = 0
            view.graphView.maximumValue = 100
        }
        
        self.loadMetrics()
    }
    
    func loadMetrics() {
        var error: NSError?
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET("\(CHServerUrl)/metric/", parameters: nil, success: {(request: AFHTTPRequestOperation!, result: AnyObject!) in
            if let resultArray = result as? Array<Dictionary<String, AnyObject>> {
                NSLog("\(resultArray)")
                self.metrics = resultArray
                
                let value: AnyObject? = self.metrics![self.metrics!.endIndex - 1][self.metricKey]
                if let value = value as? Float {
                    (self.view as CHMetricView).label.text = "\(value)\(self.postFix)"
                }
                (self.view as CHMetricView).graphView.reloadData()
            }
            }, failure: {(request: AFHTTPRequestOperation!, error: NSError!) -> Void in
                NSLog("Error: \(request.request.URL)")
            })
    }
    
}

// JBLineChartViewDelegate methods
extension CHMetricViewController: JBLineChartViewDelegate, JBLineChartViewDataSource {
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView) -> Int {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView, verticalValueForHorizontalIndex index: Int, atLineIndex lineIndex: Int) -> CGFloat {
        if let metric:Dictionary<String, AnyObject> = self.metrics?[index] {
            let value: AnyObject? = metric[self.metricKey]
            if let value = value as? Float {
                return CGFloat(value)
            }
        }
        return 0
    }

    func lineChartView(lineChartView: JBLineChartView, numberOfVerticalValuesAtLineIndex index: Int) -> Int {
        if let count = self.metrics?.count {
            return count
        }
        return 0
    }
    
    func lineChartView(lineChartView: JBLineChartView, colorForLineAtLineIndex lineIndex: Int) -> UIColor {
        return UIColor(hexString:"#9b59b6")
    }
    
    func lineChartView(lineChartView: JBLineChartView, smoothLineAtLineIndex lineIndex: Int) -> Bool {
        return true
    }
    
}

// CHMetricViewDelegate methods
extension CHMetricViewController: CHMetricViewDelegate {
    
    
    
}
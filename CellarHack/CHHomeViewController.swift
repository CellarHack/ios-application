//
//  CHHomeViewController.swift
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

@objc protocol CHHomeViewDelegate {
    
    func alertButtonPressed()
    func buyButtonPressed()
    func tempButtonPressed()
    func moistButtonPressed()
    func cellarContentPressed()
    
}

/*******************************
*
* View implementation
*/

class CHHomeView : UIView {
    
    var temperatureLabel: UIButton!
    var humidityLabel: UIButton!
    
    let graphView = CHStarGraph()
    
    var bottomViews = Array<UIView>()
    
    weak var delegate:CHHomeViewDelegate!
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor(hexString: "#ecf0f1", alpha: 1)
        
        self.setupMetricsLabels()
        self.setupGraphView()
        self.setupButtons()
        
        self.setupConstraints()
    }
    
}

// setup methods
extension CHHomeView {
    
    func setupMetricsLabels() {
        func configLabel(color: UIColor, highlightedColor: UIColor) -> UIButton {
            let label = self.addBottomView(color, highlightedColor: highlightedColor)
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            label.backgroundColor = UIColor.clearColor()
            label.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            label.titleLabel.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 120)
            return label
        }
        
        temperatureLabel = configLabel(UIColor(hexString: "#1abc9c", alpha: 1), UIColor(hexString: "#16a085", alpha: 1))
        temperatureLabel.setTitle("12˚", forState: UIControlState.Normal)
        temperatureLabel.addTarget(self, action: "tempButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        humidityLabel = configLabel(UIColor(hexString: "#2ecc71", alpha: 1), UIColor(hexString: "#27ae60", alpha: 1))
        humidityLabel.setTitle("60%", forState: UIControlState.Normal)
        humidityLabel.addTarget(self, action: "moistButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func setupGraphView() {
        graphView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(graphView)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "cellarContentPressed:")
        graphView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupButtons() {
        func configButton(color: UIColor, highlightedColor: UIColor) -> UIButton {
            let button = self.addBottomView(color, highlightedColor: highlightedColor)
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.backgroundColor = UIColor.clearColor()
            button.contentMode = UIViewContentMode.ScaleAspectFit
            return button
        }
        
        let alertButton = configButton(UIColor(hexString: "#f1c40f", alpha: 1), UIColor(hexString: "#f39c12", alpha: 1))
        alertButton.setImage(UIImage(named: "icon_alert"), forState: UIControlState.Normal)
        alertButton.addTarget(self, action: "alertButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let shopButton = configButton(UIColor(hexString: "#9b59b6", alpha: 1), UIColor(hexString: "#8e44ad", alpha: 1))
        shopButton.setImage(UIImage(named: "icon_cart"), forState: UIControlState.Normal)
        shopButton.addTarget(self, action: "buyButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func addBottomView(color: UIColor, highlightedColor: UIColor)  -> UIButton {
        let bottomView = CHColorButton(color: color, highlightedColor: highlightedColor)
        bottomView.setTranslatesAutoresizingMaskIntoConstraints(false)
        bottomView.layer.backgroundColor = color.CGColor
        
        self.addSubview(bottomView)
        bottomViews.append(bottomView)
        return bottomView
    }
    
    func setupConstraints() {
        
        func setupGraphViewConstraints() {
            let centerXConstraint = NSLayoutConstraint(item: graphView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.addConstraint(centerXConstraint)
            
            let widthConstraint = NSLayoutConstraint(item: graphView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -40)
            self.addConstraint(widthConstraint)
            
            let heightConstraint = NSLayoutConstraint(item: graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0.5, constant: -120)
            self.addConstraint(heightConstraint)
            
            let topConstraint = NSLayoutConstraint(item: graphView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 90)
            self.addConstraint(topConstraint)
        }
        
        func setupBottomGridConstraints() {
            
            for (i, view) in enumerate(self.bottomViews) {
                
                let x = CGFloat(i % 2)
                let y = CGFloat(i / 2)
                
                let centerXMultiplier: CGFloat = (0.5 * x + 0.25) * 2
                let centerXConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: centerXMultiplier, constant: 0)
                self.addConstraint(centerXConstraint)
                
                let centerYMultiplier: CGFloat = (0.25 * y + 0.625) * 2
                let centerYConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: centerYMultiplier, constant: 0)
                self.addConstraint(centerYConstraint)
                
                let widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 0.5, constant: -20)
                self.addConstraint(widthConstraint)
                
                let heightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Height, multiplier: 0.25, constant: -20)
                self.addConstraint(heightConstraint)
            }
            
        }

        setupGraphViewConstraints()
        setupBottomGridConstraints()
    }
}

// target methods
extension CHHomeView {
    
    func alertButtonPressed(sender: UIButton) {
        delegate.alertButtonPressed()
    }
    
    func buyButtonPressed(sender: UIButton) {
        delegate.buyButtonPressed()
    }
    
    func tempButtonPressed(sender: UIButton) {
        delegate.tempButtonPressed()
    }
    
    func moistButtonPressed(sender: UIButton) {
        delegate.moistButtonPressed()
    }
    
    func cellarContentPressed(sender: UITapGestureRecognizer) {
        delegate.cellarContentPressed()
    }
    
}

/*******************************
*
* ViewController implementation
*/

class CHHomeViewController: UIViewController {
    
    let graphData = [(name: "Bordeaux", value: 12), (name: "Bourgogne", value: 13), (name: "Champagne", value: 8), (name: "Côtes du rhône", value: 5), (name: "Vinaigre", value: 16), (name: "Haut-Médoc", value: 24)]
    
    override func loadView() {
        self.automaticallyAdjustsScrollViewInsets = false
        
        let view = CHHomeView()
        view.delegate = self
        view.graphView.dataSource = self
        self.view = view
        
        self.title = "Cellar Hack"
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadMetrics()
    }
    
    func loadMetrics() {
        var error: NSError?
        let manager = AFHTTPRequestOperationManager()
        
        manager.GET("\(CHServerUrl)/metric/", parameters: ["last": "1"], success: {(request: AFHTTPRequestOperation!, result: AnyObject!) in
            if let resultArray = result as? Array<Dictionary<String, AnyObject>> {
                let last = resultArray[resultArray.endIndex - 1] as Dictionary<String, AnyObject>
                let temp:AnyObject? = last["temp"]
                if let temp = temp as? Int {
                    (self.view as CHHomeView).temperatureLabel.setTitle("\(temp)˚", forState: UIControlState.Normal)
                }
                let moist:AnyObject? = last["moist"]
                if let moist = moist as? Int {
                    (self.view as CHHomeView).humidityLabel.setTitle("\(moist)%", forState: UIControlState.Normal)
                }
            }
        }, failure: {(request: AFHTTPRequestOperation!, error: NSError!) -> Void in
            NSLog("Error: \(request.request.URL)")
        })
    }
    
}

// CHHomeViewDelegate
extension CHHomeViewController: CHHomeViewDelegate {
    
    func alertButtonPressed() {
        let alertViewController = CHAlertViewController()
        self.navigationController?.pushViewController(alertViewController, animated: true)
    }
    
    func buyButtonPressed() {
        let addViewController = CHAddWineViewController()
        self.navigationController?.pushViewController(addViewController, animated: true)
    }
    
    func tempButtonPressed() {
        let metricViewController = self.startMetricViewController("temp", postFix: "˚")
        metricViewController.title = "Temperature"
    }
    
    func moistButtonPressed() {
        let metricViewController = self.startMetricViewController("moist", postFix: "%")
        metricViewController.title = "Humidity"
    }
    
    func startMetricViewController(metricKey: String, postFix: String) -> UIViewController {
        let metricViewController = CHMetricViewController(metricKey: metricKey, postFix: postFix)
        self.navigationController?.pushViewController(metricViewController, animated: true)
        return metricViewController
    }
    
    func cellarContentPressed() {
        let cellarContentViewController = CHCellarContentViewController()
        self.navigationController?.pushViewController(cellarContentViewController, animated: true)
    }
    
}

// CHStartGraphDataSource methods

extension CHHomeViewController: CHStarGraphDataSource {
    
    func valueForItemAtIndex(index:Int) -> Int {
        let tuple = graphData[index]
        return tuple.value
    }
    
    func nameForItemAtIndex(index:Int) -> String {
        let tuple = graphData[index]
        return tuple.name
    }
    
    func valueRange() -> NSRange {
        var (min:Int, max:Int) = (4242, -4242)
        
        for (_, value) in graphData {
            min = min < value ? min : value
            max = max > value ? max : value
        }
        
        return NSRange(location: min, length: max - min)
    }
    
    func numberOfItems() -> Int {
        return graphData.count
    }
    
}
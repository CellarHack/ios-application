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

@class_protocol protocol CHHomeViewDelegate {
    
    func alertButtonPressed()
    
}

/*******************************
*
* View implementation
*/

class CHHomeView : UIView {
    
    let temperatureLabel = UILabel()
    let humidityLabel = UILabel()
    
    let graphView = CHStarGraph()
    
    let alertButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    let shopButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
    
    weak var delegate:CHHomeViewDelegate?
    
    init() {
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.blackColor()
        
        self.setupMetricsLabels()
        self.setupGraphView()
        self.setupButtons()
        
        self.setupConstraints()
    }
    
}

// setup methods
extension CHHomeView {
    
    func setupMetricsLabels() {
        func configLabel(label:UILabel) {
            label.setTranslatesAutoresizingMaskIntoConstraints(false)
            label.backgroundColor = UIColor.clearColor()
            label.textColor = UIColor.whiteColor()
            label.font = UIFont(name: "HelveticaNeue-UltraLight", size: 60)
            self.addSubview(label)
        }
        
        configLabel(temperatureLabel)
        temperatureLabel.text = "12˚"
        
        configLabel(humidityLabel)
        humidityLabel.text = "60%"
    }
    
    func setupGraphView() {
        graphView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.addSubview(graphView)
    }
    
    func setupButtons() {
        func configButton(button:UIButton) {
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.backgroundColor = UIColor.clearColor()
            self.addSubview(button)
        }
        
        configButton(alertButton)
        alertButton.setImage(UIImage(named: "icon_alert"), forState: UIControlState.Normal)
        alertButton.addTarget(self, action: "alertButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        configButton(shopButton)
        shopButton.setImage(UIImage(named: "icon_cart"), forState: UIControlState.Normal)
    }
    
    func setupConstraints() {
        func setupMetricsLabelsConstraints() {
            let horizontalLeftConstraint = NSLayoutConstraint(item: humidityLabel, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
            self.addConstraint(horizontalLeftConstraint)
            
            let horizontalRightConstraint = NSLayoutConstraint(item: temperatureLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
            self.addConstraint(horizontalRightConstraint)
            
            for view in [humidityLabel, temperatureLabel] {
                let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 20)
                self.addConstraint(topConstraint)
            }
        }
        
        func setupGraphViewConstraints() {
            let centerXConstraint = NSLayoutConstraint(item: graphView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
            self.addConstraint(centerXConstraint)
            
            let centerYConstraint = NSLayoutConstraint(item: graphView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
            self.addConstraint(centerYConstraint)
            
            let widthLimitConstraint = NSLayoutConstraint(item: graphView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 500)
            self.addConstraint(widthLimitConstraint)
            
            let heightLimitConstraint = NSLayoutConstraint(item: graphView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 500)
            self.addConstraint(heightLimitConstraint)
            
            let views = ["graphView": graphView]
            let widthConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(20@500)-[graphView]-(20@500)-|", options: nil, metrics: nil, views: views)
            self.addConstraints(widthConstraints)
            
            let heightConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-(20@500)-[graphView]-(20@500)-|", options: nil, metrics: nil, views: views)
            self.addConstraints(heightConstraints)
        }
        
        func setupButtonsConstraints() {
            let horizontalLeftConstraint = NSLayoutConstraint(item: alertButton, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 20)
            self.addConstraint(horizontalLeftConstraint)
            
            let horizontalRightConstraint = NSLayoutConstraint(item: shopButton, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: -20)
            self.addConstraint(horizontalRightConstraint)
            
            for view in [alertButton, shopButton] {
                let topConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -20)
                self.addConstraint(topConstraint)
            }
        }
        
        setupMetricsLabelsConstraints()
        setupGraphViewConstraints()
        setupButtonsConstraints()
    }
}

// target methods
extension CHHomeView {
    
    func alertButtonPressed(sender: UIButton) {
        delegate?.alertButtonPressed()
    }
    
}

/*******************************
*
* ViewController implementation
*/

class CHHomeViewController: UIViewController {
    
    let graphData = [(name: "Bordeaux", value: 12), (name: "Bourgogne", value: 13), (name: "Champagne", value: 8), (name: "Côtes du rhône", value: 5), (name: "Vinaigre", value: 16), (name: "Haut-Médoc", value: 24)]
    
    override func loadView() {
        let view = CHHomeView()
        view.delegate = self
        view.graphView.dataSource = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// CHHomeViewDelegate
extension CHHomeViewController: CHHomeViewDelegate {
    
    func alertButtonPressed() {
        let alertViewController = CHAlertViewController()
        self.navigationController?.pushViewController(alertViewController, animated: true)
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
    
    func valueRange() -> Range<Int> {
        var (min:Int, max:Int) = (4242, -4242)
        
        for (_, value) in graphData {
            min = min < value ? min : value
            max = max > value ? max : value
        }
        
        return min...max
    }
    
    func numberOfItems() -> Int {
        return graphData.count
    }
    
}
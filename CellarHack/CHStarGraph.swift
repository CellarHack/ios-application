//
//  CHStartGraph.swift
//  CellarHack
//
//  Created by stant on 26/06/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

@objc protocol CHStarGraphDataSource {
    
    func valueForItemAtIndex(index:Int) -> Int
    func nameForItemAtIndex(index:Int) -> String
    func valueRange() -> NSRange
    func numberOfItems() -> Int
    
}

class CHStarGraph: UIView {
    
    weak var dataSource: CHStarGraphDataSource!
    
    var labels = Array<UILabel>()
    
    init() {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor.clearColor()
        self.clipsToBounds = false
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "oritentationChanged:", name: UIApplicationDidChangeStatusBarOrientationNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func drawRect(rect: CGRect) {
        
        if !dataSource {
            return;
        }
        
        let bounds = self.bounds
        let center = (x: Double(bounds.size.width / 2), y: Double(bounds.size.height / 2))
        
        let numberOfItems = dataSource.numberOfItems()
        let valueRange = dataSource.valueRange()
        
        let sideSize = bounds.size.width < bounds.size.height ? bounds.size.width / 2 : bounds.size.height / 2
        
        let angleStep = Double(M_PI * 2) / Double(numberOfItems)
        let pixelsPerUnit = Double(sideSize) / Double(valueRange.location + valueRange.length)
        
        let valuePath = CGPathCreateMutable()
        let scalePath = CGPathCreateMutable()
        
        let context = UIGraphicsGetCurrentContext()
        
        self.removeLabels()
        
        func add_scale_line(index:Int, vector:(x:Double, y:Double)) {
            let (axeX, axeY) = (center.x + vector.x * sideSize, center.y + vector.y * sideSize)
            
            CGPathMoveToPoint(scalePath, nil, CGFloat(center.x), CGFloat(center.y))
            CGPathAddLineToPoint(scalePath, nil, CGFloat(axeX), CGFloat(axeY))
            
            let step = sideSize / 10
            
            for i in 1...9 {
                let position = (x: Double(center.x + vector.x * step * Double(i)), y: Double(center.y + vector.y * step * Double(i)))
                let normal = (x: -vector.y, y: vector.x)
                CGPathMoveToPoint(scalePath, nil, CGFloat(position.x + normal.x * 4), CGFloat(position.y + normal.y * 4))
                CGPathAddLineToPoint(scalePath, nil, CGFloat(position.x + normal.x * -4), CGFloat(position.y + normal.y * -4))
            }
            
            if self.labels.count < numberOfItems {
                let name = dataSource.nameForItemAtIndex(index)
                self.addLabelAtPosition(CGPoint(x: CGFloat(axeX), y: CGFloat(axeY)), text: name)
            }
        }
        
        for i in 0...numberOfItems {
            let index = i % numberOfItems
            let currentAngle = angleStep * Double(i) - M_PI_2
            let vector:(x:Double, y:Double) = (x: Double(cos(currentAngle)), y: Double(sin(currentAngle)))
            let value:Double = Double(dataSource.valueForItemAtIndex(index)) * pixelsPerUnit
            let (x, y) = (CGFloat(center.x + vector.x * value), CGFloat(center.y + vector.y * value))
            
            if i == 0 {
                CGPathMoveToPoint(valuePath, nil, x, y)
            } else {
                CGPathAddLineToPoint(valuePath, nil, x, y)
            }
            
            add_scale_line(index, vector)
        }
        
        CGContextSetLineWidth(context, 2)
        CGContextSetStrokeColorWithColor(context, UIColor(hexString: "#34495e").CGColor)
        CGContextAddPath(context, scalePath)
        CGContextDrawPath(context, kCGPathStroke)
        
        CGContextSetLineWidth(context, 4)
        CGContextSetStrokeColorWithColor(context, UIColor(hexString: "#8e44ad").CGColor)
        CGContextAddPath(context, valuePath)
        CGContextDrawPath(context, kCGPathStroke)

    }
    
    func addLabelAtPosition(pos: CGPoint, text: String) {
        let label = UILabel()
        label.textColor = UIColor.blackColor()
        label.backgroundColor = UIColor(hexString: "#ecf0f1", alpha: 0.8)
        label.font = UIFont(name: "HelveticaNeue", size: 20)
        label.text = text
        label.sizeToFit()
        
        label.center = pos
        
        self.addSubview(label)
        
        labels.append(label)
    }
    
    func removeLabels() {
        for label in labels {
            label.removeFromSuperview()
        }
        
        labels.removeAll(keepCapacity: false)
    }
    
}

extension CHStarGraph {
    
    func oritentationChanged(note: NSNotification) {
        self.setNeedsDisplay()
    }
    
}
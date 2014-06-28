//
//  CHStartGraph.swift
//  CellarHack
//
//  Created by stant on 26/06/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

@class_protocol protocol CHStarGraphDataSource {
    
    func valueForItemAtIndex(index:Int) -> Int
    func nameForItemAtIndex(index:Int) -> String
    func valueRange() -> Range<Int>
    func numberOfItems() -> Int
    
}

class CHStarGraph: UIView {
    
    weak var dataSource: CHStarGraphDataSource?
    
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
        
        let bounds = self.bounds
        let center = (x: Double(bounds.size.width / 2), y: Double(bounds.size.height / 2))
        
        let numberOfItems = dataSource!.numberOfItems()
        let valueRange = dataSource!.valueRange()
        
        let angleStep = Double(M_PI * 2) / Double(numberOfItems)
        let pixelsPerUnit = Double(bounds.size.width / 2) / Double(valueRange.endIndex)
        
        let valuePath = CGPathCreateMutable()
        let scalePath = CGPathCreateMutable()
        
        let context = UIGraphicsGetCurrentContext()
        
        self.removeLabels()
        
        func add_scale_line(index:Int, vector:(x:Double, y:Double)) {
            let (axeX, axeY) = (center.x + vector.x * Double(bounds.width) / 2, center.y + vector.y * Double(bounds.width) / 2)
            var affine = CGAffineTransformIdentity
            CGPathMoveToPoint(scalePath, &affine, CGFloat(center.x), CGFloat(center.y))
            CGPathAddLineToPoint(scalePath, nil, CGFloat(axeX), CGFloat(axeY))
            
            let step = Double(bounds.width) / 20
            
            for i in 1...9 {
                let position = (x: Double(center.x + vector.x * step * Double(i)), y: Double(center.y + vector.y * step * Double(i)))
                let normal = (x: -vector.y, y: vector.x)
                CGPathMoveToPoint(scalePath, nil, CGFloat(position.x + normal.x * 4), CGFloat(position.y + normal.y * 4))
                CGPathAddLineToPoint(scalePath, nil, CGFloat(position.x + normal.x * -4), CGFloat(position.y + normal.y * -4))
            }
            
            let name = dataSource!.nameForItemAtIndex(index % numberOfItems)
            self.addLabelAtPosition(CGPoint(x: CGFloat(axeX), y: CGFloat(axeY)), text: name)
        }
        
        for i in 0...numberOfItems + 1 {

            let currentAngle = angleStep * Double(i) - M_PI_2
            let vector:(x:Double, y:Double) = (x: Double(cos(currentAngle)), y: Double(sin(currentAngle)))
            let value:Double = Double(dataSource!.valueForItemAtIndex(i % numberOfItems)) * pixelsPerUnit
            let (x, y) = (CGFloat(center.x + vector.x * value), CGFloat(center.y + vector.y * value))
            
            if i == 0 {
                CGPathMoveToPoint(valuePath, nil, x, y)
            } else {
                CGPathAddLineToPoint(valuePath, nil, x, y)
            }
            
            add_scale_line(i, vector)
        }
        
        CGContextSetStrokeColorWithColor(context, UIColor.darkGrayColor().CGColor)
        CGContextAddPath(context, scalePath)
        CGContextDrawPath(context, kCGPathStroke)
        
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        CGContextAddPath(context, valuePath)
        CGContextDrawPath(context, kCGPathStroke)

    }
    
    func addLabelAtPosition(pos: CGPoint, text: String) {
        let label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.font = UIFont(name: "HelveticaNeue-Light", size: 20)
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
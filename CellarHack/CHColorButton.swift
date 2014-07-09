//
//  CHColorButton.swift
//  CellarHack
//
//  Created by stant on 30/06/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

class CHColorButton: UIButton {
    
    let backgroundView = UIView()
    
    let normalColor: UIColor
    let highlightedColor: UIColor
    
    override var highlighted: Bool {
    didSet {
        if highlighted {
            self.backgroundView.backgroundColor = self.highlightedColor
        } else {
            self.backgroundView.backgroundColor = self.normalColor
        }
    }
    }
    
    init(color: UIColor, highlightedColor: UIColor) {
        self.normalColor = color
        self.highlightedColor = highlightedColor
        super.init(frame: CGRectZero)
        
        backgroundView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        backgroundView.frame = self.bounds
        backgroundView.userInteractionEnabled = false
        backgroundView.backgroundColor = color
        self.insertSubview(backgroundView, belowSubview: self.imageView)
    }
    
}
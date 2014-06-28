//
//  CHDetailViewController.swift
//  CellarHack
//
//  Created by stant on 11/06/14.
//  Copyright (c) 2014 CCSAS. All rights reserved.
//

import UIKit

/*******************************
 *
 * View delegate protocol
 */

@class_protocol protocol CHDetailViewDelegate {
    
    func buttonOkPressed()
    func buttonEditPressed()
    
}

/*******************************
 *
 * View implementation
 */

class CHDetailView : UIView {
    
    let titleView = UILabel()
    let textView = UITextView()
    let imageView = UIImageView()
    let priceLabel = UILabel()

    let buttonOk = UIButton()
    let buttonEdit = UIButton()
    var buttonsConstraints: NSLayoutConstraint[] = []
    
    weak var delegate: CHDetailViewDelegate?
    
    init() {
        
        super.init(frame: UIScreen.mainScreen().bounds)
        self.backgroundColor = UIColor.blackColor()
        
        self.setupDetailView()
        self.setupPriceLabel()
        self.setupButtons()
        self.setupConstraints()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "orientationChanged:", name: UIApplicationWillChangeStatusBarOrientationNotification, object: nil)
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        self.setupButtonConstraints()
    }
    
}

// setup methods
extension CHDetailView {
    
    func setupDetailView() {
        
        titleView.setTranslatesAutoresizingMaskIntoConstraints(false)
        titleView.font = UIFont(name: "HelveticaNeue-Light", size: 40)
        titleView.textColor = UIColor.whiteColor()
        titleView.numberOfLines = 0
        titleView.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        titleView.text = NSLocalizedString("WINE_NAME", comment: "")
        self.addSubview(titleView)
        
        textView.setTranslatesAutoresizingMaskIntoConstraints(false)
        textView.editable = false
        textView.scrollEnabled = false
        textView.font = UIFont(name: "HelveticaNeue-Light", size: 30)
        textView.textColor = UIColor.whiteColor()
        textView.backgroundColor = UIColor.clearColor()
        textView.text = NSLocalizedString("WINE_DESCR", comment: "")
        self.addSubview(textView)
        
        imageView.setTranslatesAutoresizingMaskIntoConstraints(false)
        imageView.image = UIImage(named: "sarrins.png")
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.sizeToFit()
        self.addSubview(imageView)
        
        NSLog("\(imageView.frame.size.width) \(imageView.frame.size.height)")
        
    }
    
    func setupPriceLabel() {
        
        priceLabel.setTranslatesAutoresizingMaskIntoConstraints(false)
        priceLabel.font = UIFont(name: "HelveticaNeue-UltraLight", size: 40)
        priceLabel.textColor = UIColor.whiteColor()
        priceLabel.text = NSLocalizedString("PRICE", comment: "")
        self.addSubview(priceLabel)

    }
    
    func setupButtons() {
        
        func configButton(button:UIButton, title:NSString) {
            button.setTranslatesAutoresizingMaskIntoConstraints(false)
            button.backgroundColor = UIColor.whiteColor()
            button.layer.cornerRadius = 10
            button.clipsToBounds = true
            button.setTitle(title, forState: UIControlState.Normal)
            button.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 40)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            
            self.addSubview(button)
        }
        
        configButton(buttonOk, NSLocalizedString("BUTTON_OK", comment: ""))
        buttonOk.backgroundColor = UIColor.greenColor()
        buttonOk.addTarget(self, action: "buttonOkPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        configButton(buttonEdit, NSLocalizedString("BUTTON_EDIT", comment: ""))
        buttonEdit.backgroundColor = UIColor.redColor()
        buttonEdit.addTarget(self, action: "buttonEditPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func setupConstraints() {
        
        // titleView, textView, imageView constraints
        
        let views = ["titleView": titleView, "textView": textView, "imageView": imageView, "buttonOk": buttonOk, "buttonEdit": buttonEdit]
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[imageView(==300)]-[textView]-|", options: nil, metrics: nil, views: views)
        self.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[titleView]-(==60)-[imageView]-(>=0)-|", options: nil, metrics: nil, views: views)
        self.addConstraints(verticalConstraints)
        
        let topTextViewConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: textView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: -25)
        self.addConstraint(topTextViewConstraint)
        
        let leftTitleViewConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Left, multiplier: 1, constant: 0)
        self.addConstraint(leftTitleViewConstraint)
        
        let widthTitleViewConstraint = NSLayoutConstraint(item: titleView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.LessThanOrEqual, toItem: self, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: -30)
        self.addConstraint(widthTitleViewConstraint)
        
        // priceLabel constraints
        
        let verticalConstraint = NSLayoutConstraint(item: priceLabel, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: titleView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 10)
        self.addConstraint(verticalConstraint)
        
        let horizontalConstraint = NSLayoutConstraint(item: priceLabel, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: textView, attribute: NSLayoutAttribute.Right, multiplier: 1, constant: 0)
        self.addConstraint(horizontalConstraint)
        
        // buttons constraints
        
        self.setupButtonConstraints()
    }
    
    func setupButtonConstraints() {
        
        let views = ["titleView": titleView, "textView": textView, "imageView": imageView, "buttonOk": buttonOk, "buttonEdit": buttonEdit]
        
        self.removeConstraints(self.buttonsConstraints)
        
        let buttonHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[buttonEdit(==buttonOk)]-(==160)-[buttonOk(==180)]", options: nil, metrics: nil, views: views)
        self.addConstraints(buttonHorizontalConstraints)
        
        var centerView = (UIApplication.sharedApplication().statusBarOrientation.isPortrait ? self : textView)
        let buttonCenterConstraint = NSLayoutConstraint(item: buttonOk, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: centerView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 80)
        self.addConstraint(buttonCenterConstraint)
        
        let buttonBottomConstraint = NSLayoutConstraint(item: buttonOk, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: -80)
        buttonBottomConstraint.priority = 200; // keep image view position
        self.addConstraint(buttonBottomConstraint)
        
        // bottom always >= bottom image view
        let buttonBottomConstraint2 = NSLayoutConstraint(item: buttonOk, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.GreaterThanOrEqual, toItem: imageView, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0)
        self.addConstraint(buttonBottomConstraint2)
        
        let buttonVerticalConstraint = NSLayoutConstraint(item: buttonOk, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: buttonEdit, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        self.addConstraint(buttonVerticalConstraint)
        
        self.buttonsConstraints.removeAll(keepCapacity: true)
        self.buttonsConstraints += buttonHorizontalConstraints as NSLayoutConstraint[]
        self.buttonsConstraints += [buttonCenterConstraint, buttonBottomConstraint, buttonBottomConstraint2, buttonVerticalConstraint]
        
    }
    
}

// target methods
extension CHDetailView {

    func orientationChanged(notification:NSNotification) {
        self.setNeedsUpdateConstraints()
    }
    
    func buttonOkPressed(sender:UIButton) {
        self.delegate?.buttonOkPressed()
    }
    
    func buttonEditPressed(sender:UIButton) {
        self.delegate?.buttonEditPressed()
    }
    
}

/*******************************
 *
 * ViewController implementation
 */

class CHDetailViewController: UIViewController {
    
    override func loadView() {
        let view = CHDetailView()
        view.delegate = self
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

// CHDetailViewDelegate
extension CHDetailViewController: CHDetailViewDelegate {
    
    func buttonOkPressed() {
        
    }
    
    func buttonEditPressed() {
        
    }
    
}

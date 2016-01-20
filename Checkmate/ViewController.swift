//
//  ViewController.swift
//  Checkmate
//
//  Created by Kevin Vincent on 1/16/16.
//  Copyright © 2016 checkmate. All rights reserved.
//

import UIKit
import QuartzCore

var SavedCoupons: [Coupon] = [];

class ViewController: UIViewController {

    @IBOutlet var nextButton: SpringButton!
    
    @IBAction func nextButtonPress(sender: AnyObject) {
        performSegueWithIdentifier("mainSegue", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib
        
        // create base view
        let view: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height))
        
        // create gradient layer
        let gradient : CAGradientLayer = CAGradientLayer()
        
        // create color array
        let arrayColors: [AnyObject] = [
            UIColor.whiteColor().CGColor,
            UIColor(red:0.9, green:0.91, blue:0.91, alpha:1.0).CGColor
        ]
        
        // set gradient frame bounds to match view bounds
        gradient.frame = view.bounds
        
        // set gradient's color array
        gradient.colors = arrayColors
        
        // replace base layer with gradient layer
        self.view.layer.insertSublayer(gradient, atIndex: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}



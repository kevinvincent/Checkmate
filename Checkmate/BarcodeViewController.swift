//
//  BarcodeViewController.swift
//  Checkmate
//
//  Created by Kevin Vincent on 1/17/16.
//  Copyright © 2016 checkmate. All rights reserved.
//

import UIKit

class BarcodeViewController: UIViewController {
    
    var theCoupon: Coupon = Coupon(name: "", description: "", expires: "", businessId: -1);
    
    @IBOutlet var barcode: UIImageView!

    @IBOutlet var businessName: UILabel!
    
    @IBOutlet var coupondescription: UILabel!
    @IBOutlet var expires: UILabel!
    
    @IBOutlet var background: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        background.image = UIImage(named: "stores-id-\(theCoupon.businessId)")
        coupondescription.text = theCoupon.description
        expires.text = theCoupon.expires
        businessName.text = theCoupon.name;
    }
    
    override func viewDidAppear(animated: Bool) {
        //barcode.image = Barcode.fromString("\(theCoupon.businessId)")
    }
    
    @IBAction func done(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

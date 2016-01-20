//
//  DiscoverViewController.swift
//  Checkmate
//
//  Created by Kevin Vincent on 1/17/16.
//  Copyright © 2016 checkmate. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {

    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        print("Left")
        self.couponResult.alpha = 0
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.couponView.center.x -= self.view.bounds.width
        }, completion: { (finished: Bool) -> Void in
            self.showResult("trash")
        })
    }
    @IBAction func swipeUp(sender: UISwipeGestureRecognizer) {
        print("Up")
        saveCurrentCoupon()
        self.couponResult.alpha = 0
        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.couponView.center.y -= self.view.bounds.height
        }, completion: { (finished: Bool) -> Void in
            self.showResult("save")
        })
    }
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        print("Right")
        self.couponResult.alpha = 0
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.couponView.center.x += self.view.bounds.width
        }, completion: { (finished: Bool) -> Void in
            self.showResult("block")
        })
    }
    @IBAction func swipeDown(sender: UISwipeGestureRecognizer) {
        print("Down")
        self.couponResult.alpha = 0
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.couponView.center.y -= self.view.bounds.height
        }, completion: { (finished: Bool) -> Void in
            self.showNextCoupon()
        })
    }
    
    @IBOutlet var couponView: UIView!
    @IBOutlet var couponResult: UIImageView!
    
    @IBOutlet var businessName: UILabel!
    
    @IBOutlet var offerDescription: UILabel!
    
    @IBOutlet var expires: UILabel!
    
    @IBOutlet var storeBackground: UIImageView!
    
    var couponModel = Coupons()
    var couponModelIndex = -1;
    
    func showResult(result: String) {
        if(result == "trash") {
            couponResult.image = UIImage(named: "actions-trash")
            animateResult()
        } else if(result == "save") {
            couponResult.image = UIImage(named: "actions-heart")
            animateResult()
        } else if (result == "block") {
            couponResult.image = UIImage(named: "actions-block")
            animateResult()
        }
    }
    
    func animateResult() {
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.couponResult.alpha = 1
            }, completion: { (finished: Bool) -> Void in
                delay(0.4) {
                    UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                        self.couponResult.alpha = 0
                        }, completion: { (finished: Bool) -> Void in
                            self.showNextCoupon()
                    })
                }
        })
    }
    
    func saveCurrentCoupon() {
        var currentCoupon = couponModel.coupons[self.couponModelIndex];
        SavedCoupons.append(currentCoupon)
    }
    
    func showNextCoupon() {
        
        couponModelIndex += 1;
        print(couponModelIndex)
        
        if(couponModelIndex < couponModel.coupons.count) {
            var currentCoupon: Coupon = couponModel.coupons[couponModelIndex]
            
            businessName.text = currentCoupon.name
            offerDescription.text = currentCoupon.description
            expires.text = currentCoupon.expires
            print("stores-id-\(currentCoupon.businessId)")
            storeBackground.image = UIImage(named: "stores-id-\(currentCoupon.businessId)")
            
            self.couponView.alpha = 0
            self.couponView.transform = CGAffineTransformMakeScale(0, 0)
            self.couponView.center.x = self.view.bounds.width/2
            self.couponView.center.y = self.view.bounds.height/2
            UIView.animateWithDuration(0.25, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.couponView.alpha = 1
                }, completion: { (finished: Bool) -> Void in
                    
            })
            UIView.animateWithDuration(0.7, delay: 0.0, usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.2, options: [], animations:
                {
                    self.couponView.transform = CGAffineTransformMakeScale(1, 1)
                }, completion: nil)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.couponView.layer.shadowColor = UIColor.blackColor().CGColor
        self.couponView.layer.shadowOffset = CGSizeMake(0, 0)
        self.couponView.layer.shadowRadius = 7
        self.couponView.layer.shadowOpacity = 0.5
        self.couponView.alpha = 0
        
        couponModel.load(self) {
            
        }
        
        while(true) {
            if(couponModel.coupons.count > 0) {
                break;
            }
        }
        
        showNextCoupon()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

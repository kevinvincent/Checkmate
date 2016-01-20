//
//  LocalTableViewController.swift
//  Checkmate
//
//  Created by Kevin Vincent on 1/16/16.
//  Copyright © 2016 checkmate. All rights reserved.
//

import UIKit

public class LoadingOverlay{
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
        overlayView.frame = CGRectMake(0, 0, 80, 80)
        overlayView.center = view.center
        overlayView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRectMake(0, 0, 40, 40)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}

class Barcode {
    
    class func fromString(string : String) -> UIImage? {
        
        let data = string.dataUsingEncoding(NSASCIIStringEncoding)
        let filter = CIFilter(name: "CICode128BarcodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        return UIImage(CIImage: filter!.outputImage!)
        
    }
    
}

class Coupon {
    var name: String
    var description: String;
    var expires: String;
    var businessId: Int;
    init(name: String, description: String, expires: String, businessId: Int) {
        self.name = name
        self.description = description
        self.expires = expires
        self.businessId = businessId
    }
}

class Coupons {
    
    var coupons:[Coupon] = [];
    
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    func load(sender: UIViewController, callback: () -> Void){
        
        if let url = NSURL(string: "http://nerris.onlinevirusrepair.com/coupons.json") {
            
            let session = NSURLSession.sharedSession()
            
            let task = session.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("error: \(error!.localizedDescription): \(error!.userInfo)")
                }
                else if data != nil {
                    if let str = NSString(data: data!, encoding: NSUTF8StringEncoding) {
                        self.coupons = []
                        var rawCoupons = self.convertStringToDictionary(str as String)!["coupons"]
                        if let myCoupons = rawCoupons as? [NSDictionary] {
                            for coupon in myCoupons {
                                print(coupon["name"])
                                self.coupons.append(Coupon(name: coupon["bus_name"] as! String, description: coupon["description"] as! String, expires: "Expires in 2 days", businessId: coupon["bus_id"] as! Int))
                            }
                        }
                        callback()
                    }
                    else {
                        print("unable to convert data to text")
                    }
                }
            })
            
            task.resume()
        }
        else {
            print("Unable to create NSURL")
        }

    }
    
}

class LocalTableViewController: UITableViewController {
    
    var coupons = [String]()
    var couponsModel = Coupons()
    var lastSelectedCoupon: Coupon = Coupon(name: "", description: "", expires: "", businessId: -1);

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(animated: Bool) {
        print(SavedCoupons)
        tableView.reloadData();
    }
    
    override func viewWillAppear(animated: Bool) {
        LoadingOverlay.shared.hideOverlayView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SavedCoupons.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CouponTableViewCell", forIndexPath: indexPath) as! CouponTableViewCell
        
        let coupon = SavedCoupons[indexPath.row]
        
        cell.businessName.text = coupon.name
        cell.offerDescription.text = coupon.description
        cell.expires.text = coupon.expires
        cell.backgroundImage.image = UIImage(named: "stores-id-\(coupon.businessId)")
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        lastSelectedCoupon = SavedCoupons[indexPath.row]
        LoadingOverlay.shared.showOverlay(self.view)
        performSegueWithIdentifier("barcode", sender: nil)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination: BarcodeViewController = segue.destinationViewController as! BarcodeViewController;
        destination.theCoupon = lastSelectedCoupon;
    }
    

}

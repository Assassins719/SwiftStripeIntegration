//
//  ViewController.swift
//  StripeDemo
//
//  Created by Admin on 07/12/2017.
//  Copyright © 2017 Nick. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class ViewController: UIViewController, CardFieldViewDelegate  {
    @IBOutlet weak var emailAddress: UITextField!
    var strToken : String  = "";
    var strCurrency : String = "usd";
    var strDescription : String = "Stripe Demo Testing";
    var strCustomerId : String = "";
    var nAmount : Int = 300;
    let backendURL:String = "https://us-central1-rewards-45897.cloudfunctions.net/api/"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func getStpToken(_ sender: UIButton, forEvent event: UIEvent) {
        let viewController = CardFieldViewController()
        viewController.delegate = self
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true, completion: nil)
    }
    @IBAction func payMoney(_ sender: Any) {
        if(self.strToken != ""){
            let params = ["stripetoken": strToken, "amount": nAmount, "currency":strCurrency,"description":strDescription] as [String : Any]
            //Get Response from Backend
            Alamofire.request(self.backendURL + "direct_pay", method:.post, parameters: params)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let json):
                        var response = json as? [String: AnyObject];
                        //If payment is success
                        if response!["success"] as! Bool{
                            let alert = UIAlertController(title: "Alert", message: "Payment Success", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                            //If payment is failed
                        else{
                            let alert = UIAlertController(title: "Alert", message: "Payment Failed", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    //If network issue or some connection error
                    case .failure( _):
                        let alert = UIAlertController(title: "Alert", message: "Payment Failed", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
            }
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "Token Not Ready Yet", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func createCustomer(_ sender: Any) {
        let strEmail : String = emailAddress.text!
        if(( strEmail != "" ) && (strToken != "")){
            let params = ["stripetoken": strToken, "email": strEmail, "description":strDescription] as [String : Any]
            //Get Response from Backend
            Alamofire.request(self.backendURL + "create_customer", method:.post, parameters: params)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let json):
                        var response = json as? [String: AnyObject];
                        print(response);
                        //If Create customer is success
                        if response!["success"] as! Bool{
                            let alert = UIAlertController(title: "Alert", message: "Create Customer Success", preferredStyle: UIAlertControllerStyle.alert)
                            self.strCustomerId = response!["customer"] as! String;
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                            //If Create customer is failed
                        else{
                            let alert = UIAlertController(title: "Alert", message: "Create Customer Failed", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    //If network issue or some connection error
                    case .failure( _):
                        let alert = UIAlertController(title: "Alert", message: "Create Customer Failed", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Not Enough to Create Customer.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func payAsCustomer(_ sender: Any) {
        print(strCustomerId);
        if(strCustomerId != ""){
            let params = ["customerid": strCustomerId, "amount": nAmount, "currency":strCurrency,"description":strDescription] as [String : Any]
            //Get Response from Backend
            Alamofire.request(self.backendURL + "customer_pay", method:.post, parameters: params)
                .responseJSON { responseJSON in
                    switch responseJSON.result {
                    case .success(let json):
                        var response = json as? [String: AnyObject];
                        //If payment is success
                        if response!["success"] as! Bool{
                            let alert = UIAlertController(title: "Alert", message: "Payment Success", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                            //If payment is failed
                        else{
                            let alert = UIAlertController(title: "Alert", message: "Customer Payment Failed1", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    //If network issue or some connection error
                    case .failure( _):
                        let alert = UIAlertController(title: "Alert", message: "Customer Payment Failed", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
            }
        }
        else{
            let alert = UIAlertController(title: "Alert", message: "No Customer Id.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    // MARK: CardFieldViewController Delegate
    func didFinishCardView(_ strToken: String) {
        self.strToken = strToken;
        print("Token",strToken);
    }
}


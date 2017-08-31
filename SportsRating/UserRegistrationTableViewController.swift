//
//  UserRegistrationTableViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 24/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class UserRegistrationTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!{
        didSet{
            //createAccountButton.layer.borderColor = UIColor.blue.cgColor
            //createAccountButton.layer.borderWidth = 1.0
            createAccountButton.layer.cornerRadius = 4.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.addDoneButtonToKeyboard(myAction:#selector(nameTextField.resignFirstResponder))
        emailAddressTextField.addDoneButtonToKeyboard(myAction:#selector(emailAddressTextField.resignFirstResponder))
        phoneNumberTextField.addDoneButtonToKeyboard(myAction:#selector(phoneNumberTextField.resignFirstResponder))
        
        /*nameTextField.text = "Amit"
        emailAddressTextField.text = "amit@gmail.com"
        phoneNumberTextField.text = "9971741478"*/
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    }
    
    func createAccount()  {
        guard let name = nameTextField.text, name.characters.count > 0
            else {
                CommonHelper.showAlertMessage(vc: self, title: "Error!!!", message: "Please enter a valid full name.")
                return
        }
        guard let emailAddress = emailAddressTextField.text, CommonHelper.isValidEmail(emailid: emailAddress)
            else {
                CommonHelper.showAlertMessage(vc: self, title: "Error!!!", message: "Please enter a valid email address.")
                return
        }
        guard let phoneNumber = phoneNumberTextField.text, phoneNumber.characters.count == 10
            else {
                CommonHelper.showAlertMessage(vc: self, title: "Error!!!", message: "Please enter a valid phone number.")
                return
        }
        
        let params = ["action":"UserRegistration","full_name":"\(name)","email":"\(emailAddress)","phone":"\(phoneNumber)","device_id":"NA","device_type":"iphone"] as [String:Any]
        
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        NetworkClient.shared.callAPI( params: params, success: { [weak self](response) in
            print(response)
            guard let strongSelf = self else{return}
            
            if let status = response["status"] as? Bool, status , let data = response["data"] as? [String:Any],let user = User(json: data) {
                
                let userObject = NSKeyedArchiver.archivedData(withRootObject: user)
                UserDefaults.standard.set(userObject, forKey: "userObject")
                UserDefaults.standard.synchronize()
                
                strongSelf.performSegue(withIdentifier: "goToOTPVerification", sender: nil)
            }
            else if let message = response["message"] as? String{
                CommonHelper.showAlertMessage(vc: strongSelf, title: "Error!!", message: message)
            }
            CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
            
        }) { (error) in
            print(error)
            CommonHelper.showAlertMessage(vc: self, title: "Network Error!!", message: "Could not connect to server.\n Please try again after sometime.")
            CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
            
        }
        
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
    @IBAction func createAccountBtnPressed(_ sender: Any) {
        createAccount()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
}


//
//  OTPVerificationTableViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 28/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class OTPVerificationTableViewController: UITableViewController {

    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var verifyOTPButton: UIButton!{
        didSet{
            //createAccountButton.layer.borderColor = UIColor.blue.cgColor
            //createAccountButton.layer.borderWidth = 1.0
            verifyOTPButton.layer.cornerRadius = 4.0
        }
    }
    
    var seconds = 10
    var timer = Timer()
    @IBOutlet weak var otpResendButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var changeMobileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        startTimer()
        otpTextField.addDoneButtonToKeyboard(myAction: #selector(otpTextField.resignFirstResponder))
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

        
    func startTimer()  {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self](timer) in
            
            guard let strongSelf = self else{return}
            strongSelf.seconds -= 1
            if strongSelf.seconds>=0{
                strongSelf.timerLabel.isHidden = false
                strongSelf.timerLabel.text = String(format:"00:%02i",strongSelf.seconds)
                strongSelf.otpResendButton.isEnabled = false
                strongSelf.changeMobileButton.isEnabled = false
            }
            else{
                strongSelf.timer.invalidate()
                strongSelf.timerLabel.isHidden = true
                strongSelf.otpResendButton.isEnabled = true
                strongSelf.changeMobileButton.isEnabled = true
                
            }
        })
    }
    
    @IBAction func otpResendPressed(_ sender: UIButton) {
        startTimer()
    }
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return false
    }
    
        @IBAction func changeMobileNoPressed(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
        }
    @IBAction func verifyOTPBtnPressed(_ sender: Any) {
        self.timer.invalidate()
        self.otpResendButton.isEnabled = true
        updateUserSportsPreferences()
    }
    
    func updateUserSportsPreferences()  {
        if let userSportsPriorities = UserDefaults.standard.data(forKey: "userSportsPriorities") {
            guard let userSportsPriorities = NSKeyedUnarchiver.unarchiveObject(with: userSportsPriorities as Data ) as? [String:Category]
                else{
                    return
            }
            guard let userObject = UserDefaults.standard.data(forKey: "userObject"), let user = NSKeyedUnarchiver.unarchiveObject(with: userObject as Data ) as? User
                else { return  }
            
            let params = ["action":"updatePriority","user_id":"\(user.user_id)","First_priority":"\(userSportsPriorities["first"]?.category_id ?? "")",  "Second_priority":"2","Third_priority":"3" ]//27
            CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
            
            NetworkClient.shared.callAPI(params: params,
                                         success: { [weak self](response) in
                                            print(response)
                                            guard let strongSelf = self else {return}
                                            
                                            if let status = response["status"] as? Bool,status,
                                                let data = response["data"] as? [String:Any],
                                                let user = User(json: data)
                                            {
                                                
                                                let userObject = NSKeyedArchiver.archivedData(withRootObject: user)
                                                UserDefaults.standard.set(userObject, forKey: "userObject")
                                                strongSelf.performSegue(withIdentifier: "goToDashboard", sender: nil)
                                                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                                            }
                                            else if let message = response["message"] as? String{
                                                CommonHelper.showAlertMessage(vc: strongSelf, title: "Error!!", message: message)
                                            }
                                            CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
                },
                                         failure: { (error) in
                                            CommonHelper.showAlertMessage(vc: self, title: "Network Error", message: error.localizedDescription)
                                            CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
            })
        }
    }
}

//
//  CategoryViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 22/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {
    
    var eventList:[Event] = []
    var eventType:String?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var parentNavigationController : UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.isHidden = true
        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        loadEventList()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func loadEventList() {
        guard let eventType = eventType else { return  }
        
        let params = ["action":"\(eventType)"] as [String:Any]
        CustomActivityIndicator.shared.showActivityIndicator(view: self.view)
        NetworkClient.shared.callAPI(params: params, success: { [weak self](response) in
            print(response)
            guard let strongSelf = self else{return}
            if let status = response["status"] as? Bool, status, let data = response["data"] as? [[String:Any]] {
                strongSelf.eventList = Event.Array(jsonObject: data)
                DispatchQueue.main.async {
                    strongSelf.messageLabel.isHidden = true
                    strongSelf.tableView.isHidden = false
                    strongSelf.tableView.reloadData()
                }
            }
            else if let message = response["message"] as? String{
                DispatchQueue.main.async {
                    strongSelf.messageLabel.isHidden = false
                    strongSelf.messageLabel.text = message
                    strongSelf.tableView.isHidden = true
                }
               
                //CommonHelper.showAlertMessage(vc: strongSelf, title: "Server Error!!!", message: message)
            }
            CustomActivityIndicator.shared.hideActivityIndicator(view: strongSelf.view)
        })
        { (error) in
            CommonHelper.showAlertMessage(vc: self, title: "Network Error!!!", message: error.localizedDescription)
            CustomActivityIndicator.shared.hideActivityIndicator(view: self.view)
        }
    }
}

extension CategoryViewController:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.eventList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MatchListTableViewCell", for: indexPath) as? MatchListTableViewCell else { return UITableViewCell() }
        cell.event = self.eventList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let eventDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EventDetailViewController") as? EventDetailViewController  else { return  }
        let event = self.eventList[indexPath.row]
        if let evnttype = eventType, evnttype.hasPrefix("upcoming") {
            eventDetailVC.event = event
        }
        
        eventDetailVC.title = "Match Details"
        eventDetailVC.eventType = eventType
        eventDetailVC.matchID = event.event_id
        self.parentNavigationController?.pushViewController(eventDetailVC, animated: true)
        
    }

}

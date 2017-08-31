//
//  SportsPriorityTableViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 24/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class SportsPriorityTableViewController: UITableViewController {
    
    var sportsPriorities:[String:Category] = [:]
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = UIColor(red: 81.0/255.0, green: 116.0/255.0, blue: 30.0/255.0, alpha: 1.0)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "goToCreateAccount", self.sportsPriorities.count == 0  {
            CommonHelper.showAlertMessage(vc: self, title: "Error!!!", message: "Please set at least one sports preferences.")
            return false
        }
        
        let userSportsPriorities  = NSKeyedArchiver.archivedData(withRootObject: sportsPriorities)
        UserDefaults.standard.set(userSportsPriorities, forKey: "userSportsPriorities")
        
        return true
    }
    
   
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        
        print("unwindToVC1")
        tableView.reloadData()
    
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).backgroundView?.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        switch section {
        case 0:
            return "Primary Sports Preferences"
        case 1:
            return "Secondary Sports Preferences"
        case 2:
            return "Related Sports Preferences"
        default:
            return ""
           
        }
        
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseSportTableViewCell", for: indexPath) as? ChooseSportTableViewCell
        else{
            return UITableViewCell()
        }
        var key = ""
        switch indexPath.section {
        case 0:
            key = "first"
        case 1:
            key = "second"
        case 2:
            key = "third"
        default:
            break
        }
        if let category = sportsPriorities[key] {
            cell.selectedSportslabel.text = category.name
        }
        
        cell.selectionStyle = .none
        
        // Configure the cell...

        return cell
    }
   

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let sportsCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "SportsCategoryViewController") as? SportsCategoryViewController else { return  }
        sportsCategoryVC.selectedSportsCategories = sportsPriorities
        var key = ""
        switch indexPath.section {
        case 0:
            key = "first"
        case 1:
            key = "second"
        case 2:
            key = "third"
        default:
            break
        }
        sportsCategoryVC.selectedSportsPriorityRow = key
        self.present(sportsCategoryVC, animated: true, completion: nil)
        
    }
   
}

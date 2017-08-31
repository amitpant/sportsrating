//
//  SportsCategoryViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 24/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class SportsCategoryViewController: UIViewController {

    var selectedSportsCategories:[String:Category] = [:]
    var selectedSportsPriorityRow = ""
    
    var sportsCategories:[Category] = []
    
    var filterCategoryList = [Category]()
    
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        let width =  collectionView.frame.width/2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width - 20, height: width  )
        loadCategories()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func loadCategories()  {
        let params = ["action":"Cat"] as [String:Any]
        
        NetworkClient.shared.callAPI(params: params, success: {[weak self] (response) in
            print(response)
            guard let strongSelf = self else{return}
            
            if let status = response["status"] as? Bool, status, let data = response["data"] as? [[String:Any]]{
                let sportsCategories = Category.array(jsonObject:data)
                
                for cat in sportsCategories{
                    var iscontain = false
                    for selCat in strongSelf.selectedSportsCategories{
                        let cate = selCat.value
                        if cate.category_id == cat.category_id{
                            iscontain = true
                        }
                    }
                    if !iscontain{
                        strongSelf.sportsCategories.append(cat)
                    }
                    
                    
                }
                /*for cat in strongSelf.selectedSportsCategories{
                   
                }
                let m = sportsCategories.flatMap { userId in selectedSportsCategories.filter { $0[0]["name"] == userId }.first }
                let filteredUsers = sportsCategories.flatMap { name in
                    selectedSportsCategories { $0["name"] != name }
                }
                print(filteredUsers)
                strongSelf.sportsCategories = filteredUsers*/
                strongSelf.collectionView.reloadData()
            }
            else if let message = response["message"] as? String{
                print(message)
                CommonHelper.showAlertMessage(vc: strongSelf, title: "Server error!!!", message: message)
            }
            
            
        }) { (error) in
            print(error)
            CommonHelper.showAlertMessage(vc: self, title: "Network error!!!", message: error.localizedDescription)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension SportsCategoryViewController:UICollectionViewDataSource{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.filterCategoryList.count>0 {
            return self.filterCategoryList.count
        }
        else{
            return self.sportsCategories.count
        }
       
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SportsCategoryCollectionViewCell", for: indexPath) as? SportsCategoryCollectionViewCell
            else { return UICollectionViewCell() }
        var category:Category?
        if self.filterCategoryList.count>0 {
            category = self.filterCategoryList[indexPath.item]
        }else{
            category = sportsCategories[indexPath.item]
        }
        collectionCell.category = category
        
        return collectionCell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let sportsPriorityVC = segue.destination as? SportsPriorityTableViewController else { return  }
        sportsPriorityVC.sportsPriorities = selectedSportsCategories
    }
}

extension SportsCategoryViewController:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedSportsCategories[self.selectedSportsPriorityRow] = sportsCategories[indexPath.row]
        
         performSegue(withIdentifier: "unwindSegueToVC1", sender: self)
    }
}
extension SportsCategoryViewController:UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.filterCategoryList = sportsCategories.filter{$0.name.range(of: searchText) != nil}
        //if self.filterCategoryList.count>0 {
            collectionView.reloadData()
        //}
        
    }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        return true
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}




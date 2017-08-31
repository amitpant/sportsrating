//
//  ViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 22/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {

    var menuCategories:[String] = ["UPCOMING","LIVE","FINISHED"]
    var pageMenu : CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        setUpPageMenu()
    }

    func setUpPageMenu()  {
        
        for category in menuCategories {
            guard let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryViewController") as? CategoryViewController else {
                return
            }
            /*inviteCartVC.delegate =  self*/
            categoryVC.parentNavigationController = self.navigationController
            categoryVC.title = category
            categoryVC.eventType = "\(category.lowercased())Matches"
            controllerArray.append(categoryVC)
        }
        
        let parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0.0),
            //.menuItemWidth(150.0),
            .useMenuLikeSegmentedControl(true),
            .menuItemSeparatorPercentageHeight(1.0),
            //.viewBackgroundColor (CommonHelper.menuBGColor),
            .scrollMenuBackgroundColor (CommonHelper.menuBGColor),
            .selectionIndicatorColor (CommonHelper.menuSelectedTextColor),
            .selectedMenuItemLabelColor (UIColor.white),
            .unselectedMenuItemLabelColor (UIColor.darkGray),
            .menuItemSeparatorColor (UIColor.black),
            .menuItemSeparatorRoundEdges (true),
            .selectionIndicatorHeight (3.0)
           
        ]
        
      
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame:CGRect(x: 0.0, y: 64.0, width: self.view.frame.width, height: self.view.frame.height - 64.0) , pageMenuOptions: parameters)
        
        pageMenu!.delegate = self
        self.view.addSubview(pageMenu!.view)
    }


}

extension DashboardViewController:CAPSPageMenuDelegate{
    func willMoveToPage(_ controller: UIViewController, index: Int){}
    
    func didMoveToPage(_ controller: UIViewController, index: Int){}
}


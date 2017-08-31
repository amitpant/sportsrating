//
//  WelcomeViewController.swift
//  SportsRating
//
//  Created by Maxtra Technologies P LTD on 22/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - Injections
    
    @IBOutlet weak var pageControl: UIPageControl!
    var welcomePageViewController: WelcomePageViewController? {
        didSet {
            welcomePageViewController?.welcomeDelegate = self
        }
    }
   
    @IBOutlet weak var joinNowButton: UIButton!{
        didSet{
            joinNowButton.layer.cornerRadius = 4.0
            joinNowButton.layer.borderColor = UIColor.white.cgColor
            joinNowButton.layer.borderWidth = 1.0
        }
    }
    
    public override func viewDidLoad() {
        
        //getStartedButton.isHidden = true
        //pageControl.addTarget(self, action: #selector(WelcomeViewController.didChangePageControlValue), for: .valueChanged)
    }
    
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let welcomePageViewController = segue.destination as? WelcomePageViewController {
            self.welcomePageViewController = welcomePageViewController
        }
    }
    @IBAction func didChangePageControlValue(_ sender: UIPageControl) {
        welcomePageViewController?.scrollToViewController(index: pageControl.currentPage)
    }

   
}


extension WelcomeViewController:WelcomePageViewControllerDelegate{
    
    func welcomePageViewController(_ welcomePageViewController: WelcomePageViewController, didUpdatePageCount count: Int) {
        pageControl.numberOfPages = count
    }
    
    func welcomePageViewController(_ welcomePageViewController: WelcomePageViewController, didUpdatePageIndex index: Int) {
        pageControl.currentPage = index
    }
}

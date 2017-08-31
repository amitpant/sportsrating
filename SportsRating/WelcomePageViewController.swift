//
//  WelcomePageViewController.swift
//  I-Helper
//
//  Created by Maxtra Technologies P LTD on 02/08/17.
//  Copyright © 2017 Maxtra Technologies P LTD. All rights reserved.
//

import UIKit

protocol WelcomePageViewControllerDelegate: class {
    

    func welcomePageViewController(_ welcomePageViewController: WelcomePageViewController, didUpdatePageCount count: Int)
    
 
    func welcomePageViewController(_ welcomePageViewController: WelcomePageViewController, didUpdatePageIndex index: Int)
    
}
class WelcomePageViewController: UIPageViewController {
    
    weak var welcomeDelegate: WelcomePageViewControllerDelegate?
    
    // MARK: - Instance Properties
    public let childIdentifiers = ["Page1", "Page2", "Page3","Page4","Page5"]
    internal lazy var childPages: [UIViewController] = { [unowned self] in
        return self.childIdentifiers.map { identifier in
            return self.storyboard!.instantiateViewController(withIdentifier: identifier)
        }
        }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        welcomeDelegate?.welcomePageViewController(self, didUpdatePageCount: childPages.count)
        setupPager()
       
    }
    
    private func setupPager() {
        dataSource = self
        delegate = self
        setViewControllers([childPages.first!], direction: .forward, animated: false, completion: nil)
    }
    
    /**
     Scrolls to the next view controller.
     */
    func scrollToNextViewController() {
        if let visibleViewController = viewControllers?.first,
            let nextViewController = pageViewController(self,
                                                        viewControllerAfter: visibleViewController) {
            scrollToViewController(nextViewController)
        }
    }
    
    /**
     Scrolls to the view controller at the given index. Automatically calculates
     the direction.
     
     - parameter newIndex: the new index to scroll to
     */
    func scrollToViewController(index newIndex: Int) {
        if let firstViewController = viewControllers?.first,
            let currentIndex = childPages.index(of: firstViewController) {
            let direction: UIPageViewControllerNavigationDirection = newIndex >= currentIndex ? .forward : .reverse
            let nextViewController = childPages[newIndex]
            scrollToViewController(nextViewController, direction: direction)
        }
    }
    
//    fileprivate func newColoredViewController(_ color: String) -> UIViewController {
//        return UIStoryboard(name: "Main", bundle: nil) .
//            instantiateViewController(withIdentifier: "\(color)ViewController")
//    }
    
    /**
     Scrolls to the given 'viewController' page.
     
     - parameter viewController: the view controller to show.
     */
    fileprivate func scrollToViewController(_ viewController: UIViewController,
                                            direction: UIPageViewControllerNavigationDirection = .forward) {
        setViewControllers([viewController],
                           direction: direction,
                           animated: true,
                           completion: { (finished) -> Void in
                            // Setting the view controller programmatically does not fire
                            // any delegate methods, so we have to manually notify the
                            // 'tutorialDelegate' of the new index.
                            self.notifyWelcomeDelegateOfNewIndex()
        })
    }
    
    /**
     Notifies '_tutorialDelegate' that the current page index was updated.
     */
    fileprivate func notifyWelcomeDelegateOfNewIndex() {
        if let firstViewController = viewControllers?.first,
            let index = childPages.index(of: firstViewController) {
            welcomeDelegate?.welcomePageViewController(self, didUpdatePageIndex: index)
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = childPages.index(of: viewController), currentIndex > 0 else {
            return nil
        }
        return childPages[currentIndex - 1]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController,
                                   viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = childPages.index(of: viewController),
            currentIndex < (childPages.count - 1) else { return nil }
        return childPages[currentIndex + 1]
    }
    
 
}
extension WelcomePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        notifyWelcomeDelegateOfNewIndex()
    }
    
}

//
//  FeedContainerViewController.swift
//  
//
//  Created by Jordan Coppert on 12/3/17.
//

import UIKit

class FeedContainerViewController: UIViewController {

    enum SlideOutState {
        case bothCollapsed
        case leftPanelExpanded
        case rightPanelExpanded
    }
    
    var centerNavigationController: UINavigationController!
    var centerViewController: UIViewController!
    var currentState: SlideOutState = .bothCollapsed
    var isFeed:Bool!
    var leftViewController: SlideMenuViewController?
    let centerPanelExpandedOffset: CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centerViewController = CenterViewController()
        if(isFeed){
            centerViewController = centerViewController as! FeedViewController
        } else {
            centerViewController = centerViewController as! SocialViewController
        }
        centerViewController.delegate = self
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        
        centerNavigationController.didMove(toParentViewController: self)
    }
    
    
    
}

extension FeedContainerViewController: CenterViewControllerDelegate {
    
    func toggleLeftPanel() {
        let notAlreadyExpanded = (currentState != .leftPanelExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func toggleRightPanel() {
    }
    
    func addLeftPanelViewController() {
        guard leftViewController == nil else { return }
        
        //Initailize members and the nset
        let vc = SlideMenuViewController()
        //vc.animals = Animal.allCats()
        addChildSidePanelController(vc)
        leftViewController = vc
        
    }
    
    func addChildSidePanelController(_ sidePanelController: SlideMenuViewController) {
        
        view.insertSubview(sidePanelController.view, at: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMove(toParentViewController: self)
    }
    
    func animateLeftPanel(shouldExpand: Bool) {
        if shouldExpand {
            currentState = .leftPanelExpanded
            animateCenterPanelXPosition(
                targetPosition: centerNavigationController.view.frame.width - centerPanelExpandedOffset)
            
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .bothCollapsed
                self.leftViewController?.view.removeFromSuperview()
                self.leftViewController = nil
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseInOut, animations: {
                        self.centerNavigationController.view.frame.origin.x = targetPosition
        }, completion: completion)
    }
    
}

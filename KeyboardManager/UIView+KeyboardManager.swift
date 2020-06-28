//
//  UIView+KeyboardManager.swift
//  GomeSwift
//
//  Created by caoye on 2020/5/22.
//  Copyright © 2020 caoye. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    @objc func viewContainingController() -> UIViewController? {
         var nextResponder: UIResponder? = self
         
         repeat {
             nextResponder = nextResponder?.next
             if let viewController = nextResponder as? UIViewController {
                 return viewController
             }
             
         } while nextResponder != nil
         
         return nil
    }
       
       
   @objc func parentContainerViewController() -> UIViewController? {
       
       var matchController = viewContainingController()
       var parentContainerViewController: UIViewController?

       if var navController = matchController?.navigationController {
           
           while let parentNav = navController.navigationController {
               navController = parentNav
           }
           
           var parentController: UIViewController = navController

           while let parent = parentController.parent,
               (parent.isKind(of: UINavigationController.self) == false &&
                   parent.isKind(of: UITabBarController.self) == false &&
                   parent.isKind(of: UISplitViewController.self) == false) {
                    parentController = parent
           }

           if navController == parentController {
               parentContainerViewController = navController.topViewController
           } else {
               parentContainerViewController = parentController
           }
       } else if let tabController = matchController?.tabBarController {
           
           if let navController = tabController.selectedViewController as? UINavigationController {
               parentContainerViewController = navController.topViewController
           } else {
               parentContainerViewController = tabController.selectedViewController
           }
       } else {
           while let parentController = matchController?.parent,
               (parentController.isKind(of: UINavigationController.self) == false &&
                   parentController.isKind(of: UITabBarController.self) == false &&
                   parentController.isKind(of: UISplitViewController.self) == false) {
                   matchController = parentController
           }

           parentContainerViewController = matchController
       }
       
       let finalController = parentContainerViewController
       
       return finalController
   }
    
    
    /// 是UIAlertController 上的文本编辑器
    internal func isAlertViewTextField() -> Bool {
           
       var alertViewController: UIResponder? = viewContainingController()
       var isAlertViewTextField = false
       
       while let controller = alertViewController, isAlertViewTextField == false {
           if controller.isKind(of: UIAlertController.self) {
               isAlertViewTextField = true
               break
           }
        alertViewController = alertViewController?.next
       }
       
       return isAlertViewTextField
   }
    
}

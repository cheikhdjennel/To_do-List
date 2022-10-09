//
//  ViewControllerExtension.swift
//  To-do lists
//
//  Created by Cheikh on 8/10/2022.
//

import Foundation
import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    //MARK: - Add and remove a child VC
    
    func addChildVC(childViewController child : UIViewController, toView containerView : UIView){
        let matchParentConstraints = [
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ]
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        self.addChild(child)
        containerView.addSubview(child.view)
        NSLayoutConstraint.activate(matchParentConstraints)
        child.didMove(toParent: self)
    }
    
    func removeChildVC(childViewController child : UIViewController){
        child.willMove(toParent: nil)
        child.view.removeFromSuperview()
        child.removeFromParent()
    }
    
    
    
}



//
//  YNExtencions.swift
//  PictureDrag
//
//  Created by Ulian on 22.05.2023.
//

import UIKit

extension UIViewController {
    class func controller<T: UIViewController>(inStoryboard storyboard : UIStoryboard) -> T {
        return storyboard.instantiateViewController(withIdentifier: String(describing: self)) as! T
    }
}

extension UIView {
    // MARK: -
    // MARK: Add/Inactivate constraints
//    func addSizeConstraints(width : Int, height : Int) {
        //        newView.translatesAutoresizingMaskIntoConstraints = false
        //            let views = ["newView": newView]
        //            let widthConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[newView(100)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        //            let heightConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[newView(100)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        
        //            view.addConstraints(widthConstraints)
        //            view.addConstraints(heightConstraints)
//    }
    
    func centerYInView(_ view : UIView) {
        let verticalConstraint = NSLayoutConstraint(item: self,
                                               attribute: .centerY,
                                               relatedBy: .equal,
                                                  toItem: view,
                                               attribute: .centerY,
                                              multiplier: 1,
                                                constant: 0)
        view.addConstraint(verticalConstraint)
    }
    
    func addLeadConstraint(constant : CGFloat,
                           relation : NSLayoutConstraint.Relation,
                        inView view : UIView)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        let leadConstraint = NSLayoutConstraint(item: self,
                                           attribute: .leadingMargin, //NSLayoutConstraint.Attribute.centerX,
                                           relatedBy: relation, // NSLayoutConstraint.Relation.equal
                                              toItem: view,
                                           attribute: .leadingMargin,
                                          multiplier: 1,
                                            constant: constant)
        view.addConstraint(leadConstraint)
    }
    
    func addTrailConstraint(constant : CGFloat,
                            relation : NSLayoutConstraint.Relation,
                         inView view : UIView)
    {
        self.translatesAutoresizingMaskIntoConstraints = false
        let trailConstraint = NSLayoutConstraint(item: self,
                                            attribute: .trailingMargin,
                                            relatedBy: relation,
                                               toItem: view,
                                            attribute: .trailingMargin,
                                           multiplier: 1,
                                             constant: constant)
        view.addConstraint(trailConstraint)
    }
    
    func addTopConstraint(constant : CGFloat,
                          relation : NSLayoutConstraint.Relation,
                       inView view : UIView)
    {
//        self.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self,
                                          attribute: .topMargin,
                                          relatedBy: relation,
                                             toItem: view,
                                          attribute: .topMargin,
                                         multiplier: 1,
                                           constant: constant)
        view.addConstraint(topConstraint)
    }
    
    func addBottomConstraint(constant : CGFloat,
                             relation : NSLayoutConstraint.Relation,
                          inView view : UIView)
    {
//        self.translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = NSLayoutConstraint(item: self,
                                             attribute: .bottomMargin,
                                             relatedBy: relation,
                                                toItem: view,
                                             attribute: .bottomMargin,
                                            multiplier: 1,
                                              constant: constant)
        view.addConstraint(bottomConstraint)
    }
    
    #warning("check if it works !!!")
    func inactivateLayoutMarginConstraints() {
        if let superview = self.superview {
            for constraint in superview.constraints {
                if let layoutGuide = constraint.firstItem as? UILayoutGuide,
                   layoutGuide === self.layoutMarginsGuide {
                    constraint.isActive = false
                }
                if let layoutGuide = constraint.secondItem as? UILayoutGuide,
                   layoutGuide === self.layoutMarginsGuide {
                    constraint.isActive = false
                }
            }
        }
    }
}

extension UIButton {
    // override setSelected && setHighlighted to change color on touch
    
    
}

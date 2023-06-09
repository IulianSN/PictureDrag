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
    
    // better to use centerYAnchor.constraint(equalTo: touchView.centerYAnchor).isActive = true
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
    
    // MARK: -
    // MARK: Corner radius extencion
    
    // this solution could have problems with rotating or for dinamically changing size views
//    func cornerRadii(_ radii : CGSize, forCorners corners : UIRectCorner) {
//        let path = UIBezierPath(roundedRect: self.bounds,
//                                byRoundingCorners: corners, // [.topLeft, .bottomLeft]
//                                cornerRadii: radii) //CGSize(width: 4, height: 4))
//        let maskLayer = CAShapeLayer()
//        maskLayer.path = path.cgPath
//        self.layer.mask = maskLayer
//    }
    
    // and this even more simple and works better
    func roundCorners(_ corners : CACornerMask, withRadius radius : CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius // 6.0
        self.layer.maskedCorners = corners //[.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }
}

extension UIButton {
    // override setSelected && setHighlighted to change color on touch
    
    
}

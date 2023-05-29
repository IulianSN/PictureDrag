//
//  YNNoImageButton.swift
//  PictureDrag
//
//  Created by Ulian on 22.05.2023.
//

import UIKit

//@IBDesignable
class YNNoImageButton : UIView {
    // MARK: -
    // MARK: Private properties
    
    private var nameLabel : UILabel?
    private var touchEndedCompletion : YNButtonTapCompletion?
    private var isTouchInSelf = false
    private var tapTimestamp : TimeInterval = 0
    
    // MARK: -
    // MARK: Public properties
    
    var title = "" {
        didSet {
            nameLabel?.text = title
        }
    }
    
    // MARK: -
    // MARK: View life cycle
    
    override init(frame : CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder : NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    // MARK: -
    // MARK: Public functions
    
    func onTap(_ closure : @escaping YNButtonTapCompletion) {
        touchEndedCompletion = closure
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false // is it works ??
        
        layer.borderWidth = 2.0
        layer.borderColor = appDesign.borderColor.cgColor
        
        layer.masksToBounds = true
        layer.cornerRadius = 5.0
        
        let touchView = YNTouchView.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        // set background color && color on touch if needed
        touchView.onTap({[weak self] _ in
            guard let self = self else {
                assertionFailure("YNNoImageButton: unexpectedly found window to be nil")
                return
            }
            let currentTimestamp = NSDate().timeIntervalSince1970
            let lastTapInterval = currentTimestamp - self.tapTimestamp
            if lastTapInterval > 1.0 { // prevent fast tap
                self.tapTimestamp = currentTimestamp
                self.touchEndedCompletion?(self)
            }
        })
        self.addSubview(touchView)
        touchView.addLeadConstraint(constant: 0, relation: .equal, inView: self)
        touchView.addTrailConstraint(constant: 0, relation: .equal, inView: self)
        touchView.addTopConstraint(constant: 0, relation: .equal, inView: self)
        touchView.addBottomConstraint(constant: 0, relation: .equal, inView: self)
        
        self.isUserInteractionEnabled = true

// in 'debug view hierarchy' UILayoutGuide are absent, but in console there is an error with UILayoutGuide constraints
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        touchView.addSubview(label)
//        label.layoutMargins = .zero
//        label.inactivateLayoutMarginConstraints() // helps ??
//        self.updateConstraintsIfNeeded()
        


#warning("Use custom font for label !!!")

        label.centralizeInView(touchView)
        label.addLeadConstraint(constant: 4, relation: .greaterThanOrEqual, inView: touchView)
        label.addTrailConstraint(constant: 4, relation: .greaterThanOrEqual, inView: touchView)
        label.text = "Test text asdgf asdf asgf asdfg sdfgsd sdgs dg d" // TMP, remove !!!
        nameLabel = label
    }
}
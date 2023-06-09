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
    private var touchView : YNTouchView?
    
    // MARK: -
    // MARK: Public properties
    
    var title = "" {
        didSet {
            nameLabel?.text = title
        }
    }
    
    var colorOnTouch : UIColor? {
        didSet {
            if let color = colorOnTouch {
                self.touchView?.colorOnTouch = color
            }
        }
    }
    
    var disabled = false {
        didSet {
            disableButton(disabled)
        }
    }
    
    var colorEnabled = UIColor.systemGreen
    var colorDisabled = UIColor.systemGray6
    var textColor = UIColor.black
    
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
    
    func setupColors(tintColor : UIColor,
                     textColor : UIColor = UIColor.black,
                     touchColor : UIColor,
                     disabledColor : UIColor)
    {
        self.colorOnTouch = touchColor
        self.colorEnabled = tintColor
        self.colorDisabled = disabledColor
        self.textColor = textColor
    }
    
    func onTap(_ closure : @escaping YNButtonTapCompletion) {
        touchEndedCompletion = closure
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func setupView() {
        self.layer.borderWidth = 2.0
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5.0
        
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
        self.touchView = touchView

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        
        label.textAlignment = .center
        touchView.addSubview(label)
        
#warning("Use custom font for label !!! OR better custom label")
        // leftAnchor && rightAnchor does not work properly for some reason
        label.addLeadConstraint(constant: 4, relation: .equal, inView: touchView)
        label.addTrailConstraint(constant: 4, relation: .equal, inView: touchView)
        
        label.centerYAnchor.constraint(equalTo: touchView.centerYAnchor).isActive = true
//        label.centerYInView(touchView)
        nameLabel = label
        
        self.disableButton(self.disabled)
    }
    
    private func disableButton(_ disable : Bool) {
        let textColor = disable ? self.colorDisabled : self.textColor
        let frameColor = disable ? self.colorDisabled : self.colorEnabled

        self.layer.borderColor = frameColor.cgColor
        self.nameLabel?.textColor = textColor
        
        self.isUserInteractionEnabled = !disable
    }
}

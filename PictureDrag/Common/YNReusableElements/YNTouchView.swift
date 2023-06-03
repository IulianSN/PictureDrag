//
//  YNTouchView.swift
//  PictureDrag
//
//  Created by Ulian on 26.05.2023.
//

import UIKit

class YNTouchView : UIView {
    // MARK: -
    // MARK: Private properties
    
    private var touchEndedCompletion : YNButtonTapCompletion?
    private var isTouchInSelf = false
    
    // MARK: -
    // MARK: Public properties
    
    var colorOnTouch = UIColor.systemGray6
    var colorNormal = UIColor.systemBackground {
        didSet {
            self.backgroundColor = colorNormal
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
        self.isUserInteractionEnabled = true
        
        // ad extra setup if needed
    }
    
    private func touchEndedSuccessfully() {
        touchEndedCompletion?(self)
    }
    
    private func touchEnded() {
        self.backgroundColor = self.colorNormal
        if isTouchInSelf {
            touchEndedSuccessfully()
        }
    }
    
    // MARK: -
    // MARK: Touches events functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchInSelf = true
        self.backgroundColor = self.colorOnTouch
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnded()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchEnded()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentTouchPoint = touches.first?.location(in: self) ?? CGPoint(x: 1, y: 1)
        if !self.bounds.contains(currentTouchPoint) { // touch cancelled, if stopped outside self
            isTouchInSelf = false
            return
        }
        isTouchInSelf = true
    }
}

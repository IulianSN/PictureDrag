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
    
    private let pressTimeInterval = 0.8
    private var touchEndedCompletion : YNButtonTapCompletion?
    private var pressEndedCompletion : YNButtonTapCompletion?
    private var isTouchInSelf = false
    private var touchTimeInterval : TimeInterval?
    
    // MARK: -
    // MARK: Public properties
    
    var colorOnTouch = UIColor.clear
    var colorNormal = UIColor.clear {
        didSet {
            self.backgroundColor = colorNormal
        }
    }
    var supportPressEvent = false
    
    
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
    
    func onPress(_ closure : @escaping YNButtonTapCompletion) {
        pressEndedCompletion = closure
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
    
    private func pressEndedSuccessfully() {
        pressEndedCompletion?(self)
    }
    
    private func touchEnded() {
        self.backgroundColor = self.colorNormal
        if isTouchInSelf {
            if supportPressEvent && self.touchTimeInterval != nil {
                let currentInterval = Date().timeIntervalSince1970
                if currentInterval - self.touchTimeInterval! > self.pressTimeInterval { // press time
                    self.touchTimeInterval = nil
                    self.pressEndedSuccessfully()
                    return
                }
            }
            self.touchEndedSuccessfully()
        }
    }
    
    // MARK: -
    // MARK: Touches events functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if supportPressEvent {
            self.touchTimeInterval = Date().timeIntervalSince1970
            // save timestamp
        }
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

//
//  YNDragableView.swift
//  PictureDrag
//
//  Created by Ulian on 11.06.2023.
//

import UIKit

class YNDragableView : UIView {
    
    private var lastTouchPoint : CGPoint?
    private var touchMoveClosure : YNTouchMoveClosure?
    
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
    
    func onTouchMove(_ closure : @escaping YNTouchMoveClosure) {
        self.touchMoveClosure = closure
    }
    
    // MARK: -
    // MARK: Private functions
    
    private func setupView() {
        self.isUserInteractionEnabled = true
        
        // ad extra setup if needed
    }
    
    // MARK: -
    // MARK: Touches events functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastTouchPoint = touches.first?.location(in: self.superview)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastTouchPoint = nil
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.lastTouchPoint = nil
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let currentLocation = touches.first?.location(in: self.superview) else {
            print("touch has no location: \(String(describing: touches.first))")
            return
        }
        guard let lastPoint = self.lastTouchPoint else {
            self.lastTouchPoint = currentLocation
            print("lastTouchPoint was not set in touchesBegan")
            return
        }
        let yDelta = currentLocation.y - lastPoint.y
        let xDelta = currentLocation.x - lastPoint.x
        if fabsf(Float(yDelta)) > 3.0
            || fabsf(Float(xDelta)) > 3.0
        {
            print("new point: \(currentLocation)")
            let point = CGPoint(x: xDelta, y: yDelta)
            self.lastTouchPoint = currentLocation
            self.touchMoveClosure?(point)
        }
    }
}

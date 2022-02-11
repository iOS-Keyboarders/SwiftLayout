//
//  Layout.swift
//  
//
//  Created by oozoofrog on 2022/01/26.
//

import Foundation
import UIKit

public protocol Layout: CustomDebugStringConvertible {
    func prepareSuperview(_ superview: UIView?)
    func attachSuperview()
    func detachFromSuperview()
   
    func prepareConstraints()
    func activeConstraints()
    func deactiveConstraints()
}

extension Layout {
    
    public func active() -> Deactivable {
        return Deactivation(self)
    }
    
}

extension Array: Layout where Self.Element == Layout {}

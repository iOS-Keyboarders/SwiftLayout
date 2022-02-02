//
//  ConstraintLayout.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import Foundation
import UIKit

public struct LayoutConstraint<Layoutable, Constraintable>: Constraint where Layoutable: Layout, Constraintable: Constraint {
    
    let layout: Layoutable
    let constraint: Constraintable
    
    public var constraints: [NSLayoutConstraint] { [] }
    
    public func active() -> AnyDeactivatable {
        layout.active()
    }
    
    public func constraints(with view: UIView) -> [NSLayoutConstraint] {
        constraint.constraints(with: view)
    }
}
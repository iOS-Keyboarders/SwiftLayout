//
//  UIView+Layoutable.swift
//  
//
//  Created by maylee on 2022/01/29.
//

import Foundation
import UIKit

public protocol UIViewContainable {
    associatedtype V: UIView
    var view: V { get }
}
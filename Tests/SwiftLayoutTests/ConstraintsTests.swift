//
//  ConstraintsTests.swift
//  
//
//  Created by oozoofrog on 2022/02/02.
//

import XCTest
@testable import SwiftLayout

class ConstraintsTests: XCTestCase {

    var deactivatable: AnyDeactivatable?
    
    var root = UIView().viewTag.root
    var child = UIView().viewTag.child
    
    override func setUpWithError() throws {
        root = UIView().viewTag.root
        child = UIView().viewTag.child
    }

    override func tearDownWithError() throws {
        deactivatable = nil
    }

    func testTypeOfConstraints() {
        let layout: some Layout = root {
            child
        }
        
        let top: some Constraint = layout.constraint {
            child.topAnchor // equal to topAnchor of root
        }
        
        XCTAssertEqual(typeString(of: top), "LayoutConstraint<SuperSubLayout<UIView, UIView>, Array<NSLayoutYAxisAnchor>>")
    }
    
    func testConstraintTop() {
        let layout: some Layout = root {
            child
        }
        
        let constraint: some Constraint = layout.constraint {
            child.topAnchor // equal to topAnchor of root
        }
        
        deactivatable = constraint.active()
        
        XCTAssertEqual(child.superview, root)
        
        let constraints = child.constraints
        XCTAssertEqual(constraints.count, 1)
        let top = constraints.first
        XCTAssertEqual(String(describing: top?.firstItem), String(describing: child))
        XCTAssertEqual(String(describing: top?.secondItem), String(describing: root))
        XCTAssertEqual(top?.firstAttribute, .top)
        XCTAssertEqual(top?.secondAttribute, .top)
        XCTAssertEqual(top?.relation, .equal)
        XCTAssertEqual(top?.constant, 0.0)
        XCTAssertEqual(top?.multiplier, 1.0)
    }

    
}
//
//typealias Attribute = NSLayoutConstraint.Attribute
//typealias Relation = NSLayoutConstraint.Relation
//
//func XCTAssertConstraint(_ constraint: NSLayoutConstraint,
//                         first: ConstraintPart,
//                         second: ConstraintPart?,
//                         relation: Relation = .equal, file: StaticString = #file, line: UInt = #line) where FirstItem: NSObjectProtocol, SecondItem: NSObjectProtocol {
//    guard constraint.relation == relation else {
//        XCTFail("relation: constraint.\(constraint.relation) != \(relation)", file: file, line: line)
//        return
//    }
//    if let firstItem = constraint.firstItem {
//        guard first.item.isEqual(firstItem) else {
//            XCTFail("first item: constraint.\(firstItem) != \(first.item)", file: file, line: line)
//            return
//        }
//        guard first.attribute == constraint.firstAttribute else {
//            XCTFail("first attribute: constraint.\(constraint.firstAttribute) != \(first.attribute)", file: file, line: line)
//            return
//        }
//    } else {
//        XCTFail("first item is nil", file: file, line: line)
//    }
//    if let second = second {
//        if let secondItem = constraint.secondItem {
//            guard second.item.isEqual(secondItem) else {
//                XCTFail("first item: constraint.\(secondItem) != \(second.item)", file: file, line: line)
//                return
//            }
//            guard second.attribute == constraint.secondAttribute else {
//                XCTFail("first attribute: constraint.\(constraint.secondAttribute) != \(second.attribute)", file: file, line: line)
//                return
//            }
//        } else {
//            XCTFail("second item is nil", file: file, line: line)
//        }
//    }
//}
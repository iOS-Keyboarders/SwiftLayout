import XCTest
import UIKit
@testable import SwiftLayout
import SwiftUI

final class SwiftLayoutTests: XCTestCase {
    
    let root = UIView().tag.root
    let yellow = UIView().tag.yellow
    let green = UIView().tag.green
    let red = UIView().tag.red
    let blue = UIView().tag.blue
    
    func testViewHierarchy() throws {
        context("root 뷰 밑에 yellow뷰가 있을 때") {
            let expect =  _LayoutTree(up: nil,
                                      element: _LayoutElement(view: root),
                                      fork: _LayoutFork(view: yellow))
            let result = root.layout {
                yellow
            }.active()
            
            XCTAssertEqual(result.debug.debugDescription, expect.debug.debugDescription, "\n\(result.debug.debugDescription)\n\(expect.debug.debugDescription)\n")
            
            XCTAssertEqual(yellow.superview, root)
        }
        
        context("root 밑에 yellow, green 뷰가 있을 때") {
            let expect =  _LayoutTree(up: nil,
                                      element: _LayoutElement(view: root),
                                      fork: _LayoutFork(branches: [yellow, green]))
            let result = root.layout {
                yellow
                green
            }.active()
            
            XCTAssertEqual(result.debug.debugDescription, expect.debug.debugDescription, "\n\(result.debug.debugDescription)\n\(expect.debug.debugDescription)\n")
            
            XCTAssertEqual(root.subviews, [yellow, green])
        }
        
        context("root 밑에 yellow, yellow 밑에 blue뷰 구조를 직접 생성") {
            
            var yellowTree = _LayoutTree(element: yellow.element,
                                         fork: _LayoutFork(view: blue))
            var rootTree = _LayoutTree(element: root.element,
                                       fork: _LayoutFork(branches: [yellowTree]))
            
            var result = rootTree.active()
            
            XCTAssertNil(rootTree.up)
            XCTAssertEqual(yellowTree.up, rootTree)
            XCTAssertEqual(yellow.superview, root)
            XCTAssertEqual(blue.superview, yellow)
        }
    }
}

struct LayoutTreeDebug: CustomDebugStringConvertible {
    let tree: LayoutTree
    
    var debugDescription: String {
        String(describing: tree)
    }
}

extension LayoutTree {
    var debug: LayoutTreeDebug {
        .init(tree: self)
    }
}

extension UIView {

    var tag: Tag { .init(view: self) }
    
    @dynamicMemberLookup
    struct Tag {
        let view: UIView
        
        subscript(dynamicMember tag: String) -> UIView {
            view.accessibilityIdentifier = tag
            return view
        }
    }
}

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
    
    func testClearDuplicatedViewBranch() {
        let dsl = root.layout {
            yellow {
                green
            }
            red {
                blue
                green
            }
        }
        XCTAssertEqual(dsl.debugDescription, "root: [yellow, red: [blue, green]]")
    }
    
    func testViewHierarchy() throws {
        context("root: [yellow]") {
            let expect = LayoutTree(root, content: yellow)
            let dsl = root.layout {
                yellow
            }
            XCTAssertEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow]")
            XCTAssertEqual(yellow.superview, root)
        }
        
        context("root: [yellow, green]") {
            let expect = LayoutTree(root, content: LayoutTree(branches: [yellow, green]))
            let dsl = root.layout {
                yellow
                green
            }
            
            XCTAssertEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow, green]")
            
            XCTAssertEqual(root.subviews.map(\.layoutIdentifier), [yellow, green].map(\.layoutIdentifier))
        }
        
        context("root: [yellow: [green]]") {
            let expect = LayoutTree(root, content: LayoutTree(yellow, content: green))
            let dsl = root.layout {
                yellow {
                    green
                }
            }
            
            let dsl2 = root.layout {
                yellow
            }
            
            XCTAssertEqual(dsl, expect)
            XCTAssertNotEqual(dsl2, expect)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow: [green]]")
            XCTAssertEqual(yellow.superview, root)
            XCTAssertEqual(green.superview, yellow)
        }
        
        context("root: [yellow: [red], green]") {
            let expect = LayoutTree(root, content: LayoutTree(branches: [LayoutTree(yellow, content: red), green]))
            let dsl = root.layout {
                yellow {
                    red
                }
                green
            }
            
            XCTAssertEqual(dsl, expect)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow: [red], green]")
            
            XCTAssertEqual(root.subviews.map(\.layoutIdentifier), [yellow, green].map(\.layoutIdentifier))
            XCTAssertEqual(red.superview, yellow)
        }
        
        context("root: [yellow: [red], green: [blue]]") {
            let bluetree = LayoutTree(view: .view(blue))
            let redtree = LayoutTree(view: .view(red))
            let yellowtree = LayoutTree(yellow, content: redtree)
            let greentree = LayoutTree(green, content: bluetree)
            let roottree = LayoutTree(root, content: LayoutTree(branches: [yellowtree, greentree]))
            let dsl = root.layout {
                yellow {
                    red
                }
                green {
                    blue
                }
            }
            
            XCTAssertEqual(dsl, roottree)
            XCTAssertEqual(dsl.debugDescription, "root: [yellow: [red], green: [blue]]")
            
            XCTAssertEqual(root.subviews.map(\.layoutIdentifier), [yellow, green].map(\.layoutIdentifier))
            XCTAssertEqual(red.superview, yellow)
            XCTAssertEqual(blue.superview, green)
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

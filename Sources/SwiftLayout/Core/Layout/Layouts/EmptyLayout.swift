import Foundation
import UIKit

public struct EmptyLayout: Layout {
    
    public var debugDescription: String {
        "EmptyLayout"
    }
    
    public var sublayouts: [Layout] {
        []
    }
}
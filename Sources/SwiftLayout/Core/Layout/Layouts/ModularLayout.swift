import UIKit

@MainActor
public protocol ModularLayout: Layout {
    associatedtype LayoutBody: Layout

    @LayoutBuilder var layout: LayoutBody { get }
}

extension ModularLayout {
    public func layoutComponents(superview: UIView?, option: LayoutOption) -> [LayoutComponent] {
        return layout.layoutComponents(superview: superview, option: option)
    }

    public func layoutWillActivate() {
        layout.layoutWillActivate()
    }

    public func layoutDidActivate() {
        layout.layoutDidActivate()
    }
}

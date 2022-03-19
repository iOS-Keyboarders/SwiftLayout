//
//  UILayoutGuide+Description.swift
//  
//
//  Created by oozoofrog on 2022/03/14.
//

import UIKit

extension UILayoutGuide {
    var detailDescription: String? {
        guard let view = owningView else { return nil }
        let description = view.tagDescription
        switch identifier {
        case "UIViewLayoutMarginsGuide":
            return description + ".layoutMarginsGuide"
        case "UIViewSafeAreaLayoutGuide":
            return description + ".safeAreaLayoutGuide"
        case "UIViewKeyboardLayoutGuide":
            return description + ".keyboardLayoutGuide"
        case "UIViewReadableContentGuide":
            return description + ".readableContentGuide"
        default:
            return description + ":\(identifier)"
        }
    }
}

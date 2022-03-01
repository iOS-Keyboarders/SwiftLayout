//
//  ObjectIdentifiers.swift
//  
//
//  Created by oozoofrog on 2022/02/17.
//

import Foundation
import UIKit

public final class IdentifierUpdater {
    
    let object: AnyObject
    let prefix: String
    
    public init(_ object: AnyObject, prefix: String = "") {
        self.object = object
        self.prefix = prefix
    }
    
    public func update() {
        let digger = MirrorDigger()
        digger.digging(Mirror(reflecting: object), prefix: prefix)
        for identified in digger.identifieds {
            identified.prepare()
        }
    }
    
    final class Identified: Hashable, CustomDebugStringConvertible {
        static func == (lhs: IdentifierUpdater.Identified, rhs: IdentifierUpdater.Identified) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        internal init(prefix: String = "", identifier: String, view: UIView) {
            self.prefix = prefix
            self.identifier = identifier
            self.view = view
        }
        
        let prefix: String
        let identifier: String
        let view: UIView
        
        func prepare() {
            if prefix.isEmpty {
                view.accessibilityIdentifier = "\(identifier):\(type(of: view))"
            } else {
                view.accessibilityIdentifier = "\(prefix).\(identifier):\(type(of: view))"
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(identifier)
            hasher.combine(view)
        }
        
        var debugDescription: String {
            if prefix.isEmpty {
                return "\(identifier):\(type(of: view))"
            } else {
                return "\(prefix).\(identifier):\(type(of: view))"
            }
        }
    }
    
    final class MirrorDigger {
        
        private(set) var identifieds: Set<Identified> = []
        
        func digging(_ mirror: Mirror, prefix: String = "") {
            if let superclassMirror = mirror.superclassMirror {
                digging(superclassMirror, prefix: prefix)
            }
            for child in mirror.children {
                guard let label = child.label?.replacingOccurrences(of: "$__lazy_storage_$_", with: "") else { continue }
                guard let view = child.value as? UIView else { continue }
                let identified = Identified(prefix: prefix, identifier: label, view: view)
                if self.identifieds.contains(identified) { continue }
                self.identifieds.insert(identified)
                digging(Mirror(reflecting: view), prefix: identifier(prefix: prefix, identifier: label))
            }
        }
        
        func identifier(prefix: String, identifier: String) -> String {
            if prefix.isEmpty {
                return identifier
            } else {
                return "\(prefix).\(identifier)"
            }
        }
        
    }
}

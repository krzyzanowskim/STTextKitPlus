//  Created by Marcin Krzyzanowski

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

public extension NSTextLocation {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.compare(rhs) == .orderedSame
    }

    static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.compare(rhs) != .orderedSame
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.compare(rhs) == .orderedAscending
    }

    static func <= (lhs: Self, rhs: Self) -> Bool {
        lhs == rhs || lhs < rhs
    }

    static func > (lhs: Self, rhs: Self) -> Bool {
        lhs.compare(rhs) == .orderedDescending
    }

    static func >= (lhs: Self, rhs: Self) -> Bool {
        lhs == rhs || lhs > rhs
    }

    static func ~= (a: Self, b: Self) -> Bool {
        a == b
    }
}

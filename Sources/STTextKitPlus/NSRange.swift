//  Created by Marcin Krzyzanowski

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NSRange {

    /// A value indicating that a requested item couldn’t be found or doesn’t exist.
    public static let notFound = NSRange(location: NSNotFound, length: 0)

    /// A Boolean value indicating whether the range is empty.
    ///
    /// Range is empty when its length is equal 0
    public var isEmpty: Bool {
        length == 0
    }

    public init(_ textRange: NSTextRange, in textContentManager: NSTextContentManager) {
        let offset = textContentManager.offset(from: textContentManager.documentRange.location, to: textRange.location)
        let length = textContentManager.offset(from: textRange.location, to: textRange.endLocation)
        self.init(location: offset, length: length)
    }

    public init(_ textLocation: NSTextLocation, in textContentManager: NSTextContentManager) {
        let offset = textContentManager.offset(from: textContentManager.documentRange.location, to: textLocation)
        self.init(location: offset, length: 0)
    }

    /// Creates a new value object containing the specified Foundation range structure.
    public var nsValue: NSValue {
        NSValue(range: self)
    }
}

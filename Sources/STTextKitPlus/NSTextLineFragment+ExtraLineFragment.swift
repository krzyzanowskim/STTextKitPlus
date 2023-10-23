//  Created by Marcin Krzyzanowski

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

extension NSTextLineFragment {

    /// Whether the line fragment is for the extra line fragment at the end of a document.
    ///
    /// The layout manager uses the extra line fragment when the last character in a document causes a line or paragraph break. This extra line fragment has no corresponding glyph.
    public var isExtraLineFragment: Bool {
        // textLineFragment.characterRange.isEmpty the extra line fragment at the end of a document.
        characterRange.isEmpty
    }

}

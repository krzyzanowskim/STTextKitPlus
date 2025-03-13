// BSD 3-Clause License
//
// Copyright (c) Marcin Krzyżanowski
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
// * Redistributions of source code must retain the above copyright notice, this
//   list of conditions and the following disclaimer.
//
// * Redistributions in binary form must reproduce the above copyright notice,
//   this list of conditions and the following disclaimer in the documentation
//   and/or other materials provided with the distribution.
//
// * Neither the name of the copyright holder nor the names of its
//   contributors may be used to endorse or promote products derived from
//   this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if os(macOS) && !targetEnvironment(macCatalyst)
import AppKit
#elseif os(iOS) || os(visionOS)
import UIKit
#endif

extension NSTextLayoutManager {

    /// Extra line layout fragment.
    ///
    /// Only valid when ``state`` greater than NSTextLayoutFragment.State.estimatedUsageBounds
    @nonobjc public func extraLineTextLayoutFragment() -> NSTextLayoutFragment? {
        var extraTextLayoutFragment: NSTextLayoutFragment?
        enumerateTextLayoutFragments(from: nil, options: .reverse) { textLayoutFragment in
            if textLayoutFragment.state.rawValue > NSTextLayoutFragment.State.estimatedUsageBounds.rawValue,
               textLayoutFragment.isExtraLineFragment
            {
                extraTextLayoutFragment = textLayoutFragment
            }
            return false
        }
        return extraTextLayoutFragment
    }

    /// Extra line fragment.
    ///
    /// Only valid when ``state`` greater than NSTextLayoutFragment.State.estimatedUsageBounds
    @nonobjc public func extraLineTextLineFragment() -> NSTextLineFragment? {
        if let textLayoutFragment = extraLineTextLayoutFragment() {
            let textLineFragments = textLayoutFragment.textLineFragments
            if textLineFragments.count > 1, let lastTextLineFragment = textLineFragments.last,
               lastTextLineFragment.isExtraLineFragment
            {
                return lastTextLineFragment
            }
        }
        return nil
    }

}


extension NSTextLayoutManager {

    public func textLineFragment(at location: NSTextLocation) -> NSTextLineFragment? {
        textLayoutFragment(for: location)?.textLineFragment(at: location)
    }

    public func textLineFragment(at point: CGPoint) -> NSTextLineFragment? {
        textLayoutFragment(for: point)?.textLineFragment(at: point)
    }

}

extension NSTextLayoutManager {

    /// Returns a location of text produced by a tap or click at the point you specify.
    /// - Parameters:
    ///   - point: A CGPoint that represents the location of the tap or click.
    ///   - containerLocation: A NSTextLocation that describes the contasiner location.
    /// - Returns: A location
    public func location(interactingAt point: CGPoint, inContainerAt containerLocation: NSTextLocation) -> NSTextLocation? {
        guard let lineFragmentRange = lineFragmentRange(for: point, inContainerAt: containerLocation) else {
            return nil
        }

        var distance: CGFloat = CGFloat.infinity
        var caretLocation: NSTextLocation? = nil
        enumerateCaretOffsetsInLineFragment(at: lineFragmentRange.location) { caretOffset, location, leadingEdge, stop in
            let localDistance = abs(caretOffset - point.x)
            if leadingEdge {
                if localDistance < distance{
                    distance = localDistance
                    caretLocation = location
                } else if localDistance > distance{
                    stop.pointee = true
                }
            }
        }

        return caretLocation
    }
}

extension NSTextLayoutManager {
    
    /// Typographic bounds of the range.
    /// - Parameter textRange: The range.
    /// - Returns: Typographic bounds of the range.
    public func typographicBounds(in textRange: NSTextRange) -> CGRect? {
        textSegmentFrame(in: textRange, type: .standard, options: [.upstreamAffinity, .rangeNotRequired])
    }

    ///  A text segment is both logically and visually contiguous portion of the text content inside a line fragment.
    public func textSegmentFrame(at location: NSTextLocation, type: NSTextLayoutManager.SegmentType, options: SegmentOptions = [.upstreamAffinity]) -> CGRect? {
        textSegmentFrame(in: NSTextRange(location: location), type: type, options: options)
    }

    /// A text segment is both logically and visually contiguous portion of the text content inside a line fragment.
    /// Text segment is a logically and visually contiguous portion of the text content inside a line fragment that you specify with a single text range.
    /// The framework enumerates the segments visually from left to right.
    public func textSegmentFrame(in textRange: NSTextRange, type: NSTextLayoutManager.SegmentType, options: SegmentOptions = [.upstreamAffinity, .rangeNotRequired]) -> CGRect? {
        var result: CGRect? = nil
        // .upstreamAffinity: When specified, the segment is placed based on the upstream affinity for an empty range.
        //
        // In the context of text editing, upstream affinity means that the selection is biased towards the preceding or earlier portion of the text,
        // while downstream affinity means that the selection is biased towards the following or later portion of the text. The affinity helps determine
        // the behavior of the text selection when the text is modified or manipulated.

        // FB15131180: Extra line fragment frame is not correct, that affects enumerateTextSegments as well.
        enumerateTextSegments(in: textRange, type: type, options: options) { textSegmentRange, textSegmentFrame, baselinePosition, textContainer -> Bool in
            result = result?.union(textSegmentFrame) ?? textSegmentFrame
            return true
        }
        return result
    }

}

extension NSTextLayoutManager {

    /// Enumerates the text layout fragments in the specified range.
    ///
    /// - Parameters:
    ///   - range: The location where you start the enumeration.
    ///   - options: One or more of the available NSTextLayoutFragmentEnumerationOptions
    ///   - block: A closure you provide that determines if the enumeration finishes early.
    /// - Returns: An NSTextLocation, or nil. If the method enumerates at least one fragment, it returns the edge of the enumerated range.
    @discardableResult public func enumerateTextLayoutFragments(in range: NSTextRange, options: NSTextLayoutFragment.EnumerationOptions = [], using block: (NSTextLayoutFragment) -> Bool) -> NSTextLocation? {
        enumerateTextLayoutFragments(from: range.location, options: options) { layoutFragment in
            let shouldContinue = layoutFragment.rangeInElement.location <= range.endLocation
            if !shouldContinue {
                return false
            }

            return shouldContinue && block(layoutFragment)
        }

    }

}

extension NSTextLayoutManager {

    public var insertionPointLocations: [NSTextLocation] {
        insertionPointSelections.flatMap(\.textRanges).map(\.location).sorted(by: { $0 < $1 })
    }

    public var insertionPointSelections: [NSTextSelection] {
        textSelections.filter(_textSelectionInsertionPointFilter)
    }
}

private let _textSelectionInsertionPointFilter: (NSTextSelection) -> Bool = { textSelection in
    !textSelection.isLogical && textSelection.textRanges.contains(where: \.isEmpty)
}

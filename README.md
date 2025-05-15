# Collection of useful [TextKit 2](https://developer.apple.com/documentation/appkit/textkit) helpers.

Collection of TextKit 2 helpers used to build [STTextView](https://github.com/krzyzanowskim/STTextView).

## Usage

### NSRange Additions

```swift
NSRange.notFound
NSRange.isEmpty
NSRange.nsValue

NSRange(_ textRange: NSTextRange, in textContentManager: NSTextContentManager)
NSRange(_ textLocation: NSTextLocation, in textContentManager: NSTextContentManager)
``` 

### NSTextRange Additions

```swift
NSTextRange(_ nsRange: NSRange, in textContentManager: NSTextContentManager)

func length(in textContentManager: NSTextContentManager) -> Int
func clamped(to textRange: NSTextRange) -> NSTextRange?
```

### NSTextContentManager Additions

```swift
func location(at offset: Int) -> NSTextLocation?
func location(line lineIdx: Int, character characterIdx: Int? = 0) -> NSTextLocation?

func position(_ location: NSTextLocation) -> (row: Int, column: Int)?

func attributedString(in range: NSTextRange?) -> NSAttributedString?
```

### NSTextLayoutManager Additions

```swift
func textLineFragment(at location: NSTextLocation) -> NSTextLineFragment?
func textLineFragment(at point: CGPoint) -> NSTextLineFragment?

func extraLineTextLayoutFragment() -> NSTextLayoutFragment?
func extraLineTextLineFragment() -> NSTextLineFragment?

func location(interactingAt point: CGPoint, inContainerAt containerLocation: NSTextLocation) -> NSTextLocation?

func textSegmentFrame(at location: NSTextLocation, type: NSTextLayoutManager.SegmentType, options: SegmentOptions = [.upstreamAffinity]) -> CGRect?
func textSegmentFrame(in textRange: NSTextRange, type: NSTextLayoutManager.SegmentType, options: SegmentOptions = [.upstreamAffinity, .rangeNotRequired]) -> CGRect?
func textSegmentFrames(in textRange: NSTextRange, type: NSTextLayoutManager.SegmentType, options: SegmentOptions = [.upstreamAffinity, .rangeNotRequired]) -> [CGRect]

func typographicBounds(in textRange: NSTextRange) -> CGRect?

func enumerateTextLayoutFragments(in range: NSTextRange, options: NSTextLayoutFragment.EnumerationOptions = [], using block: (NSTextLayoutFragment) -> Bool) -> NSTextLocation?

var insertionPointLocations: [NSTextLocation]
var insertionPointSelections: [NSTextSelection]
```

### NSTextLayoutFragment Additions

```swift
var isExtraLineFragment: Bool

func textLineFragment(at location: NSTextLocation, in textContentManager: NSTextContentManager? = nil) -> NSTextLineFragment?
func textLineFragment(at location: CGPoint, in textContentManager: NSTextContentManager? = nil) -> NSTextLineFragment?
```

### NSTextLineFragment Additions

```swift
textRange(in textLayoutFragment: NSTextLayoutFragment) -> NSTextRange?

var isExtraLineFragment: Bool
```

### NSTextLocation Addition

```swift
static func == (lhs: Self, rhs: Self) -> Bool
static func != (lhs: Self, rhs: Self) -> Bool
static func < (lhs: Self, rhs: Self) -> Bool
static func <= (lhs: Self, rhs: Self) -> Bool
static func > (lhs: Self, rhs: Self) -> Bool
static func >= (lhs: Self, rhs: Self) -> Bool
static func ~= (lhs: Self, rhs: Self) -> Bool
```

## Contributing and Collaboration

I'd love to hear from you! Get in touch via an issue or pull request.

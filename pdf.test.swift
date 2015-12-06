import Cocoa

class MyView: NSView {
    
    override func drawRect(dirtyRect: NSRect) {
        NSColor.redColor().set()
        NSRectFill(self.bounds)
    }
}

// we need to init the view
let frame = NSMakeRect(0,0,400,400)
let view = MyView(frame: frame)
let data = view.dataWithPDFInsideRect(frame)
data.writeToFile("x.pdf", atomically: true)


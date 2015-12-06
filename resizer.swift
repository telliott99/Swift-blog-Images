import Cocoa

/*
Usage:
xcrun swift resizer.swift filename sz
xcrun swift resizer.swift x.png 256
*/

let args = Process.arguments

// no error handling
let fn = args[1]
let sz = Int(args[2])!  // Optional
print(fn)

let imgLoad = NSImage(contentsOfFile: fn)
// it's an Optional
if imgLoad == nil { exit(0) }
let img = imgLoad!

print(img.size)

//----------------------------------------

// if img is not square we chop it

let w = Int(img.size.width)
let h = Int(img.size.height)

let n = min(w,h)

let imgRep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: sz,
    pixelsHigh: sz,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: NSCalibratedRGBColorSpace,
    bytesPerRow: w * 4,
    bitsPerPixel: 32)

// another Optional

if imgRep == nil { exit(0) }
let ir = imgRep!

// now we need to draw the image
// do this using a graphics context

let ctx = NSGraphicsContext(bitmapImageRep: ir)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.setCurrentContext(ctx)

let op = NSCompositingOperation.CompositeCopy
let f = CGFloat(1.0)

// draw the image not the imageRep
let dst = CGRectMake(0, 0, CGFloat(sz), CGFloat(sz))
let src = CGRectMake(0, 0, CGFloat(n), CGFloat(n))

img.drawInRect(
    dst,
    fromRect: src,
    operation: op,
    fraction: f)

ctx?.flushGraphics()
NSGraphicsContext.restoreGraphicsState()

print(ir)

let data = ir.representationUsingType(
    .NSPNGFileType,
    properties: [:])

var a = fn.characters.split{$0 == "."}.map(String.init)
let sfx = a.removeLast()
let ofn = a.joinWithSeparator(".")
    
data!.writeToFile(
    ofn + "." + String(sz) + "." + sfx, 
    atomically: true)

import Cocoa

let imgLoad = NSImage(contentsOfFile: "x.png")

// it's an Optional
if imgLoad == nil { exit(0) }
let img = imgLoad!

print(img.className)
print(img.size)

// NSImage is a container for one or more image representations

print(img.representations.count)
let imgRep = img.representations[0] as! NSBitmapImageRep
print(imgRep.className)

/* 
typically each pixel is 4 bytes:  red, green, blue, alpha
other orderings are possible
also they can be stored separately:  that's called planar

above code is *not* a good way to get it b/c
we don't know what the pixel format is or how to handle cases

None of these work with this image in the playground:

imgRep.bitmapFormat
imgRep.bytesPerPlane
imgRep.bytesPerRow
imgRep.planar
imgRep.samplesPerPixel
let data = imgRep.bitmapData

*/

// but they work with plain Swift:

print(imgRep.bitmapFormat)
print(imgRep.bytesPerPlane)
print(imgRep.bytesPerRow)
print(imgRep.planar)
print(imgRep.samplesPerPixel)
print(imgRep.bitsPerSample)

let data = imgRep.bitmapData

/*

Mike Ash:
using the bit map obtained in this way is "not reliable"
what we do instead is to set up a bit map representation
and then draw into it

assuming this size corresponds to pixels (it may not):
*/

let w = Int(img.size.width)
let h = Int(img.size.height)

let imgRep2 = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: w,
    pixelsHigh: h,
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: NSCalibratedRGBColorSpace,
    bytesPerRow: w * 4,
    bitsPerPixel: 32)

// another Optional

if imgRep2 == nil { exit(0) }
let ir = imgRep2!
print(ir)

// now we need to draw the image
// do this using a graphics context

let ctx = NSGraphicsContext(bitmapImageRep: ir)
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.setCurrentContext(ctx)

let op = NSCompositingOperation.CompositeCopy
let f = CGFloat(1.0)

// draw the image! not the imageRep
// NSZeroRect makes it use the whole thing as default!

/*

img.drawAtPoint(
    //NSZeroPoint,
    r,
    fromRect: NSZeroRect,
    operation: op,
    fraction: f)

*/

// Here, I am reducing the size:

let r = CGRectMake(0, 0, CGFloat(w)/2, CGFloat(h)/2)

img.drawInRect(
    r,
    fromRect: NSZeroRect,
    operation: op,
    fraction: f)

ctx?.flushGraphics()
NSGraphicsContext.restoreGraphicsState()

// now we can use the imageRep
// an 'UnsafeMutablePointer<UInt8>'
let bmdata = ir.bitmapData

for i in 0..<4 {
    print(UInt8(bmdata[i]))
}

// Mike Ash does this:

struct Pixel {
    let r,g,b,z: UInt8
}

// but I'm not sure how to do that

let cgi = ir.CGImage
print(cgi!)

let data2 = ir.representationUsingType(
    .NSPNGFileType,
    properties: [:])

data2!.writeToFile("out.png", atomically: true)


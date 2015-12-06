import Cocoa

let oImg = NSImage(named:"x.png")
if nil == oImg { exit(0) }
let img = oImg!
img.className
img.size

// NSImage is a container for one or more image representations

img.representations.count
let imgRep = img.representations[0] as! NSBitmapImageRep
imgRep.className
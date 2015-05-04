// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

@import CoreGraphics;  // CGSize, CGImageRef
#import "PIPDFStream.h"

// Represents a PDF image
@interface PIPDFImage : PIPDFStream

@property(nonatomic, readonly) CGSize size;
@property(nonatomic, readonly) CGFloat bitsPerComponent;

@property(nonatomic, readonly) CGImageRef thumbnailImage;  // 100x100 w/ alpha
@property(nonatomic, readonly) CGImageRef image;

@end

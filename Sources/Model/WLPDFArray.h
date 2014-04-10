// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFObject.h"

// Represents an ordered collection of PDF objects
@interface WLPDFArray : WLPDFObject

@property(nonatomic, readonly) NSUInteger count;
- (WLPDFObject*)objectAtIndex:(NSUInteger)index;

@end

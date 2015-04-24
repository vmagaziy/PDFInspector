// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFObject.h"

// Represents an ordered collection of PDF objects
@interface PIPDFArray : PIPDFObject

@property(nonatomic, readonly) NSUInteger count;
- (PIPDFObject*)objectAtIndex:(NSUInteger)index;

@end

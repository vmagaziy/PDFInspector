// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFObject.h"

// Represents a named PDF objects
@interface PIPDFName : PIPDFObject

@property(nonatomic, readonly) NSString* stringValue;

@end

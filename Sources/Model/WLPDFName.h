// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFObject.h"

// Represents a named PDF objects
@interface WLPDFName : WLPDFObject

@property(nonatomic, readonly) NSString* stringValue;

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFObject.h"

// Represents a dictionary of of PDF objects
@interface WLPDFDictionary : WLPDFObject

- (WLPDFObject*)objectForKey:(NSString*)key;

@end

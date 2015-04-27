// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFObject.h"

// Represents a dictionary of PDF objects
@interface PIPDFDictionary : PIPDFObject

- (PIPDFObject*)objectForKey:(NSString*)key;

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFObject.h"

@interface WLPDFDictionary : WLPDFObject

- (WLPDFObject*)objectForKey:(NSString*)key;

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFObject.h"

// Abstracts PDF objects that represent empty (null) values
@interface WLPDFNull : WLPDFObject
@end

// Abstracts PDF objects that represent boolean values
@interface WLPDFBoolean : WLPDFObject

@property(nonatomic, readonly) BOOL booleanValue;

@end

// Abstracts PDF object that represent integer values
@interface WLPDFInteger : WLPDFObject

@property(nonatomic, readonly) NSInteger integerValue;

@end

// Abstracts PDF object that represent floating point number values
@interface WLPDFReal : WLPDFObject

@property(nonatomic, readonly) double doubleValue;

@end

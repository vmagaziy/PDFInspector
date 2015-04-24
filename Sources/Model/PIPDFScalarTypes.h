// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFObject.h"

// Abstracts PDF objects that represent empty (null) values
@interface PIPDFNull : PIPDFObject
@end

// Abstracts PDF objects that represent boolean values
@interface PIPDFBoolean : PIPDFObject

@property(nonatomic, readonly) BOOL booleanValue;

@end

// Abstracts PDF object that represent integer values
@interface PIPDFInteger : PIPDFObject

@property(nonatomic, readonly) NSInteger integerValue;

@end

// Abstracts PDF object that represent floating point number values
@interface PIPDFReal : PIPDFObject

@property(nonatomic, readonly) double doubleValue;

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFObject.h"

@class PIPDFDictionary;

typedef NS_ENUM(NSUInteger, PIPDFStreamDataType) {
  PIPDFStreamDataTypeUndefined,
  PIPDFStreamDataTypeRaw,
  PIPDFStreamDataTypeJPEG,
  PIPDFStreamDataTypeJPEG2000
};

// Represents a PDF stream
@interface PIPDFStream : PIPDFObject

@property(nonatomic, readonly) PIPDFDictionary* dictionary;
@property(nonatomic, readonly) NSData* data;
@property(nonatomic, readonly) PIPDFStreamDataType dataType;

@end

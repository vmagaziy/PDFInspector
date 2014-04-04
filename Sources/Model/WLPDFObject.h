// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFNode.h"

// Base type in the hierarchy of PDF objects used wrap Core Graphics types
// referred as 'impl' which stands for CGPDFObjectRef; access type names
// and ASCII representation. Relationship between PDF objects are implemented
// by means of PDF nodes.
@interface WLPDFObject : WLPDFNode

+ (instancetype)objectWithImpl:(void*)impl
                          name:(NSString*)aName
                        parent:(WLPDFNode*)aParent; // Factory method

@property(nonatomic, readonly) NSString* typeName;

@property(nonatomic, copy, readonly) NSString* stringRepresentation;
@property(nonatomic, strong, readonly) NSData* dataRepresentation;

@end

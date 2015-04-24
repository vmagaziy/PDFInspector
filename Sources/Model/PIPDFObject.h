// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFNode.h"

// Base type in the hierarchy of PDF objects used wrap Core Graphics types
// referred as 'impl' which stands for CGPDFObjectRef; access type names
// and ASCII representation. Relationship between PDF objects are implemented
// by means of PDF nodes.
@interface PIPDFObject : PIPDFNode

+ (instancetype)objectWithImpl:(void*)impl
                          name:(NSString*)name
                        parent:(PIPDFNode*)parent;  // Factory method

- (instancetype)initWithImpl:(void*)impl
                        name:(NSString*)name
                      parent:(PIPDFNode*)parent;  // Designated

@property(nonatomic, readonly) NSString* typeName;

@property(nonatomic, copy) NSString* stringRepresentation;
@property(nonatomic, readonly) NSData* dataRepresentation;

@end

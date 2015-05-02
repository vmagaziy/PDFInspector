// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

@import CoreGraphics;  // CGPDFObjectRef
#import "PIPDFObject.h"

@interface PIPDFObject ()

+ (instancetype)objectWithImpl:(void*)impl  // CGPDFObjectRef
                          name:(NSString*)name
                        parent:(PIPDFNode*)parent;  // Factory method

- (instancetype)initWithImpl:(void*)impl  // CGPDFObjectRef
                        name:(NSString*)name
                      parent:(PIPDFNode*)parent;  // Designated

@property(nonatomic, assign) CGPDFObjectRef impl;

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFObjectInternal.h"

@implementation PIPDFObject

+ (instancetype)objectWithImpl:(void*)impl
                          name:(NSString*)name
                        parent:(PIPDFNode*)parent {
  NSParameterAssert(impl);
  static NSDictionary* typesMap = nil;
  if (!typesMap) {
    typesMap = @{
      @(kCGPDFObjectTypeNull) : @[ @"PIPDFNull" ],
      @(kCGPDFObjectTypeBoolean) : @[ @"PIPDFBoolean" ],
      @(kCGPDFObjectTypeInteger) : @[ @"PIPDFInteger" ],
      @(kCGPDFObjectTypeReal) : @[ @"PIPDFReal" ],
      @(kCGPDFObjectTypeName) : @[ @"PIPDFName" ],
      @(kCGPDFObjectTypeString) : @[ @"PIPDFString" ],
      @(kCGPDFObjectTypeArray) : @[ @"PIPDFArray" ],
      @(kCGPDFObjectTypeDictionary) : @[ @"PIPDFPage", @"PIPDFDictionary" ],
      @(kCGPDFObjectTypeStream) : @[ @"PIPDFImage", @"PIPDFStream" ]
    };
  }

  if (self != [PIPDFObject class]) {
    return [[self alloc] initWithImpl:impl name:name parent:parent];
  }

  NSNumber* implType = @(CGPDFObjectGetType((CGPDFObjectRef)impl));
  for (NSString* typeName in typesMap[implType]) {
    Class typeClass = NSClassFromString(typeName);
    id instance = [typeClass objectWithImpl:impl name:name parent:parent];
    if (instance) {
      return instance;
    }
  }

  NSLog(@"Failed to create a wrapper for type: %ld", (unsigned long)implType);
  return nil;
}

- (instancetype)initWithImpl:(void*)impl
                        name:(NSString*)name
                      parent:(PIPDFNode*)parent {
  NSParameterAssert(impl);
  self = [super init];
  if (self) {
    _impl = (CGPDFObjectRef)impl;
    self.name = [name copy];
    self.parent = parent;
  }
  return self;
}

- (NSString*)typeName {
  return NSLocalizedString(@"<unknown>",
                           @"Name of unknown type for PDF objects");
}

- (NSData*)dataRepresentation {
  return [self.stringRepresentation dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)description {
  return [NSString stringWithFormat:@"%@ { %@ }", [super description],
                                    self.stringRepresentation];
}

- (BOOL)isEqual:(id)object {
  if (![self isKindOfClass:[self class]]) {
    return NO;
  }

  PIPDFObject* PDFObject = (PIPDFObject*)object;
  if (PDFObject.impl == self.impl) {
    return YES;
  }

  return CFEqual(PDFObject.impl, self.impl);
}

- (NSUInteger)hash {
  return CFHash(self.impl);
}

@end

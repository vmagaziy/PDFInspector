// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFObjectInternal.h"

@implementation WLPDFObject

+ (instancetype)objectWithImpl:(void*)impl
                          name:(NSString*)name
                        parent:(WLPDFNode*)parent {
  NSParameterAssert(impl);
  static NSDictionary* typesMap = nil;
  if (!typesMap) {
    typesMap = @{
      @(kCGPDFObjectTypeNull) : @[ @"WLPDFNull" ],
      @(kCGPDFObjectTypeBoolean) : @[ @"WLPDFBoolean" ],
      @(kCGPDFObjectTypeInteger) : @[ @"WLPDFInteger" ],
      @(kCGPDFObjectTypeReal) : @[ @"WLPDFReal" ],
      @(kCGPDFObjectTypeName) : @[ @"WLPDFName" ],
      @(kCGPDFObjectTypeString) : @[ @"WLPDFString" ],
      @(kCGPDFObjectTypeArray) : @[ @"WLPDFArray" ],
      @(kCGPDFObjectTypeDictionary) : @[ @"WLPDFPage", @"WLPDFDictionary" ],
      @(kCGPDFObjectTypeStream) : @[ @"WLPDFImage", @"WLPDFStream" ]
    };
  }

  if (self != [WLPDFObject class]) {
    return [[self alloc] initWithImpl:impl name:name parent:parent];
  }
  
  NSNumber* implType = @(CGPDFObjectGetType((CGPDFObjectRef)impl));
  for (NSString* typeName in typesMap[implType]) {
    Class typeClass = NSClassFromString(typeName);
    id instance = [typeClass objectWithImpl:impl
                                       name:name
                                     parent:parent];
    if (instance) {
      return instance;
    }
  }
  
  NSLog(@"Failed to create wrapper for: %@ of type: %@", impl, implType);
  return nil;
}

- (instancetype)initWithImpl:(void*)impl
                        name:(NSString*)name 
                      parent:(WLPDFNode*)parent {
  NSParameterAssert(impl);
  self = [super init];
  if (self) {
    _impl = impl;
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
  return [NSString stringWithFormat:@"%@ { %@ }",
      [super description], self.stringRepresentation];
}

- (BOOL)isEqual:(id)object {
  if (![self isKindOfClass:[self class]]) {
    return NO;
  }

  WLPDFObject* PDFObject = (WLPDFObject*)object;
  if (PDFObject.impl == self.impl) {
    return YES;
  }

  return CFEqual(PDFObject.impl, self.impl);
}

- (NSUInteger)hash {
  return CFHash(self.impl);
}

@end

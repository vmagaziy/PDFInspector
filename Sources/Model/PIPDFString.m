// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFString.h"
#import "PIPDFObjectInternal.h"

@interface PIPDFString ()

@property(nonatomic, assign) CGPDFStringRef stringImpl;

@end

@implementation PIPDFString

- (NSString*)typeName {
  return NSLocalizedString(@"String", @"Name of type for string PDF objects");
}

- (NSString*)stringRepresentation {
  NSString* stringRepresentation = [super stringRepresentation];
  if (stringRepresentation) {
    return stringRepresentation;
  }

  NSString* string = (__bridge NSString*)CGPDFStringCopyTextString(
                                                                   self.stringImpl);
  self.stringRepresentation = string;
  return string;
}

- (CGPDFStringRef)stringImpl {
  if (!_stringImpl) {
    if (!CGPDFObjectGetValue(self.impl, kCGPDFObjectTypeString, &_stringImpl)) {
      _stringImpl = NULL;
    }
  }
  return _stringImpl;
}

@end

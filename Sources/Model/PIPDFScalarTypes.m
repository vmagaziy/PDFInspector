// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFScalarTypes.h"
#import "PIPDFObjectInternal.h"

@implementation PIPDFNull

- (NSString*)typeName {
  return NSLocalizedString(@"Null", @"Name of type for null PDF objects");
}

- (NSString*)stringRepresentation {
  return NSLocalizedString(@"Null",
                           @"String representation of null PDF obejct");
}

- (NSData*)dataRepresentation {
  return [@"null" dataUsingEncoding:NSUTF8StringEncoding];
}

@end

#pragma mark -

@implementation PIPDFBoolean

- (NSString*)typeName {
  return NSLocalizedString(@"Boolean", @"Name of type for boolean PDF objects");
}

- (NSString*)stringRepresentation {
  return self.booleanValue
             ? NSLocalizedString(@"True", @"String representation for a true "
                                 @"value of boolean PDF object")
             : NSLocalizedString(@"False", @"String representation for a false "
                                 @"value of boolean PDF object");
}

- (NSData*)dataRepresentation {
  NSString* rawString = self.booleanValue ? @"true" : @"false";
  return [rawString dataUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)booleanValue {
  CGPDFBoolean rawValue = FALSE;
  CGPDFObjectGetValue(self.impl, kCGPDFObjectTypeBoolean, &rawValue);
  return rawValue;
}

@end

#pragma mark -

@implementation PIPDFInteger

- (NSString*)typeName {
  return NSLocalizedString(@"Integer", @"Name of type for integer PDF objects");
}

- (NSString*)stringRepresentation {
  NSString* format = NSLocalizedString(
      @"%ld", @"Format for string representation of integer PDF objects");
  return [NSString stringWithFormat:format, self.integerValue];
}

- (NSInteger)integerValue {
  CGPDFInteger rawValue = 0;
  CGPDFObjectGetValue(self.impl, kCGPDFObjectTypeInteger, &rawValue);
  return (NSInteger)rawValue;
}

@end

#pragma mark -

@implementation PIPDFReal

- (NSString*)typeName {
  return NSLocalizedString(@"Real", @"Name of type for real PDF objects");
}

- (NSString*)stringRepresentation {
  NSString* format = NSLocalizedString(
      @"%f", @"Format for string representation of real PDF objects");
  return [NSString stringWithFormat:format, self.doubleValue];
}

- (double)doubleValue {
  CGPDFReal rawValue = 0.0;
  CGPDFObjectGetValue(self.impl, kCGPDFObjectTypeReal, &rawValue);
  return (double)rawValue;
}

@end

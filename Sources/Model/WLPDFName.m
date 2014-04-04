// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFName.h"
#import "WLPDFObjectInternal.h"

@implementation WLPDFName

- (NSString*)typeName {
	return NSLocalizedString(@"Name", @"Name of type for name PDF objects");
}

- (NSString*)stringRepresentation {
	return self.stringValue;
}

- (NSString*)stringValue {
  // CGPDFObjectGetValue retrieves an expected value into the rawName
  // variable, but it may return false as if an error occured, so ignore
  // the returned result and check whether the value itself is not NULL
  // during "unpacking" process, thus and so we don't check its return
  const char* rawName = NULL;
  CGPDFObjectGetValue(self.impl, kCGPDFObjectTypeName, &rawName);
  if (!rawName) {
    return nil;
  }

  return [NSString stringWithCString:rawName
                            encoding:NSASCIIStringEncoding];
}

@end

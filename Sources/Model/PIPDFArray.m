// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFArray.h"
#import "PIPDFObjectInternal.h"

@implementation PIPDFArray

- (NSArray*)children {
  NSArray* children = [super children];
  if (children) {
    return children;
  }

  CGPDFArrayRef rawArrayImpl = NULL;
  if (!CGPDFObjectGetValue(self.impl, kCGPDFObjectTypeArray, &rawArrayImpl)) {
    return nil;
  }

  NSUInteger count = CGPDFArrayGetCount(rawArrayImpl);
  NSMutableArray* mutableChildren = [NSMutableArray arrayWithCapacity:count];
  for (size_t index = 0; index < count; ++index) {
    CGPDFObjectRef rawElementImpl = NULL;
    if (!CGPDFArrayGetObject(rawArrayImpl, index, &rawElementImpl)) {
      // No chance to get a PDF object at index position, so just ignore it
      NSLog(@"ERROR: Failed to retrieve object at index: %lu for array: %@",
            (unsigned long)index, rawArrayImpl);
      continue;
    }

    // String representation of index is used as a name of element
    NSString* name = [NSString stringWithFormat:@"%lu", (unsigned long)index];

    PIPDFObject* child =
        [PIPDFObject objectWithImpl:rawElementImpl name:name parent:self];
    [mutableChildren addObject:child];
  }

  NSArray* immutableChildren = [NSArray arrayWithArray:mutableChildren];
  self.children = immutableChildren;
  return immutableChildren;
}

- (NSString*)typeName {
  return NSLocalizedString(@"Array", @"Name of type for array PDF objects");
}

- (NSString*)stringRepresentation {
  NSString* stringRepresentation = [super stringRepresentation];
  if (stringRepresentation) {
    return stringRepresentation;
  }

  NSMutableString* mutableString = [NSMutableString stringWithString:@"["];
  NSUInteger count = self.count;
  for (NSUInteger index = 0; index < count; ++index) {
    PIPDFObject* element = [self objectAtIndex:index];
    [mutableString appendString:element.typeName];
    if (index != count - 1) {
      [mutableString appendString:@", "];
    }
  }

  [mutableString appendString:@"]"];

  NSString* immutableString = [NSString stringWithString:mutableString];
  self.stringRepresentation = immutableString;
  return immutableString;
}

- (NSUInteger)count {
  return [self.children count];
}

- (PIPDFObject*)objectAtIndex:(NSUInteger)index {
  return self.children[index];
}

@end

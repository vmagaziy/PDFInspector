// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFDictionary.h"
#import "PIPDFObjectInternal.h"

static const NSString* PIPDFMutableChildrenKey = @"mutableChildren";
static const NSString* PIPDFMutableChildrenDictionaryKey =
    @"mutableChildrenDictionary";
static const NSString* PIPDFParentKey = @"parent";

static void PIPDFDictionaryApplierFunction(const char* key,
                                           CGPDFObjectRef object,
                                           void* info) {
  NSDictionary* userInfo = (__bridge NSDictionary*)info;
  NSMutableArray* children = userInfo[PIPDFMutableChildrenKey];
  NSMutableDictionary* childrenDictionary =
      userInfo[PIPDFMutableChildrenDictionaryKey];
  PIPDFObject* parent = userInfo[PIPDFParentKey];

  NSString* name = [NSString stringWithUTF8String:key];
  PIPDFObject* child =
      [PIPDFObject objectWithImpl:object name:name parent:parent];
  if (child) {
    [children addObject:child];
    childrenDictionary[name] = child;
  }
}

@implementation PIPDFDictionary

- (NSString*)typeName {
  return NSLocalizedString(@"Dictionary",
                           @"Name of type for dictionary PDF objects");
}

- (NSString*)stringRepresentation {
  NSString* stringRepresentation = [super stringRepresentation];
  if (stringRepresentation) {
    return stringRepresentation;
  }

  NSMutableString* mutableString = [NSMutableString stringWithString:@"{"];
  NSArray* children = self.children;
  NSUInteger childrenCount = children.count;
  for (NSUInteger index = 0; index < childrenCount; ++index) {
    PIPDFObject* object = children[index];
    [mutableString appendFormat:@"%@ = %@", object.name, object.typeName];
    if (index != childrenCount - 1) {
      [mutableString appendString:@", "];
    }
  }

  [mutableString appendString:@"}"];

  NSString* immutableString = [NSString stringWithString:mutableString];
  self.stringRepresentation = immutableString;
  return immutableString;
}

- (NSArray*)children {
  NSArray* children = [super children];
  if (children) {
    return children;
  }

  CGPDFDictionaryRef rawDictionaryImpl = NULL;
  // Some objects like a catalog of PDF document are
  // dictionaries while their type does not reflect that
  if (kCGPDFObjectTypeDictionary != CGPDFObjectGetType(self.impl)) {
    rawDictionaryImpl = (CGPDFDictionaryRef)self.impl;
  } else if (!CGPDFObjectGetValue(self.impl, kCGPDFObjectTypeDictionary,
                                  &rawDictionaryImpl)) {
    return nil;
  }

  NSUInteger count = CGPDFDictionaryGetCount(rawDictionaryImpl);
  NSMutableArray* mutableChildren = [NSMutableArray arrayWithCapacity:count];
  NSMutableDictionary* mutableChildrenDictionary =
      [NSMutableDictionary dictionaryWithCapacity:count];
  NSDictionary* context = @{
    PIPDFMutableChildrenKey : mutableChildren,
    PIPDFMutableChildrenDictionaryKey : mutableChildrenDictionary,
    PIPDFParentKey : self
  };

  CGPDFDictionaryApplyFunction(rawDictionaryImpl,
                               PIPDFDictionaryApplierFunction,
                               (__bridge void*)context);

  self.childrenDictionary =
      [NSDictionary dictionaryWithDictionary:mutableChildrenDictionary];

  NSArray* immutableChildren = [NSArray arrayWithArray:mutableChildren];
  self.children = immutableChildren;
  return immutableChildren;
}

- (PIPDFObject*)objectForKey:(NSString*)key {
  return self.childrenDictionary[key];
}

@end

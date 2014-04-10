// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFDictionary.h"
#import "WLPDFObjectInternal.h"

static const NSString* kWLPDFMutableChildrenKey = @"mutableChildren";
static const NSString* kWLPDFMutableChildrenDictionaryKey =
    @"mutableChildrenDictionary";
static const NSString* kWLPDFParentKey = @"parent";

static void WLPDFDictionaryApplierFunction(const char* key,
    CGPDFObjectRef object, void* info) {
  NSDictionary* userInfo = (__bridge NSDictionary*)info;
  NSMutableArray* children = userInfo[kWLPDFMutableChildrenKey];
  NSMutableDictionary* childrenDictionary =
      userInfo[kWLPDFMutableChildrenDictionaryKey];
  WLPDFObject* parent = userInfo[kWLPDFParentKey];

  NSString* name = [NSString stringWithUTF8String:key];
  WLPDFObject* child = [WLPDFObject objectWithImpl:object
                                              name:name
                                            parent:parent];
  if (child) {
    [children addObject:child];
    childrenDictionary[name] = child;
  }
}


@implementation WLPDFDictionary

- (WLPDFObject*)objectForKey:(NSString*)key {
  return self.childrenDictionary[key];
}

- (NSArray*)children {
  NSArray* children = [super children];
  if (children) {
    return children;
  }

  CGPDFDictionaryRef rawDictionaryImpl = NULL;
  if (!CGPDFObjectGetValue(self.impl,
      kCGPDFObjectTypeDictionary, &rawDictionaryImpl)) {
    return nil;
  }

  NSUInteger count = CGPDFDictionaryGetCount(rawDictionaryImpl);
  NSMutableArray* mutableChildren = [NSMutableArray arrayWithCapacity:count];
  NSMutableDictionary* mutableChildrenDictionary =
      [NSMutableDictionary dictionaryWithCapacity:count];
  NSDictionary* context = @{
      kWLPDFMutableChildrenKey : mutableChildren,
      kWLPDFMutableChildrenDictionaryKey : mutableChildrenDictionary,
      kWLPDFParentKey : self
  };

  CGPDFDictionaryApplyFunction(rawDictionaryImpl,
      WLPDFDictionaryApplierFunction, (__bridge void*)context);

  self.childrenDictionary = [NSDictionary
      dictionaryWithDictionary:mutableChildrenDictionary];

  NSArray* immutableChildren = [NSArray arrayWithArray:children];
  self.children = immutableChildren;
  return immutableChildren;
}

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFNode.h"

NSString* const PIPDFDropCacheNotificationName =
    @"PIPDFDropCacheNotificationName";

@implementation PIPDFNode

- (instancetype)init {
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(dropCache)
               name:PIPDFDropCacheNotificationName
             object:nil];
  }
  return self;
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (PIPDFDocument*)document {
  return self.parent.document;
}

- (NSDictionary*)childrenDictionary {
  if (!_childrenDictionary) {
    NSMutableDictionary* dictionary =
        [NSMutableDictionary dictionaryWithCapacity:self.children.count];
    for (PIPDFNode* node in self.children) {
      if (node.name) {
        dictionary[node.name] = node;
      }
    }
    _childrenDictionary = [NSDictionary dictionaryWithDictionary:dictionary];
  }
  return _childrenDictionary;
}

- (PIPDFNode*)childWithName:(NSString*)name {
  return self.childrenDictionary[name];
}

- (id)valueForKey:(NSString*)key {
  return [self childWithName:key];
}

- (void)dropCache {
  _childrenDictionary = nil;  // Use ivar to avoid false creation
}

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFNode.h"

@implementation PIPDFNode

- (PIPDFDocument*)document {
  return self.parent.document;
}

- (NSDictionary*)childrenDictionary {
  if (!_childrenDictionary) {
    NSMutableDictionary* dictionary =
        [NSMutableDictionary dictionaryWithCapacity:self.children.count];
    for (PIPDFNode* node in self.children) {
      dictionary[node.name] = node;
    }
    _childrenDictionary = [NSDictionary dictionaryWithDictionary:dictionary];
  }
  return _childrenDictionary;
}

- (PIPDFNode*)childWithName:(NSString*)name {
  return self.childrenDictionary[name];
}

@end

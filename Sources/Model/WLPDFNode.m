// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFNode.h"

@implementation WLPDFNode

- (WLPDFDocument*)document {
	return self.parent.document;
}

- (NSDictionary*)childrenDictionary {
  if (!_childrenDictionary) {
    NSMutableDictionary* dictionary = [NSMutableDictionary
        dictionaryWithCapacity:[self.children count]];
    for (WLPDFNode* node in self.children) {
      dictionary[node.name] = node;
    }
    _childrenDictionary = [NSDictionary dictionaryWithDictionary:dictionary];
  }
  return _childrenDictionary;
}

- (WLPDFNode*)childWithName:(NSString*)name {
	return self.childrenDictionary[name];
}

@end

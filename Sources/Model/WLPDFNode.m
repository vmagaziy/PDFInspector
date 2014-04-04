// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFNode.h"

@implementation WLPDFNode

- (WLPDFDocument*)document {
	return self.parent.document;
}

- (NSDictionary*)childrenDictionary {
  // TODO: Cache it if needed
	NSMutableDictionary* dictionary = [NSMutableDictionary
      dictionaryWithCapacity:[self.children count]];
  for (WLPDFNode* node in self.children) {
    dictionary[node.name] = node;
  }
  return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (WLPDFNode*)childWithName:(NSString*)name {
	return self.childrenDictionary[name];
}

@end

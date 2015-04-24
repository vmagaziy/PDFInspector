// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

@import XCTest;
#import "PIPDFNode.h"

@interface PIPDFNodeTestCase : XCTestCase
@end

@implementation PIPDFNodeTestCase

- (void)testThatDictionaryOfChildrenIsConstructedCorrectlyForTwoChildren {
  PIPDFNode* child1 = [[PIPDFNode alloc] init];
  child1.name = @"some name";

  PIPDFNode* child2 = [[PIPDFNode alloc] init];
  child2.name = @"some other name";

  PIPDFNode* node = [[PIPDFNode alloc] init];
  node.children = @[ child1, child2 ];

  NSDictionary* expectedChildrenDictionary =
      @{child1.name : child1, child2.name : child2};
  XCTAssertEqualObjects(node.childrenDictionary, expectedChildrenDictionary);
}

@end

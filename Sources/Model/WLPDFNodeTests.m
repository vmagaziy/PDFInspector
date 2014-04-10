// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFNode.h"
#import "Kiwi.h"

SPEC_BEGIN(WLPDFNodeSpec)

describe(@"WLPDFNode", ^{
  __block WLPDFNode* node;

  beforeEach(^{
    node = [[WLPDFNode alloc] init];
  });

  afterEach(^{
    node = nil;
  });

  it(@"constructs dictionary of children correctly "
      "when there are two children", ^{
    NSString* name1 = @"some name";
    WLPDFNode* child1 = [WLPDFNode nullMock];
    [child1 stub:@selector(name) andReturn:name1];

    NSString* name2 = @"some other name";
    WLPDFNode* child2 = [WLPDFNode nullMock];
    [child2 stub:@selector(name) andReturn:name2];

    NSArray* children = @[ child1, child2 ];
    [node stub:@selector(children) andReturn:children];

    NSDictionary* expectedChildrenDictionary = @{
        name1 : child1,
        name2 : child2
    };

    [[node.childrenDictionary should] equal:expectedChildrenDictionary];
  });
});

SPEC_END

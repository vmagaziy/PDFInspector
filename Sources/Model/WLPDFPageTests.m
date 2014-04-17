// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFDocument.h"
#import "WLPDFPage.h"
#import "Kiwi.h"

SPEC_BEGIN(WLPDFPageSpec)

describe(@"WLPDFPage", ^{
  __block WLPDFDocument* document;
  __block WLPDFPage* page;

  beforeEach(^{
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSURL* url = [bundle URLForResource:@"test"
                          withExtension:@"pdf"];
    document = [WLPDFDocument documentWithContentsOfURL:url];
    [[[document should] have:10] pages];

    page = document.pages[5];
  });

  afterEach(^{
   page = nil;
   document = nil;
  });

  it(@"returns correct number", ^{
    NSUInteger number = page.number;
    [[theValue(number) should] equal:theValue(6)];
  });

  it(@"returns correct rotation angle", ^{
    [[theValue(page.rotationAngle) should] equal:theValue(0)];
  });
});

SPEC_END

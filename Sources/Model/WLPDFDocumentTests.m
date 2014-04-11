// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFDocument.h"
#import "Kiwi.h"

SPEC_BEGIN(WLPDFDocumentSpec)

describe(@"WLPDFDocument", ^{
  __block WLPDFDocument* document;

  beforeEach(^{
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    NSURL* url = [bundle URLForResource:@"test"
                          withExtension:@"pdf"];
    document = [WLPDFDocument documentWithContentsOfURL:url];
  });

  afterEach(^{
    document = nil;
  });

  it(@"constructed as expected", ^{
    [document shouldNotBeNil];
  });

  it(@"contains all expected pages", ^{
    [[theValue([document.pages count]) should] equal:theValue(10)];
  });
});

SPEC_END

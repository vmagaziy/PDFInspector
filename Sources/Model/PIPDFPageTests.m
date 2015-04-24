// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

@import XCTest;
#import "PIPDFDocument.h"
#import "PIPDFPage.h"

@interface PIPDFPageTestCase : XCTestCase

@property(nonatomic) PIPDFDocument* document;
@property(nonatomic) PIPDFPage* page;

@end

@implementation PIPDFPageTestCase

- (void)setUp {
  [super setUp];
  NSBundle* bundle = [NSBundle bundleForClass:[self class]];
  NSURL* url = [bundle URLForResource:@"test" withExtension:@"pdf"];
  self.document = [PIPDFDocument documentWithContentsOfURL:url];
  self.page = self.document.pages[5];
}

- (void)tearDown {
  self.page = nil;
  self.document = nil;
  [super tearDown];
}

- (void)testThatPageHasCorrectNumber {
  XCTAssertEqual(self.page.number, (NSUInteger)6);
}

- (void)testThatPageHasCorrectRotationAngle {
  XCTAssertEqual(self.page.rotationAngle, (NSInteger)0);
}

@end
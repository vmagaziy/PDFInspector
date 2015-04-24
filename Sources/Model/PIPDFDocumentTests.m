// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

@import XCTest;
#import "PIPDFDocument.h"

@interface PIPDFDocumentTestCase : XCTestCase

@property(nonatomic) PIPDFDocument* document;

@end

@implementation PIPDFDocumentTestCase

- (void)setUp {
  [super setUp];
  NSBundle* bundle = [NSBundle bundleForClass:[self class]];
  NSURL* url = [bundle URLForResource:@"test" withExtension:@"pdf"];
  self.document = [PIPDFDocument documentWithContentsOfURL:url];
}

- (void)tearDown {
  self.document = nil;
  [super tearDown];
}

- (void)testThatDocumentCanBeCreated {
  XCTAssertNotNil(self.document);
}

- (void)testThatDocumentHasTenPages {
  XCTAssertEqual(self.document.pages.count, (NSUInteger)10);
}

@end
// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

@import XCTest;
#import "PIPDFDocument.h"
#import "PIPDFImage.h"

@interface PIPDFImageTestCase : XCTestCase

@property(nonatomic) PIPDFDocument* document;
@property(nonatomic) PIPDFImage* image;

@end

@implementation PIPDFImageTestCase

- (void)setUp {
  [super setUp];
  NSBundle* bundle = [NSBundle bundleForClass:[self class]];
  NSURL* url = [bundle URLForResource:@"test" withExtension:@"pdf"];
  self.document = [PIPDFDocument documentWithContentsOfURL:url];
  self.image = [self.document
      valueForKeyPath:@"Pages.Kids.1.Kids.0.Resources.XObject.X0"];
}

- (void)tearDown {
  self.image = nil;
  self.document = nil;
  [super tearDown];
}

- (void)testThatImageExists {
  XCTAssertNotNil(self.image);
}

- (void)testThatImageHasProperSize {
  XCTAssertTrue(CGSizeEqualToSize(self.image.size, CGSizeMake(497, 398)));
}

- (void)testThatImageHasUnderlyingImage {
  XCTAssertTrue(self.image.image != NULL);
  CGSize size = self.image.size;
  XCTAssertEqual(self.image.image, self.image.image);
  XCTAssertEqual(CGImageGetWidth(self.image.image), size.width);
  XCTAssertEqual(CGImageGetHeight(self.image.image), size.height);
}

@end

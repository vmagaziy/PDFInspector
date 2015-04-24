// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFPage.h"
#import "PIPDFDocument.h"
#import "PIPDFObjectInternal.h"

// A name of a dictionary entry that must be present in the case the dictionary
// represents a PDF page or a catalog for pages (Portable Document Format
// Reference Manual Version 1.3, Adobe Systems Incorporated, pp. 72, 73).
static NSString* const PIPageTypeEntryName = @"Type";

// A value of the dictionary entry named as kPageTypeEntryName that must be
// present in the case the dictionary represents a page (Portable Document
// Format Reference Manual Version 1.3, Adobe Systems Incorporated, p. 73).
static NSString* const PIPageEntryValue = @"Page";

// A name of the dictionary entry that specifies the number of leaf nodes
// (imageable pages) under the node. The leaf nodes do not have to be
// immediately below the node in the tree, but can be several levels deeper
// in the PDF page tree (Portable Document Format Reference Manual
// Version 1.3, Adobe Systems Incorporated, p. 72).
NSString* const PICountEntryName = @"Count";

@interface PIPDFPage ()

@property(nonatomic, assign) CGPDFPageRef pageImpl;
@property(nonatomic, assign) CGImageRef thumbnailImage;
@property(nonatomic, assign) CGImageRef image;

@end

@implementation PIPDFPage

+ (instancetype)objectWithImpl:(void*)impl
                          name:(NSString*)name
                        parent:(PIPDFNode*)parent {
  CGPDFDictionaryRef rawDictionary = NULL;
  if (CGPDFObjectGetValue((CGPDFObjectRef)impl, kCGPDFObjectTypeDictionary,
                          &rawDictionary)) {
    const char* rawString = NULL;
    if (CGPDFDictionaryGetName(rawDictionary, [PIPageTypeEntryName UTF8String],
                               &rawString)) {
      NSString* string =
          [NSString stringWithCString:rawString encoding:NSASCIIStringEncoding];
      if ([string isEqualToString:PIPageEntryValue]) {
        return [[self alloc] initWithImpl:impl name:name parent:parent];
      }
    }
  }

  return nil;
}

- (void)dealloc {
  CGImageRelease(_thumbnailImage);
  CGImageRelease(_image);
}

- (NSUInteger)number {
  return CGPDFPageGetPageNumber(self.pageImpl);
}

- (CGRect)mediaBox {
  return [self rectForBox:kCGPDFMediaBox];
}

- (CGRect)cropBox {
  return [self rectForBox:kCGPDFCropBox];
}

- (CGRect)bleedBox {
  return [self rectForBox:kCGPDFBleedBox];
}

- (CGRect)trimBox {
  return [self rectForBox:kCGPDFTrimBox];
}

- (CGRect)artBox {
  return [self rectForBox:kCGPDFArtBox];
}

- (CGRect)rectForBox:(CGPDFBox)box {
  CGRect rect = CGPDFPageGetBoxRect(self.pageImpl, box);
  if (1 == (self.rotationAngle / 90) % 2) {
    rect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect),
                      CGRectGetHeight(rect), CGRectGetWidth(rect));
  }
  return rect;
}

- (NSInteger)rotationAngle {
  return CGPDFPageGetRotationAngle(self.pageImpl);
}

- (CGImageRef)thumbnailImage {
  if (!_thumbnailImage) {
    CGRect rect = CGRectMake(0.0, 0.0, 100.0, 100.0);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
        NULL, CGRectGetWidth(rect), CGRectGetHeight(rect), 8, 0, colorSpace,
        (CGBitmapInfo)kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace);

    CGContextSetShadow(ctx, CGSizeMake(4.0, -4.0), 7.0);

    CGAffineTransform transform = CGPDFPageGetDrawingTransform(
        self.pageImpl, kCGPDFMediaBox, rect, 0.0, true);
    CGContextConcatCTM(ctx, transform);

    CGContextDrawPDFPage(ctx, self.pageImpl);
    _thumbnailImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
  }
  return _thumbnailImage;
}

- (CGImageRef)image {
  if (!_image) {
    CGRect rect = self.mediaBox;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
        NULL, CGRectGetWidth(rect), CGRectGetHeight(rect), 8, 0, colorSpace,
        (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    CGColorSpaceRelease(colorSpace);

    CGAffineTransform transform = CGPDFPageGetDrawingTransform(
        self.pageImpl, kCGPDFMediaBox, rect, 0.0, true);
    CGContextConcatCTM(ctx, transform);

    CGContextDrawPDFPage(ctx, self.pageImpl);
    _image = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
  }
  return _image;
}

#pragma mark -

- (CGPDFPageRef)pageImpl {
  if (!_pageImpl) {
    // Retrieve corresponding PDF document by moving up in the tree of objects
    PIPDFDocument* document = nil;
    PIPDFNode* parent = self.parent;
    while (nil != parent) {
      if ([parent isKindOfClass:[PIPDFDocument class]]) {
        document = (PIPDFDocument*)parent;
        break;
      }
      parent = [parent parent];
    }

    // Find a corresponding match by comparing implementations
    NSArray* pages = [document pages];
    for (NSUInteger index = 0, count = pages.count; index < count; ++index) {
      PIPDFPage* page = pages[index];
      if (page.impl == self.impl) {
        _pageImpl =
            CGPDFDocumentGetPage((CGPDFDocumentRef)document.impl, index + 1);
        break;
      }
    }
  }

  return _pageImpl;
}

@end

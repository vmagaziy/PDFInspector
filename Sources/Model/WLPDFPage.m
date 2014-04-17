// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFPage.h"
#import "WLPDFDocument.h"
#import "WLPDFObjectInternal.h"

// A name of a dictionary entry that must be present in the case the dictionary
// represents a PDF page or a catalog for pages (Portable Document Format
// Reference Manual Version 1.3, Adobe Systems Incorporated, pp. 72, 73).
static NSString* kWLPageTypeEntryName = @"Type";

// A value of the dictionary entry named as kPageTypeEntryName that must be
// present in the case the dictionary represents a page (Portable Document
// Format Reference Manual Version 1.3, Adobe Systems Incorporated, p. 73).
static NSString* kWLPageEntryValue = @"Page";

// A name of the dictionary entry that specifies the number of leaf nodes
// (imageable pages) under the node. The leaf nodes do not have to be
// immediately below the node in the tree, but can be several levels deeper
// in the PDF page tree (Portable Document Format Reference Manual
// Version 1.3, Adobe Systems Incorporated, p. 72).
NSString* kWLCountEntryName = @"Count";

@interface WLPDFPage()

@property(nonatomic, assign) CGPDFPageRef pageImpl;

@end

@implementation WLPDFPage

+ (instancetype)objectWithImpl:(void*)impl
                          name:(NSString*)name
                        parent:(WLPDFNode*)parent {
  CGPDFDictionaryRef rawDictionary = NULL;
  if (CGPDFObjectGetValue((CGPDFObjectRef)impl, kCGPDFObjectTypeDictionary,
      &rawDictionary)) {
    const char* rawString = NULL;
		if (CGPDFDictionaryGetName(rawDictionary,
		   [kWLPageTypeEntryName UTF8String], &rawString)) {
      NSString* string = [NSString stringWithCString:rawString
                                            encoding:NSASCIIStringEncoding];
      if ([string isEqualToString:kWLPageEntryValue]) {
        return [[self alloc] initWithImpl:impl name:name parent:parent];
      }
    }
  }

  return nil;
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

- (CGPDFPageRef)pageImpl {
  if (!_pageImpl) {
    // Retrieve corresponding PDF document by moving up in the tree of objects
    WLPDFDocument* document = nil;
    WLPDFNode* parent = self.parent;
		while (nil != parent) {
			if ([parent isKindOfClass:[WLPDFDocument class]]) {
        document = (WLPDFDocument*)parent;
				break;
			}
			parent = [parent parent];
		}

    // Find a corresponding match by comparing implementations
    NSArray* pages = [document pages];
    for (NSUInteger index = 0, count = [pages count]; index < count; ++index) {
      WLPDFPage* page = pages[index];
      if (page.impl == self.impl) {
        _pageImpl = CGPDFDocumentGetPage((CGPDFDocumentRef)document.impl,
                                         index + 1);
        break;
      }
    }
  }

  return _pageImpl;
}

@end

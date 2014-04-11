// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFDocument.h"
#import "WLPDFDictionary.h"
#import "WLPDFPage.h"
#import "WLPDFName.h"
#import "WLPDFObjectInternal.h"

// A name of a dictionary entry that must be present in the case the dictionary
// represents a PDF page or a catalog for pages (Portable Document Format
// Reference Manual Version 1.3, Adobe Systems Incorporated, pp. 72, 73).
static NSString* kWLTypeEntryName = @"Type";

// A value of the dictionary entry named as kTypeEntryName that must be present
// in the dictionary that represents a page (Portable Document Format Reference
// Manual Version 1.3, Adobe Systems Incorporated, p. 72).
static NSString* kWLPagesEntryValue = @"Pages";

// A name of the dictionary entry that contains a list of indirect references
// to the immediate children of a page node (Portable Document Format Reference
// Manual Version 1.3, Adobe Systems Incorporated, p. 72).
NSString* kWLKidsEntryName = @"Kids";

static void WLExtractPages(NSMutableArray* pages, WLPDFObject* object) {
  for (WLPDFObject* child in object.children) {
    if ([child isKindOfClass:[WLPDFPage class]]) {
			[pages addObject:child];
    } else if ([child isKindOfClass:[WLPDFDictionary class]]) {
			WLPDFDictionary* dictionary = (WLPDFDictionary*)child;
			
			WLPDFObject* entry = [dictionary objectForKey:kWLTypeEntryName];
			if (entry && [entry isKindOfClass:[WLPDFName class]]) {
        WLPDFName* name = (WLPDFName*)entry;
        if ([name.stringValue isEqualToString:kWLPagesEntryValue]) {
          WLPDFObject* kids = [dictionary objectForKey:kWLKidsEntryName];
          WLExtractPages(pages, kids);
        }
      }
    }
  }
}

@interface WLPDFDocument()

@property(nonatomic, strong, readwrite) NSArray* pages;
@property(nonatomic, strong, readwrite) WLPDFDictionary* catalog;

@end

@implementation WLPDFDocument

+ (instancetype)documentWithContentsOfURL:(NSURL*)url {
  NSParameterAssert(url);
  CGDataProviderRef dataProvider = CGDataProviderCreateWithURL((CFURLRef)url);
  if (dataProvider) {
    CGPDFDocumentRef impl = CGPDFDocumentCreateWithProvider(dataProvider);
    CGDataProviderRelease(dataProvider);

    if (impl) {
      return [[self alloc] initWithImpl:impl name:nil parent:nil];
    }
  }

  return nil;
}

- (void)dealloc {
  CGPDFDocumentRelease((CGPDFDocumentRef)self.impl);
}

- (NSArray*)children {
  return self.catalog.children;
}

- (WLPDFDictionary*)catalog {
  if (!_catalog) {
    CGPDFDictionaryRef rawCatalog =
        CGPDFDocumentGetCatalog((CGPDFDocumentRef)self.impl);
    if (rawCatalog) {
      _catalog = [WLPDFDictionary objectWithImpl:rawCatalog
                                            name:nil
                                          parent:self];
    }
  }
  return _catalog;
}

- (NSArray*)pages {
  if (!_pages) {
    NSMutableArray* pages = [[NSMutableArray alloc] init];
    WLExtractPages(pages, self);
    _pages = [NSArray arrayWithArray:pages];
  }
  return _pages;
}

@end

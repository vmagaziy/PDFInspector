// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFDocument.h"
#import "PIPDFDictionary.h"
#import "PIPDFPage.h"
#import "PIPDFName.h"
#import "PIPDFObjectInternal.h"

// A name of a dictionary entry that must be present in the case the dictionary
// represents a PDF page or a catalog for pages (Portable Document Format
// Reference Manual Version 1.3, Adobe Systems Incorporated, pp. 72, 73).
static NSString* const PIPDFTypeEntryName = @"Type";

// A value of the dictionary entry named as kTypeEntryName that must be present
// in the dictionary that represents a page (Portable Document Format Reference
// Manual Version 1.3, Adobe Systems Incorporated, p. 72).
static NSString* const PIPDFPagesEntryValue = @"Pages";

// A name of the dictionary entry that contains a list of indirect references
// to the immediate children of a page node (Portable Document Format Reference
// Manual Version 1.3, Adobe Systems Incorporated, p. 72).
NSString* const PIPDFKidsEntryName = @"Kids";

static void PIExtractPages(NSMutableArray* pages, PIPDFObject* object) {
  for (PIPDFObject* child in object.children) {
    if ([child isKindOfClass:[PIPDFPage class]]) {
      [pages addObject:child];
    } else if ([child isKindOfClass:[PIPDFDictionary class]]) {
      PIPDFDictionary* dictionary = (PIPDFDictionary*)child;

      PIPDFObject* entry = [dictionary objectForKey:PIPDFTypeEntryName];
      if ([entry isKindOfClass:[PIPDFName class]]) {
        PIPDFName* name = (PIPDFName*)entry;
        if ([name.stringValue isEqualToString:PIPDFPagesEntryValue]) {
          PIPDFObject* kids = [dictionary objectForKey:PIPDFKidsEntryName];
          PIExtractPages(pages, kids);
        }
      }
    }
  }
}

@interface PIPDFDocument ()

@property(nonatomic, readwrite) NSArray* pages;
@property(nonatomic, readwrite) PIPDFDictionary* catalog;
@property(nonatomic, readwrite) PIPDFDictionary* info;

@end

@implementation PIPDFDocument

+ (instancetype)documentWithContentsOfURL:(NSURL*)url {
  NSParameterAssert(url);
  CGDataProviderRef dataProvider = CGDataProviderCreateWithURL((CFURLRef)url);
  if (dataProvider) {
    CGPDFDocumentRef impl = CGPDFDocumentCreateWithProvider(dataProvider);
    CGDataProviderRelease(dataProvider);

    if (impl) {
      return [[self alloc] initWithImpl:impl
                                   name:url.absoluteString.lastPathComponent
                                 parent:nil];
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

- (PIPDFDictionary*)catalog {
  if (!_catalog) {
    CGPDFDictionaryRef rawCatalog =
        CGPDFDocumentGetCatalog((CGPDFDocumentRef)self.impl);
    if (rawCatalog) {
      _catalog = [[PIPDFDictionary alloc] initWithImpl:rawCatalog
                                                  name:nil
                                                parent:self];
    }
  }
  return _catalog;
}

- (PIPDFDictionary*)info {
  if (!_info) {
    CGPDFDictionaryRef rawInfo =
        CGPDFDocumentGetInfo((CGPDFDocumentRef)self.impl);
    if (rawInfo) {
      _info = [PIPDFDictionary objectWithImpl:rawInfo name:nil parent:self];
    }
  }
  return _info;
}

- (NSArray*)pages {
  if (!_pages) {
    NSMutableArray* pages = [[NSMutableArray alloc] init];
    PIExtractPages(pages, self);
    _pages = [NSArray arrayWithArray:pages];
  }
  return _pages;
}

@end

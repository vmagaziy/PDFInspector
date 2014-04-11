// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFPage.h"
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

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFObject.h"

@class WLPDFDictionary;

@interface WLPDFDocument : WLPDFObject

+ (instancetype)documentWithContentsOfURL:(NSURL*)url;

@property(nonatomic, strong, readonly) WLPDFDictionary* catalog;
@property(nonatomic, strong, readonly) NSArray* pages;

@end

// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFObject.h"

@class PIPDFDictionary;

@interface PIPDFDocument : PIPDFObject

+ (instancetype)documentWithContentsOfURL:(NSURL*)url;

@property(nonatomic, readonly) PIPDFDictionary* catalog;
@property(nonatomic, readonly) NSArray* pages;

@end

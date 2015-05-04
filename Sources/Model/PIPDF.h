// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFScalarTypes.h"
#import "PIPDFName.h"
#import "PIPDFArray.h"
#import "PIPDFDictionary.h"
#import "PIPDFStream.h"
#import "PIPDFImage.h"
#import "PIPDFPage.h"
#import "PIPDFDocument.h"

// Must be sent by the client to clear all cached data;
// this is usually the case on iOS when applications
// receives the memory warning
extern NSString* const PIPDFDropCacheNotificationName;

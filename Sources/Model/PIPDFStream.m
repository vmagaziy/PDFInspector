// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFStream.h"
#import "PIPDFDictionary.h"
#import "PIPDFObjectInternal.h"

@interface PIPDFStream ()

@property(nonatomic, assign) CGPDFStreamRef streamImpl;
@property(nonatomic) PIPDFDictionary* dictionary;

@end

@implementation PIPDFStream

- (PIPDFDictionary*)dictionary {
  if (!_dictionary) {
    CGPDFDictionaryRef rawDictionary =
        CGPDFStreamGetDictionary(self.streamImpl);
    if (rawDictionary) {
      _dictionary = [[PIPDFDictionary alloc] initWithImpl:rawDictionary
                                                     name:nil
                                                   parent:self];
    }
  }
  return _dictionary;
}

- (NSArray*)children {
  return self.dictionary.children;
}

- (NSString*)typeName {
  return NSLocalizedString(@"Stream", @"Name of type for stream PDF objects");
}

- (CGPDFStreamRef)streamImpl {
  if (!_streamImpl) {
    if (!CGPDFObjectGetValue(self.impl, kCGPDFObjectTypeStream, &_streamImpl)) {
      _streamImpl = NULL;
    }
  }
  return _streamImpl;
}

@end

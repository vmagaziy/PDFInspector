// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFStream.h"
#import "PIPDFDictionary.h"
#import "PIPDFObjectInternal.h"

@interface PIPDFStream ()

@property(nonatomic, assign) CGPDFStreamRef streamImpl;
@property(nonatomic, readwrite) PIPDFDictionary* dictionary;
@property(nonatomic, readwrite) NSData* data;
@property(nonatomic, readwrite) PIPDFStreamDataType dataType;

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

- (NSData*)data {
  if (!_data) {
    [self cacheData];
  }
  return _data;
}

- (PIPDFStreamDataType)dataType {
  if (_dataType == PIPDFStreamDataTypeUndefined) {
    [self cacheData];
  }
  return _dataType;
}

#pragma mark -

- (NSArray*)children {
  return self.dictionary.children;
}

- (NSString*)typeName {
  return NSLocalizedString(@"Stream", @"Name of type for stream PDF objects");
}

#pragma mark -

- (void)cacheData {
  CGPDFDataFormat format;
  CFDataRef rawData = CGPDFStreamCopyData(self.streamImpl, &format);
  if (rawData) {
    _data = (__bridge_transfer NSData*)rawData;
    switch (format) {
      case CGPDFDataFormatRaw:
        _dataType = PIPDFStreamDataTypeRaw;
        break;
      case CGPDFDataFormatJPEGEncoded:
        _dataType = PIPDFStreamDataTypeJPEG;
        break;
      case CGPDFDataFormatJPEG2000:
        _dataType = PIPDFStreamDataTypeJPEG2000;
        break;
    }
  }
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

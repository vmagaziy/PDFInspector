// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIPDFImage.h"
#import "PIPDFObjectInternal.h"

#import "PIPDFName.h"
#import "PIPDFArray.h"
#import "PIPDFScalarTypes.h"
#import "PIPDFDictionary.h"

// A name of a dictionary entry that must be present in the case the stream
// represents an image (Portable Document Format Reference Manual Version 1.3,
// Adobe Systems Incorporated,  p. 247).
static NSString* const PIPDFImageTypeEntryName = @"Type";

// A value of the dictionary entry named as PIImageTypeEntryName that must be
// present in the case the stream represents an image (Portable Document Format
// Reference Manual Version 1.3, Adobe Systems Incorporated, p. 247).
static NSString* const PIPDFXObjectEntryValue = @"XObject";

// A name of a dictionary entry that must be present in the case the stream
// represents an image (Portable Document Format Reference Manual Version 1.3,
// Adobe Systems Incorporated, p. 247).
static NSString* const PIPDFImageSubtypeEntryName = @"Subtype";

// A value of the dictionary entry named as PIImageSubtypeEntryName that must be
// present in the case the stream represents an image (Portable Document Format
// Reference Manual Version 1.3, Adobe Systems Incorporated, p. 247).
static NSString* const PIPDFImageEntryValue = @"Image";

// A name of a dictionary entry that must be present in the case the stream
// represents an image. This dictionary entry contains a width of the image
// (Portable Document Format Reference Manual Version 1.3, Adobe Systems
// Incorporated, p. 247).
static NSString* const PIPDFWidthEntryName = @"Width";

// A name of a dictionary entry that must be present in the case the stream
// represents an image. This dictionary entry contains a height of the image
// (Portable Document Format Reference Manual Version 1.3, Adobe Systems
// Incorporated, p. 247).
static NSString* const PIPDFHeightEntryName = @"Height";

// A name of a dictionary entry that must be present in the case the stream
// represents an image. This dictionary entry contains a number of bits used
// to represent each color component. The value must be 1, 2, 4, or 8
// (Portable Document Format Reference Manual Version 1.3, Adobe Systems
// Incorporated, p. 247).
static NSString* const PIPDFBitsPerComponentEntryName = @"BitsPerComponent";

// A name of a dictionary entry that must be present in the case the stream
// represents an image. This dictionary entry contains info about color space.
static NSString* const PIPDFColorSpaceName = @"ColorSpace";

// A name of a device independed color space family (Portable Document Format
// Reference Manual Version 1.3, Adobe Systems Incorporated, p. 231).
static NSString* const PIPDFICCBasedColorSpaceName = @"ICCBased";

// A name of a special color space family (Portable Document Format Reference
// Manual Version 1.7 Sixth Edition, Adobe Systems Incorporated, p. 237).
static NSString* const PIPDFDeviceRGBColorSpaceName = @"DeviceRGB";

// A name of a special color space family (Portable Document Format Reference
// Manual Version 1.7 Sixth Edition, Adobe Systems Incorporated, p. 237).
static NSString* const PIPDFDeviceCMYKColorSpaceName = @"DeviceCMYK";

// A name of a special color space family (Portable Document Format Reference
// Manual Version 1.7 Sixth Edition, Adobe Systems Incorporated, p. 237).
static NSString* const PIPDFDeviceGrayColorSpaceName = @"DeviceGray";

@interface PIPDFImage ()

@property(nonatomic, readwrite) CGSize size;
@property(nonatomic, readwrite) CGFloat bitsPerComponent;

@property(nonatomic, readwrite) CGImageRef thumbnailImage;
@property(nonatomic, readwrite) CGImageRef image;

@end

@implementation PIPDFImage

+ (instancetype)objectWithImpl:(void*)impl
                          name:(NSString*)name
                        parent:(PIPDFNode*)parent {
  if (![self isImplForImage:(CGPDFObjectRef)impl]) {
    return nil;
  }
  return [super objectWithImpl:impl name:name parent:parent];
}

- (void)dealloc {
  CGImageRelease(_image);
  CGImageRelease(_thumbnailImage);
}

- (NSString*)typeName {
  return NSLocalizedString(@"Image", @"Name of type for image PDF objects");
}

- (void)dropCache {
  CGImageRelease(_image);
  _image = NULL;
  CGImageRelease(_thumbnailImage);
  _thumbnailImage = NULL;
}

#pragma mark -

+ (BOOL)isImplForImage:(CGPDFObjectRef)impl {
  CGPDFStreamRef rawStream = NULL;
  if (CGPDFObjectGetValue(impl, kCGPDFObjectTypeStream, &rawStream)) {
    CGPDFDictionaryRef rawDictionary = CGPDFStreamGetDictionary(rawStream);
    if (rawDictionary) {
      const char* rawString = NULL;
      if (CGPDFDictionaryGetName(
              rawDictionary, PIPDFImageTypeEntryName.UTF8String, &rawString)) {
        NSString* string = [NSString stringWithUTF8String:rawString];
        if ([string isEqualToString:PIPDFXObjectEntryValue]) {
          if (CGPDFDictionaryGetName(rawDictionary,
                                     PIPDFImageSubtypeEntryName.UTF8String,
                                     &rawString)) {
            string = [NSString stringWithUTF8String:rawString];
            if ([string isEqualToString:PIPDFImageEntryValue]) {
              return YES;
            }
          }
        }
      }
    }
  }
  return NO;
}

- (CGSize)size {
  if (CGSizeEqualToSize(_size, CGSizeZero)) {
    NSInteger width = 0;
    PIPDFObject* object = [self.dictionary objectForKey:PIPDFWidthEntryName];
    if ([object isKindOfClass:[PIPDFInteger class]]) {
      width = [(PIPDFInteger*)object integerValue];
    }

    NSInteger height = 0;
    object = [self.dictionary objectForKey:PIPDFHeightEntryName];
    if ([object isKindOfClass:[PIPDFInteger class]]) {
      height = [(PIPDFInteger*)object integerValue];
    }
    _size = CGSizeMake(width, height);
  }
  return _size;
}

- (CGFloat)bitsPerComponent {
  if (_bitsPerComponent == 0.0) {
    PIPDFObject* object =
        [self.dictionary objectForKey:PIPDFBitsPerComponentEntryName];
    if ([object isKindOfClass:[PIPDFInteger class]]) {
      _bitsPerComponent = [(PIPDFInteger*)object integerValue];
    }
  }
  return _bitsPerComponent;
}

- (CGImageRef)image {
  if (!_image) {
    _image = [self extractImage];
  }
  return _image;
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

    CGContextDrawImage(ctx, rect, self.image);
    _thumbnailImage = CGBitmapContextCreateImage(ctx);
    CGContextRelease(ctx);
  }
  return _thumbnailImage;
}

#pragma mark -

- (NSString*)colorSpaceName {
  NSString* colorSpaceName;
  PIPDFObject* colorSpaceObject =
      [self.dictionary objectForKey:PIPDFColorSpaceName];
  PIPDFArray* colorSpaceArray = nil;
  if ([colorSpaceObject isKindOfClass:[PIPDFName class]]) {
    // Handle a device dependent color space (Portable Document Format
    // Reference Manual Version 1.3, Adobe Systems Incorporated, p. 231)
    colorSpaceName = [(PIPDFName*)colorSpaceObject stringValue];
  } else if ([colorSpaceObject isKindOfClass:[PIPDFArray class]]) {
    // Handle a color space specified by an array whose first element is
    // the family name and whose remaining elements are parameters that
    // define a particular color space (Portable Document Format Reference
    // Manual Version 1.3, Adobe Systems Incorporated, p. 231)
    colorSpaceArray = (PIPDFArray*)colorSpaceObject;
    PIPDFObject* name = [colorSpaceArray objectAtIndex:0];
    if ([name isKindOfClass:[PIPDFName class]]) {
      colorSpaceName = [(PIPDFName*)name stringValue];
    }
  }
  return colorSpaceName;
}

- (CGColorSpaceRef)createColorSpaceWithName:(NSString*)name {
  // Detect the color space of the image
  CGColorSpaceRef colorSpace = NULL;
  if ([name isEqualToString:PIPDFICCBasedColorSpaceName]) {
    PIPDFStream* profileStream;
    PIPDFArray* colorSpaceArray =
        (PIPDFArray*)[self.dictionary objectForKey:PIPDFColorSpaceName];
    NSAssert([colorSpaceArray isKindOfClass:[PIPDFArray class]], @"");

    // Retrieve a base color space
    PIPDFObject* colorSpaceObject = [colorSpaceArray objectAtIndex:1];
    if ([colorSpaceObject isKindOfClass:[PIPDFArray class]]) {
      PIPDFArray* baseArray = (PIPDFArray*)colorSpaceObject;
      if (baseArray.count < 1) {
        return NULL;
      }

      PIPDFObject* profileObject = [baseArray objectAtIndex:1];
      if (![profileObject isKindOfClass:[PIPDFStream class]]) {
        return NULL;
      }

      profileStream = (PIPDFStream*)profileObject;
    } else if ([colorSpaceObject isKindOfClass:[PIPDFStream class]]) {
      profileStream = (PIPDFStream*)colorSpaceObject;
    }

    colorSpace =
        CGColorSpaceCreateWithICCProfile((CFDataRef)profileStream.data);
  } else if ([name isEqualToString:PIPDFDeviceRGBColorSpaceName]) {
    colorSpace = CGColorSpaceCreateDeviceRGB();
  } else if ([name isEqualToString:PIPDFDeviceGrayColorSpaceName]) {
    colorSpace = CGColorSpaceCreateDeviceGray();
  } else if ([name isEqualToString:PIPDFDeviceCMYKColorSpaceName]) {
    colorSpace = CGColorSpaceCreateDeviceCMYK();
  }

  return colorSpace;
}

- (CGImageRef)extractImage {
  CGSize size = self.size;
  if (size.width == 0 || size.height == 0) {
    return NULL;
  }

  // Retrieve an image stream data and obtain the information
  // needed to form the data provider
  NSData* data = self.data;
  NSUInteger dataSize = data.length;

  // Detect the color space of the image
  NSString* colorSpaceName = [self colorSpaceName];
  if (!colorSpaceName) {
    return NULL;
  }

  CGColorSpaceRef colorSpace = [self createColorSpaceWithName:colorSpaceName];
  if (!colorSpace) {
    return NULL;
  }

  // TODO: Provide special handling for indexed color space

  CGImageRef image = NULL;
  CGDataProviderRef dataProvider =
      CGDataProviderCreateWithCFData((CFDataRef)data);
  PIPDFStreamDataType dataType = self.dataType;
  if (PIPDFStreamDataTypeJPEG == dataType) {
    // JPEG format contains everything needed for image creation
    CGImageRef imageInHandoffColorSpace = CGImageCreateWithJPEGDataProvider(
        dataProvider, NULL, false, kCGRenderingIntentDefault);

    // Create jpeg image with profile
    if (imageInHandoffColorSpace) {
      image =
          CGImageCreateCopyWithColorSpace(imageInHandoffColorSpace, colorSpace);
      CGImageRelease(imageInHandoffColorSpace);
    }
  } else if (PIPDFStreamDataTypeRaw == dataType) {
    NSUInteger bitsPerPixel = dataSize / (size.width * size.height) * 8;
    NSUInteger bytesPerRow = (bitsPerPixel * size.width + 7) / 8;

    // Create an image with its profile
    image = CGImageCreate(size.width, size.height, self.bitsPerComponent,
                          bitsPerPixel, bytesPerRow, colorSpace,
                          (CGBitmapInfo)kCGImageAlphaNone, dataProvider, NULL,
                          false, kCGRenderingIntentDefault);
  }

  CGDataProviderRelease(dataProvider);

  CGColorSpaceRelease(colorSpace);
  return image;
}

@end

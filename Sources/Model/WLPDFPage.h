// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "WLPDFDictionary.h"

// Represents a PDF page
@interface WLPDFPage : WLPDFDictionary

@property(nonatomic, readonly) NSUInteger number;

// Boxes (for more info refer Portable Document Format Reference Manual
// Version 1.3, Adobe Systems Incorporated, pp. 73-75):
// - Crop box defines the default clipping region for the page when
//   displayed or printed.  By default, it is equal to a media box.
// - Bleed box defines the region to which all page content should
//   be clipped if the page is being output in a production environment.
//   In such environments, a bleed area is desired, to accommodate physical
//   limitations of cutting, folding and trimming equipment.  The actual
//   printed page may include printer's marks that fall outside the bleed box.
//   By default, it is equal to a crop box.
// - Trim box specifies the intended finished size of the page (for example,
//   the dimensions of an A4 sheet of paper). In some cases, a media box will
//   be a larger rectangle, which includes printing instructions, cut marks,
//   or other content.  By default, it is equal to a crop box.
// - Art box specifies an area of the page to be used when placing	PDF content
//   into another application.  By default, it is equal to a crop box.
@property(nonatomic, readonly) CGRect mediaBox;
@property(nonatomic, readonly) CGRect cropBox;
@property(nonatomic, readonly) CGRect bleedBox;
@property(nonatomic, readonly) CGRect trimBox;

@property(nonatomic, readonly) NSInteger rotationAngle;

@end

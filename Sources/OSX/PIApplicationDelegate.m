// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIApplicationDelegate.h"

@implementation PIApplicationDelegate

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication*)sender {
  return NO;
}

@end

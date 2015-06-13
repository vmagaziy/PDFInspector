// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

#import "PIDocument.h"
#import "PIPDF.h"

@interface PIDocument () <NSOutlineViewDataSource, NSOutlineViewDelegate>

@property(nonatomic) PIPDFDocument* document;
@property(nonatomic) IBOutlet NSOutlineView* outlineView;

@end

@implementation PIDocument

- (NSString*)windowNibName {
  return @"PIDocument";
}

- (BOOL)readFromURL:(NSURL*)url
             ofType:(NSString*)typeName
              error:(NSError**)outError {
  if ([typeName isEqualToString:@"PDFDocument"]) {
    self.document = [PIPDFDocument documentWithContentsOfURL:url];
    [self.outlineView reloadData];
  }
  return self.document != nil;
}

#pragma mark -

- (NSInteger)outlineView:(NSOutlineView*)outlineView
    numberOfChildrenOfItem:(id)item {
  PIPDFNode* node = item;
  if (!node) {
    node = self.document;
  }
  return node.children.count;
}

- (BOOL)outlineView:(NSOutlineView*)outlineView isItemExpandable:(id)item {
  PIPDFNode* node = item;
  return node.children.count != 0;
}

- (id)outlineView:(NSOutlineView*)anOutlineView
            child:(NSInteger)index
           ofItem:(id)item {
  PIPDFNode* node = item;
  if (!node) {
    node = self.document;
  }

  PIPDFNode* childNode = node.children[index];
  return childNode;
}

- (id)outlineView:(NSOutlineView*)outlineView
    objectValueForTableColumn:(NSTableColumn*)tableColumn
                       byItem:(id)item {
  PIPDFObject* PDFObject = item;
  NSString* identifier = tableColumn.identifier;
  if ([identifier isEqualToString:@"name"]) {
    return PDFObject.name;
  } else if ([identifier isEqualToString:@"typeName"]) {
    return PDFObject.typeName;
  }
  return PDFObject.children.count == 0 ? PDFObject.stringRepresentation : @"";
}

@end

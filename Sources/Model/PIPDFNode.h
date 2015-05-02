// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

@import Foundation;

@class PIPDFDocument;

// Implements basic behavior of named tree nodes: stores reference to
// parent node (root node in the tree does not have a parent) and child
// nodes (child nodes are not available for leaves).
// PDF document is a tree with the root node which stands for its catalog
// and other PDF objects are represented by nodes in this tree; leaf nodes
// represent PDF scalar objects (i.e., objects that don't refer other
// objects, for instance: numbers, strings and names).
@interface PIPDFNode : NSObject

@property(nonatomic, copy) NSString* name;

@property(nonatomic, weak) PIPDFNode* parent;
@property(nonatomic) NSArray* children;

@property(nonatomic, readonly) PIPDFDocument* document;

@property(nonatomic) NSDictionary* childrenDictionary;
- (PIPDFNode*)childWithName:(NSString*)name;

@end

@interface PIPDFNode (Cache)

- (void)dropCache;  // Override to drop cached values

@end

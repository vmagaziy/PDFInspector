// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

import UIKit

class PDFObjectTableViewCell : UITableViewCell {
  override func layoutSubviews() {
     super.layoutSubviews()
    if let accessoryView = self.accessoryView {
      accessoryView.sizeToFit()
      
      let requiredWidth: CGFloat = ceil(CGRectGetWidth(accessoryView.bounds))
      let detailsTextLabelOffset = CGRectGetMaxX(detailTextLabel!.frame)
      let textLabelOffset = CGRectGetMaxX(textLabel!.frame)
      let margin: CGFloat = 10
      let width = CGRectGetWidth(self.bounds)
      
      if width - detailsTextLabelOffset - 2 * margin < requiredWidth {
        var frame = textLabel!.frame
        frame.origin.x = textLabelOffset + margin
        frame.size.width = width - textLabelOffset - 2 * margin
        accessoryView.frame = frame
      } else {
        let offset = max(detailsTextLabelOffset, textLabelOffset) 
        accessoryView.frame = CGRectMake(offset + margin, 0.0, width - offset - 2 * margin, CGRectGetHeight(bounds))
      }
    }
  }
}

class PDFObjectViewController: UITableViewController {
  var PDFObject: PIPDFObject!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.title = PDFObject.name
  }
}

// MARK: Table view

extension PDFObjectViewController : UITableViewDataSource, UITableViewDelegate {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return PDFObject.children.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let index = indexPath.row
    let object = PDFObject.children[index] as! PIPDFObject
    let cellID = "cellID"
    
    var cell = tableView.dequeueReusableCellWithIdentifier(cellID) as? UITableViewCell
    if cell == nil {
      cell = PDFObjectTableViewCell(style: .Subtitle, reuseIdentifier: cellID)
      cell!.textLabel!.adjustsFontSizeToFitWidth = true
    }
    
    cell!.textLabel!.text = object.name
    cell!.detailTextLabel!.text = object.typeName
    if object.hasDetails() {
      cell!.selectionStyle = .Blue
      cell!.accessoryType = .DisclosureIndicator
    } else {
      cell!.selectionStyle = .None
      
      var infoLabel = UILabel()
      infoLabel.textColor = UIColor.grayColor()
      infoLabel.adjustsFontSizeToFitWidth = true
      infoLabel.text = object.stringRepresentation
      infoLabel.textAlignment = .Right
    
      cell!.accessoryView = infoLabel
    }
    
    return cell!
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    let childPDFObject = PDFObject.children[indexPath.row] as! PIPDFObject
    
    if childPDFObject.hasDetails() {
      let vc = PDFObjectViewController()
      vc.PDFObject = childPDFObject
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}

extension PIPDFNode {
  func hasDetails() -> Bool {
    let childrenCount = children?.count
    return childrenCount != nil && childrenCount != 0 ? true : false
  }
}

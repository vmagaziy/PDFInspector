// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

import UIKit

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
      cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellID)
    }
    
    cell!.textLabel!.text = object.name
    cell!.detailTextLabel!.text = object.typeName
    if object.hasDetails() {
      cell!.selectionStyle = .Blue
      cell!.accessoryType = .DisclosureIndicator
    } else {
      cell!.selectionStyle = .None
      var infoLabel = UILabel()
      infoLabel.textColor = UIColor.darkGrayColor()
      infoLabel.adjustsFontSizeToFitWidth = true
      infoLabel.text = object.stringRepresentation
      infoLabel.sizeToFit()
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

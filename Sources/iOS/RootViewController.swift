// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

import UIKit

class RootViewController: UITableViewController {
  var document: PIPDFDocument!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID())
    let url = NSBundle.mainBundle().URLForResource("test", withExtension: "pdf")
    self.document = PIPDFDocument(contentsOfURL: url)
    self.title = self.document.name
  }
}

// MARK: Table view

extension RootViewController : UITableViewDataSource, UITableViewDelegate {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return document.pages.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let index = indexPath.row
    let page = self.document.pages[index] as! PIPDFPage
    
    let cell = tableView.dequeueReusableCellWithIdentifier(cellID(), forIndexPath: indexPath) as! UITableViewCell
    
    cell.textLabel?.text = String(format: NSLocalizedString("Page: %ld", comment: ""), page.number)
    cell.imageView?.image = UIImage(CGImage: page.thumbnailImage)
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  func cellID() -> String {
    return "cellID"
  }
}

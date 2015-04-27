// PDFInspector
// Author: Vladimir Magaziy <vmagaziy@gmail.com>

import UIKit

class RootViewController: UITableViewController {
  var documents: [PIPDFDocument] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellID())
    let url = NSBundle.mainBundle().URLForResource("test", withExtension: "pdf")
    self.documents = [ PIPDFDocument(contentsOfURL: url) ]
    self.title = NSLocalizedString("PDF Documents", comment:"")
  }
}

// MARK: Table view

extension RootViewController : UITableViewDataSource, UITableViewDelegate {
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return documents.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(cellID(), forIndexPath: indexPath) as! UITableViewCell
    
    let document = documents[indexPath.row]
    cell.textLabel?.text = document.name
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    let document = documents[indexPath.row]
    
    let vc = PDFObjectViewController()
    vc.PDFObject = document
    
    navigationController?.pushViewController(vc, animated: true)
  }
  
  func cellID() -> String {
    return "cellID"
  }
}


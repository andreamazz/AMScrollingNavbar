import UIKit
import AMScrollingNavbar

class DisappearingHeaderViewController: ScrollingNavigationViewController {
  @IBOutlet var disappearingHeader: UIView!
  @IBOutlet var tableView: UITableView!

  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.contentInset.top = disappearingHeader.frame.height
  }
  
  // Enable the navbar scrolling
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.followScrollView(tableView, floatingHeader: disappearingHeader)
    }
  }
}

extension DisappearingHeaderViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 100
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = "Row \((indexPath as NSIndexPath).row + 1)"
    return cell
  }
}

import UIKit
import AMScrollingNavbar

class DisappearingHeaderViewController: UIViewController {
  @IBOutlet var disappearingHeader: UIView!
  @IBOutlet var tableView: UITableView!

  // Enable the navbar scrolling
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    print("here")
    if let navigationController = self.navigationController as? ScrollingNavigationController {
      print("there")
      navigationController.followScrollView(tableView)
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

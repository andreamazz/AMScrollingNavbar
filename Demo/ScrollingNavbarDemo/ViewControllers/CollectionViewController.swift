import UIKit
import AMScrollingNavbar

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

  @IBOutlet var collectionView: UICollectionView!

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "CollectionView"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: nil)
    navigationController?.navigationBar.barTintColor = UIColor(red:0.91, green:0.3, blue:0.24, alpha:1)
    let flowLayout = UICollectionViewFlowLayout()
    flowLayout.minimumInteritemSpacing = 1;
    flowLayout.minimumLineSpacing = 1;
    let cellSize = (CGFloat.minimum(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) - 2) / 3;
    flowLayout.itemSize = CGSize(width: cellSize, height: cellSize)
    flowLayout.scrollDirection = .vertical
    collectionView?.collectionViewLayout = flowLayout
    //        collectionView?.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
  }

  // Enable the navbar scrolling
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.followScrollView(collectionView, delay: 50.0)
    }
  }

  // MARK: - Collection view data source

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 100
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
    cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    if let label = cell.contentView.subviews.first as? UILabel {
      label.text = "\(indexPath.row + 1)"
      label.textColor = UIColor(red: 0.45, green: 0.35, blue: 0.35, alpha: 1)
    }
    return cell
  }

  open func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
    if let navigationController = self.navigationController as? ScrollingNavigationController {
      navigationController.showNavbar(animated: true)
    }
    return true
  }

}

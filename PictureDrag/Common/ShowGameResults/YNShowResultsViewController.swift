//
//  YNShowResultsViewController.swift
//  PictureDrag
//
//  Created by Ulian on 28.05.2023.
//

import UIKit

class YNShowResultsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var resultsTableView: UITableView!
    @IBOutlet weak var noResultsLabel: UILabel!
    
    weak var dataSource : YNBestResultsDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let dataSource = self.dataSource else {
            assertionFailure("\(Self.self): unexpectedly found dataSource to be nil")
            return
        }
        
        self.descriptionLabel.text = dataSource.screenTitle
        self.noResultsLabel.text = dataSource.noResultsText
        self.noResultsLabel.alpha = dataSource.showNoResultsText ? 1.0 : 0.0
        
        self.view.backgroundColor = appDesign.borderColor // ask data source?
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // notify presenter/navigator about going away ??
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.gameResultsModels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YNShowResultsTableViewCell", for: indexPath) as! YNShowResultsTableViewCell
        let model = (self.dataSource?.gameResultsModels?[indexPath.row])!
        cell.setupCellData(image: model.smallImage,
                           name: model.gamerName,
                           date: model.dateString,
                           result: self.dataSource?.resultStringFormTimeString(model.gameResultTime) ?? "Unknown",
                           place : indexPath.row + 1)

        return cell
    }
}

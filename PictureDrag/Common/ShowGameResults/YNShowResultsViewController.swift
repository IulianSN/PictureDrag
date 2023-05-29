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
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YNShowResultsTableViewCell", for: indexPath) as! YNShowResultsTableViewCell
        
        // setup, use data sourse protocol (presenter/interactor data)
        
        return cell
    }
    
    
    
    
}

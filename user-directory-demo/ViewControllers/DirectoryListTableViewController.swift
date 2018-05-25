//
//  DirectoryListTableViewController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/23/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit

class DirectoryListTableViewController: UITableViewController {
    
    private var individuals: [Individual] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func update(with individuals: [Individual]) {
        self.individuals = individuals
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return individuals.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let individual = individuals[indexPath.row]
        cell.textLabel?.text = individual.firstName + " " + individual.lastName
        
        return cell
    }
}

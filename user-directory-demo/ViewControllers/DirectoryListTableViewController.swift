//
//  DirectoryListTableViewController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/23/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

fileprivate let kIndividualCellIdentifier = "individualCell"
fileprivate let kIndividualNibName = "IndividualTableViewCell"

class DirectoryListTableViewController: UITableViewController {
    
    private var individuals: Results<Individual>? {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: kIndividualNibName, bundle: .main), forCellReuseIdentifier: kIndividualCellIdentifier)
        
        let realm = try! Realm()
        self.individuals = realm.objects(Individual.self)
    }
    
    func update(with individuals: [Individual]) {
//        self.individuals = individuals
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.individuals == nil ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return individuals!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: kIndividualCellIdentifier, for: indexPath) as? IndividualTableViewCell else {
            return UITableViewCell()
        }
        
        let individual = individuals![indexPath.row]
        cell.configureCell(forIndividual: individual)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? IndividualTableViewCell else { return }
        let individual = individuals![indexPath.row]
        
        let cellUpdateHandler: (ThreadSafeReference<Individual>) -> () = { (individualRef) in
            let realm = try! Realm()
            guard let individual = realm.resolve(individualRef) else {
                fatalError("realm object no longer exits")
            }
            cell.configureCell(forIndividual: individual)
            IndividualController.operationsCache.removeValue(forKey: String(individual.id))
        }
        
        if IndividualController.operationsCache[String(individual.id)] == nil, let loadOperation = individual.imageLoadOperation() {
            loadOperation.loadingHandler = cellUpdateHandler
            IndividualController.operationQueue.addOperation(loadOperation)
            IndividualController.operationsCache[String(individual.id)] = loadOperation
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let individual = individuals![indexPath.row]
        IndividualController.operationsCache.removeValue(forKey: String(individual.id))
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = AppStoryboard.Individual.instance.instantiateViewController(withIdentifier: IndividualDetailViewController.storyboardID) as? IndividualDetailViewController else { return }
        
        let individual = individuals![indexPath.row]
        detailVC.configure(withIndividual: individual)
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
















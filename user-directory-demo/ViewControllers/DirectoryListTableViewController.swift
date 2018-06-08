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
fileprivate let kAffiliation = "_affiliation"
fileprivate let kName = "firstName"
fileprivate let kNone = "none"
let kFilter = "filterKey"
fileprivate let kSort = "sortKey"
fileprivate let kChecked = "checked"

protocol FilterPickerDelegate {
    func didSelectFilter()
}

class DirectoryListTableViewController: UITableViewController {
    
    private var individuals: Results<Individual>? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var filterPickerDelegate: FilterPickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: kIndividualNibName, bundle: .main), forCellReuseIdentifier: kIndividualCellIdentifier)
        
        sortDirectory()
    }
    
    @objc func showSortOptions() {
        let sortAlert = UIAlertController(title: "Sort", message: "Choose an option to sort the directory.", preferredStyle: .actionSheet)
        let affiliationSortAction = UIAlertAction(title: "Affiliation", style: .default) { (_) in
            UserDefaults.standard.set(kAffiliation, forKey: kSort)
            self.sortDirectory()
        }
        let nameSortAction = UIAlertAction(title: "Name", style: .default) { (_) in
            UserDefaults.standard.set(kName, forKey: kSort)
            self.sortDirectory()
        }
        let noneSortAction = UIAlertAction(title: "None", style: .default) { (_) in
            UserDefaults.standard.set(kNone, forKey: kSort)
            self.sortDirectory()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let sortValue = UserDefaults.standard.value(forKey: kSort) as? String
        switch sortValue {
        case kAffiliation:
            affiliationSortAction.setValue(true, forKey: kChecked)
        case kName:
            nameSortAction.setValue(true, forKey: kChecked)
        default:
            noneSortAction.setValue(true, forKey: kChecked)
        }
        
        sortAlert.addAction(affiliationSortAction)
        sortAlert.addAction(nameSortAction)
        sortAlert.addAction(noneSortAction)
        sortAlert.addAction(cancelAction)
        
        self.present(sortAlert, animated: true, completion: nil)
    }
    
    fileprivate func sortDirectory() {
        let realm = try! Realm()
        let sortCriteria = UserDefaults.standard.value(forKey: kSort) as? String
        switch sortCriteria {
        case kAffiliation:
            self.individuals = realm.objects(Individual.self).sorted(byKeyPath: "_affiliation")
        case kName:
            self.individuals = realm.objects(Individual.self).sorted(byKeyPath: "firstName")
        default:
            self.individuals = realm.objects(Individual.self)
        }
        
        
    }
    
    private func filterDirectory() {
        let affiliationIntValue = UserDefaults.standard.integer(forKey: kFilter)
        let realm = try! Realm()

        if Individual.Affiliation(int: affiliationIntValue) == .joeShmo {
            self.individuals = realm.objects(Individual.self)
        } else {
            let affiliation = Individual.Affiliation(int: affiliationIntValue)
            let predicate = NSPredicate(format: "_affiliation = %@", affiliation.rawValue)
            self.individuals = realm.objects(Individual.self).filter(predicate)
        }
    }
    
    @objc func filterDoneButtonTapped(_ sender: UIButton) {
        filterPickerDelegate?.didSelectFilter()
        filterDirectory()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.individuals == nil ? 0 : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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
        guard individuals!.count > indexPath.row else { return }
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

extension DirectoryListTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var title = "None"
        switch row {
        case 1:
            title = Individual.Affiliation.jedi.description()
        case 2:
            title = Individual.Affiliation.resistance.description()
        case 3:
            title = Individual.Affiliation.firstOrder.description()
        case 4:
            title = Individual.Affiliation.sith.description()
        default:
            break
        }
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        UserDefaults.standard.set(row, forKey: kFilter)
    }
}















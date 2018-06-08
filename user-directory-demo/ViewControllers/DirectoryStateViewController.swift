//
//  DirectoryStateViewController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/23/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit
import Realm
import RealmSwift

enum DirectoryState: String {
    case loading
    case empty
    case loaded
}

class DirectoryStateViewController: UIViewController {
    
    @IBOutlet weak var stateContainerView: UIView!
    weak var filterView: UIView!
    
    var state: DirectoryState = .loading {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    var currentChildVC: UIViewController? {
        get {
            var vc: UIViewController? = nil
            switch state {
            case .loading:
                vc = loadingVC
            case .empty:
                vc = emptyStateVC
            case .loaded:
                vc = directoryListVC
            }
            return vc
        }
    }
    
    private lazy var loadingVC: LoadingViewController = {
        return AppStoryboard.Directory.instance.instantiateViewController(withIdentifier: LoadingViewController.storyboardID) as! LoadingViewController
    }()
    
    private lazy var emptyStateVC: EmptyStateViewController = {
        return AppStoryboard.Directory.instance.instantiateViewController(withIdentifier: EmptyStateViewController.storyboardID) as! EmptyStateViewController
    }()
    
    private lazy var directoryListVC: DirectoryListTableViewController = {
        return AppStoryboard.Directory.instance.instantiateViewController(withIdentifier: DirectoryListTableViewController.storyboardID) as! DirectoryListTableViewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let sortButton = UIBarButtonItem(title: "Sort", style: .plain, target: directoryListVC, action: #selector(DirectoryListTableViewController.showSortOptions))
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(showFilterPicker))
        self.navigationItem.rightBarButtonItems = [filterButton, sortButton]
        

        let realm = try! Realm()
        let individuals = realm.objects(Individual.self)
        if individuals.count == 0 {
            IndividualController.getIndividuals { (individuals) in
                self.state = individuals.count > 0 ? .loaded : .empty
            }
        } else {
            self.state = .loaded
        }
        
        updateUI()
    }
    
    func updateUI() {
        self.remove(childViewController: currentChildVC)
        var vc: UIViewController
        switch state {
        case .loading:
            vc = loadingVC
        case .empty:
            vc = emptyStateVC
        case .loaded:
            vc = directoryListVC
            directoryListVC.filterPickerDelegate = self
        }
        self.add(asChildViewController: vc, to: stateContainerView)
    }
    
    @objc func showFilterPicker() {
        let filterView = UIView()
        filterView.backgroundColor = UIColor.navColor
        filterView.layer.cornerRadius = 8
        
        stateContainerView.addSubview(filterView)
        filterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterView.widthAnchor.constraint(equalToConstant: 200),
            filterView.heightAnchor.constraint(equalToConstant: 200),
            filterView.centerXAnchor.constraint(equalTo: stateContainerView.centerXAnchor),
            filterView.centerYAnchor.constraint(equalTo: stateContainerView.centerYAnchor)
            ])
        
        let doneButton = UIButton()
        doneButton.setTitle("Done", for: .normal)
        doneButton.setTitleColor(.blue, for: .normal)
        doneButton.addTarget(directoryListVC, action: #selector(DirectoryListTableViewController.filterDoneButtonTapped(_:)), for: .touchUpInside)
        filterView.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.widthAnchor.constraint(equalTo: filterView.widthAnchor, multiplier: 1.0),
            doneButton.heightAnchor.constraint(equalToConstant: 50),
            doneButton.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
            doneButton.bottomAnchor.constraintEqualToSystemSpacingBelow(filterView.bottomAnchor, multiplier: 1.0)
            ])
        
        let pickerView = UIPickerView()
        pickerView.dataSource = directoryListVC
        pickerView.delegate = directoryListVC
        let filteredSelection = UserDefaults.standard.integer(forKey: kFilter)
        pickerView.selectRow(filteredSelection, inComponent: 0, animated: false)
        
        filterView.addSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pickerView.widthAnchor.constraint(equalTo: filterView.widthAnchor, multiplier: 1.0),
            pickerView.heightAnchor.constraint(equalToConstant: 150),
            pickerView.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
            pickerView.topAnchor.constraintEqualToSystemSpacingBelow(filterView.topAnchor, multiplier: 1.0)
            ])
        
        self.filterView = filterView
    }
    
    fileprivate func hidePickerView() {
        self.filterView.removeFromSuperview()
    }
}

extension DirectoryStateViewController: FilterPickerDelegate {
    
    func didSelectFilter() {
        hidePickerView()
    }
}

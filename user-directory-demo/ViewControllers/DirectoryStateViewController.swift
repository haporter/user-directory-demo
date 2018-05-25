//
//  DirectoryStateViewController.swift
//  user-directory-demo
//
//  Created by Andrew Porter on 5/23/18.
//  Copyright © 2018 Andrew Porter. All rights reserved.
//

import UIKit

enum DirectoryState: String {
    case loading
    case empty
    case loaded
}

class DirectoryStateViewController: UIViewController {
    
    @IBOutlet weak var stateContainerView: UIView!
    
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

        IndividualController.getIndividuals { (individuals) in
            self.state = individuals.count > 0 ? .loaded : .empty
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
            directoryListVC.update(with: IndividualController.individuals)
            vc = directoryListVC
        }
        self.add(asChildViewController: vc, to: stateContainerView)
    }
}

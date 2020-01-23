//
//  MainViewController.swift
//  Kudago
//
//  Created by Alexander Polyakov on 20/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private lazy var viewModel = MainViewModel(updateUI: { [weak self] in
            self?.tableView.reloadData()
        }, onErrorHappened: { [weak self] (error, info) in
            let alert = UIAlertController(title: nil, message: info, preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(ok)
            self?.present(alert, animated: true)
    })
    
    @IBOutlet private weak var dateSelectionContainerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    private weak var dateSelectionView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dateSelectionView = UINib(nibName: "DateSelectionView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? DateSelectionView {
            dateSelectionContainerView.addSubview(dateSelectionView)
            self.dateSelectionView = dateSelectionView
            dateSelectionView.onSelectedDateChanged = { [weak viewModel] date in
                viewModel?.date = date
            }
        }
        
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        viewModel.beginFetchEvents()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dateSelectionView?.frame = dateSelectionContainerView.bounds
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count// + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell else {
            print("❗️ERROR: Cell not found")
            return UITableViewCell()
        }
        if indexPath.row <  viewModel.events.count {
            cell.viewModel = viewModel.events[indexPath.row]
        }
        return cell
    }
}

extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.beginFetchEvents()
    }
}

extension MainViewController: UITableViewDelegate {
    
}

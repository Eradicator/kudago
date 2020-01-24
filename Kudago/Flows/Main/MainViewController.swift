//
//  MainViewController.swift
//  Kudago
//
//  Created by Alexander Polyakov on 20/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class MainViewController: UIViewController {
    private lazy var viewModel: MainViewModel = {
        let viewModel = MainViewModel(updateUI: { [weak self] in
            self?.tableView.contentOffset.y = 0
            self?.tableView.reloadData()
        })
        return viewModel
    }()
    
    private func setLoading(_ loading: Bool) {
        if loading {
            activityIndicatorView.startAnimating()
        }
        else {
            activityIndicatorView.stopAnimating()
        }
    }
    
    private func errorHappened(error: Error?, info: String?) {
        guard let info = info else {
            return
        }
        let alert = UIAlertController(title: nil, message: info, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @IBOutlet private weak var dateSelectionContainerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    private weak var dateSelectionView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let dateSelectionView = UINib(nibName: "DateSelectionView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? DateSelectionView {
            dateSelectionContainerView.addSubview(dateSelectionView)
            self.dateSelectionView = dateSelectionView
            
            dateSelectionView.onSelectedDateChanged = { [weak self] date in
                guard let self = self else {
                    return
                }
                self.viewModel.date = date
                self.setLoading(true)
                self.viewModel.beginFetchEvents(success: { [weak self] (_, _) in
                    self?.tableView.reloadData()
                    self?.setLoading(false)
                    }, failure: { [weak self] (error, info) in
                        self?.errorHappened(error: error, info: info)
                        self?.setLoading(false)
                })
            }
        }
        
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        
        self.setLoading(true)
        self.viewModel.beginFetchEvents(success: { [weak self] (_, _) in
            self?.tableView.reloadData()
            self?.setLoading(false)
            }, failure: { [weak self] (error, info) in
                self?.errorHappened(error: error, info: info)
                self?.setLoading(false)
        })
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        dateSelectionView?.frame = dateSelectionContainerView.bounds
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? EventViewController,
            let viewModel = sender as? EventDetailViewModel {
            vc.viewModel = viewModel
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventCell else {
            print("❗️ERROR: Cell not found")
            return UITableViewCell()
        }
        if indexPath.row < viewModel.events.count {
            cell.viewModel = viewModel.events[indexPath.row]
        }
        return cell
    }
}

extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.beginFetchEvents(success: { [weak tableView] startIndex, endIndex in
            let indexPaths = (startIndex ..< endIndex).map { return IndexPath(row: $0, section: 0) }
            tableView?.insertRows(at: indexPaths, with: .none)
            }, failure: { [weak self] error, info in
                self?.errorHappened(error: error, info: info)
        })
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.events[indexPath.row].createDetailViewModel(success: {[weak self] (detailViewModel) in
            self?.performSegue(withIdentifier: "ShowDetailEvent", sender: detailViewModel)
            }, failure: { [weak self] error, info in
                self?.errorHappened(error: error, info: info)
        })
    }
}

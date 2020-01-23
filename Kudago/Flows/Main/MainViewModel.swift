//
//  MainViewModel.swift
//  Kudago
//
//  Created by Alexander Polyakov on 22/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import Foundation

final class MainViewModel {
    private let updateUI: () -> ()
    private let onErrorHappened: (_ error: Error?, _ info: String) -> ()
    
    var date = Date() {
        didSet {
            task?.cancel()
            isTaskCancelled = true
            page = 0
            noMoreData = false
            fetchInProgress = false
            events = []
            updateUI()
            beginFetchEvents()
        }
    }
    
    private var page = 0
    private let pageSize = 10
    
    private(set) var events: [EventCellViewModel] = []
    
    private static let eventsURL = URL(string: "https://kudago.com/public-api/v1.4/events/")!
    
    init(updateUI: @escaping () -> (), onErrorHappened: @escaping (_ error: Error?, _ info: String) -> ()) {
        self.updateUI = updateUI
        self.onErrorHappened = onErrorHappened
    }
    
    private var eventsParameters: [String: String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return ["actual_since": dateString,
                "actual_until": dateString,
                "fields": "id,title,description,images",
                "page": "\(page)",
                "page_size": "\(pageSize)"
        ]
    }
    
    private var fetchInProgress = false
    private var noMoreData = false
    private var task: URLSessionTask? {
        didSet {
            isTaskCancelled = false
        }
    }
    private var isTaskCancelled = false
    
    func beginFetchEvents() {
        guard !fetchInProgress && !noMoreData,
            var components = URLComponents(url: type(of: self).eventsURL, resolvingAgainstBaseURL: false) else {
            return
        }
        page += 1
        components.queryItems = eventsParameters.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else {
            return
        }
        
        fetchInProgress = true
        task = URLSession.shared.eventsTask(with: url) { [weak self] (events, response, error) in
            DispatchQueue.main.async {
                self?.fetchInProgress = false
            }
            guard let events = events else {
                return
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    self?.onErrorHappened(error, "Fetch error, check network connection")
                }
                return
            }
            DispatchQueue.main.async {
                guard let results = events.results else {
                    self?.noMoreData = true
                    return
                }
                guard !(self?.isTaskCancelled ?? true) else {
                    return
                }
                self?.events.append(contentsOf: results.map { EventCellViewModel(model: $0) })
                self?.updateUI()
            }
            }
        task?.resume()
    }
}

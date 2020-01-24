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
    
    var date = Date() {
        didSet {
            task?.cancel()
            isTaskCancelled = true
            page = 0
            noMoreData = false
            fetchInProgress = false
            events = []
            self.updateUI()
        }
    }
    
    private var page = 0
    private let pageSize = 10
    
    private(set) var events: [EventCellViewModel] = []
    
    private static let eventsURL = URL(string: "https://kudago.com/public-api/v1.4/events/")!
    
    init(updateUI: @escaping () -> ()) {
        self.updateUI = updateUI
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
    
    func beginFetchEvents(success: @escaping (_ startIndex: Int, _ endIndex: Int) -> (),
                          failure: @escaping (_ error: Error?, _ info: String?) -> ()) {
        guard !fetchInProgress && !noMoreData,
            var components = URLComponents(url: type(of: self).eventsURL, resolvingAgainstBaseURL: false) else {
                failure(nil, nil)
                return
        }
        page += 1
        components.queryItems = eventsParameters.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else {
            failure(nil, nil)
            return
        }
        
        fetchInProgress = true
        task = URLSession.shared.eventsTask(with: url) { [weak self] (events, _, error) in
            DispatchQueue.main.async {
                self?.fetchInProgress = false
            }
            guard let events = events else {
                failure(nil, nil)
                return
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    failure(error, "Fetching failed, check network connection")
                }
                return
            }
            DispatchQueue.main.async {
                guard let results = events.results else {
                    self?.noMoreData = true
                    failure(nil, nil)
                    return
                }
                guard let self = self else {
                    failure(nil, nil)
                    return
                }
                guard !self.isTaskCancelled else {
                    failure(nil, nil)
                    return
                }
                
                let startIndex = self.events.count
                let endIndex = startIndex + results.count
                self.events.append(contentsOf: results.map { EventCellViewModel(model: $0) })
                success(startIndex, endIndex)
            }
        }
        task?.resume()
    }
}

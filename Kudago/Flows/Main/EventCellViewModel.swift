//
//  EventCellViewModel.swift
//  Kudago
//
//  Created by Alexander Polyakov on 23/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import Foundation

final class EventCellViewModel: Equatable {
    private let model: Result
    
    init(model: Result) {
        self.model = model
    }
    
    var imageLocation: String? {
        return model.images?.first?.image
    }
    
    var title: String {
        return model.title ?? ""
    }
    
    var descriptionText: String {
        return model.resultDescription ?? ""
    }
    
    static func == (lhs: EventCellViewModel, rhs: EventCellViewModel) -> Bool {
        return lhs.model.id == rhs.model.id
    }
    
    private static let eventDetailURLString = "https://kudago.com/public-api/v1.4/events/"
    
    private static let eventDetailParameters: [String: String] = ["fields": "id,title,images,place,body_text,price", "expand": "place"]
    
    func createDetailViewModel(success: @escaping (EventDetailViewModel) -> (),
                               failure: @escaping (_ error: Error?, _ info: String) -> ()) {
        guard let id = model.id else {
            failure(nil, "Event item not found")
            return
        }
        let noParamURL = URL(string: type(of: self).eventDetailURLString + "\(id)/")!
        guard var components = URLComponents(url: noParamURL, resolvingAgainstBaseURL: false) else {
            return
        }
        components.queryItems = type(of: self).eventDetailParameters.map { URLQueryItem(name: $0, value: $1) }
        guard let url = components.url else {
            return
        }
        print("fetching: \(url)")
        URLSession.shared.eventsDetailTask(with: url) {(eventsDetail, _, error) in
            guard let eventsDetail = eventsDetail else {
                DispatchQueue.main.async {
                    failure(error, "Server returned no data, please try again later")
                }
                return
            }
            guard error == nil else {
                DispatchQueue.main.async {
                    failure(error, "Fetching failed, check network connection")
                }
                return
            }
            DispatchQueue.main.async {
                success(EventDetailViewModel(model: eventsDetail))
            }
        }.resume()
    }
}

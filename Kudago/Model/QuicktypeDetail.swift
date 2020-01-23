// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let events = try? newJSONDecoder().decode(EventsDetail.self, from: jsonData)

//
// To read values from URLs:
//
//   let task = URLSession.shared.eventsTask(with: url) { events, response, error in
//     if let events = events {
//       ...
//     }
//   }
//   task.resume()

import Foundation

// MARK: - EventsDetail
struct EventsDetail: Codable {
    let id: Int?
    let title: String?
    let place: Place?
    let bodyText: String?
    let location: Location?
    let price: String?
    let isFree: Bool?
    let images: [ImageDetail]?
    let tags: [String]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, place
        case bodyText = "body_text"
        case location, price
        case isFree = "is_free"
        case images, tags
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.imageTask(with: url) { image, response, error in
//     if let image = image {
//       ...
//     }
//   }
//   task.resume()

// MARK: - ImageDetail
struct ImageDetail: Codable {
    let image: String?
    let source: SourceDetail?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.sourceTask(with: url) { source, response, error in
//     if let source = source {
//       ...
//     }
//   }
//   task.resume()

// MARK: - SourceDetail
struct SourceDetail: Codable {
    let name, link: String?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.locationTask(with: url) { location, response, error in
//     if let location = location {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Location
struct Location: Codable {
    let slug: String?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.placeTask(with: url) { place, response, error in
//     if let place = place {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Place
struct Place: Codable {
    let id: Int?
    let title, slug, address, phone: String?
    let subway, location: String?
    let siteURL: String?
    let isClosed: Bool?
    let coords: Coords?
    let isStub: Bool?
    
    enum CodingKeys: String, CodingKey {
        case id, title, slug, address, phone, subway, location
        case siteURL = "site_url"
        case isClosed = "is_closed"
        case coords
        case isStub = "is_stub"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.coordsTask(with: url) { coords, response, error in
//     if let coords = coords {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Coords
struct Coords: Codable {
    let lat, lon: Double?
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func eventsDetailTask(with url: URL, completionHandler: @escaping (EventsDetail?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let events = try? newJSONDecoder().decode(Events.self, from: jsonData)

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

// MARK: - Events
struct Events: Codable {
    let count: Int?
    let next, previous: String?
    let results: [Result]?
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.resultTask(with: url) { result, response, error in
//     if let result = result {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Result
struct Result: Codable {
    let id: Int?
    let title, resultDescription: String?
    let images: [Image]?
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case resultDescription = "description"
        case images
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

// MARK: - Image
struct Image: Codable {
    let image: String?
    let source: Source?
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

// MARK: - Source
struct Source: Codable {
    let name: String?
    let link: String?
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
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
    
    func eventsTask(with url: URL, completionHandler: @escaping (Events?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}

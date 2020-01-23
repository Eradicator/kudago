//
//  EventDetailViewModel.swift
//  Kudago
//
//  Created by Alexander Polyakov on 23/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import Foundation

final class EventDetailViewModel {
    private let model: EventsDetail
    
    init(model: EventsDetail) {
        self.model = model
    }
    
    var title: String {
        return model.title ?? ""
    }
    
    var place: String {
        guard let place = model.place else {
            return ""
        }
        let str1 = place.title ?? ""
        let str2 = place.address ?? ""
        let str3 = place.subway ?? ""
        let result = "\(str1)\n\(str2)\n\(str3)"
        return result
    }
    
    var tags: String {
        guard let tags = model.tags else {
            return ""
        }
        return tags.reduce("", { (item, acc) -> String in
            return acc + "#\(item)"
        })
    }
    
    var price: String {
        if model.isFree == true {
            return "Бесплатно"
        }
        return model.price ?? ""
    }
    
    var bodyText: NSAttributedString {
        guard let html = model.bodyText else {
            return NSAttributedString()
        }
        if let htmlData = NSString(string: html).data(using: String.Encoding.unicode.rawValue),
            let attributedString = try? NSAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.html], documentAttributes: nil) {
            return attributedString
        }
        return NSAttributedString()
    }
    
    var images: [String] {
        guard let images = model.images else {
            return []
        }
        return images.compactMap { $0.image }
    }
}

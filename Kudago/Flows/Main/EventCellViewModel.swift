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
}

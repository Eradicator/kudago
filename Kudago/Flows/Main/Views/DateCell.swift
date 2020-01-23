//
//  DateCell.swift
//  Kudago
//
//  Created by Alexander Polyakov on 20/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class DateCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!

    override func prepareForReuse() {
        super.prepareForReuse()
        date = nil
        label.text = ""
    }
    
    var date: Date? {
        didSet {
            guard let date = date else { return }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MMM-dd"
            label.text = dateFormatter.string(from: date)
        }
    }
}

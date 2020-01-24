//
//  EventCell.swift
//  Kudago
//
//  Created by Alexander Polyakov on 22/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class EventCell: UITableViewCell {
    @IBOutlet private weak var theImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    private weak var cancellationToken: URLSessionTask?
    
    weak var viewModel: EventCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            if let oldValue = oldValue, viewModel == oldValue {
                return
            }
            
            if let imageLocation = viewModel.imageLocation {
                cancellationToken = theImageView.setImage(with: imageLocation)
            }
            titleLabel.text = viewModel.title
            
            if let htmlData = NSString(string: viewModel.descriptionText).data(using: String.Encoding.unicode.rawValue),
                let attributedString = try? NSAttributedString(data: htmlData, options: [NSAttributedString.DocumentReadingOptionKey.documentType:
                    NSAttributedString.DocumentType.html], documentAttributes: nil) {
                descriptionLabel.attributedText = attributedString
            }
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellationToken?.cancel()
        theImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
        viewModel = nil
    }
}

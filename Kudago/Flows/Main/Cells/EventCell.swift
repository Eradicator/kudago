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
    
    weak var viewModel: EventCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {
                return
            }
            if let oldValue = oldValue, viewModel == oldValue {
                return
            }
            
            if let imageLocation = viewModel.imageLocation {
                setImage(imageLocation)
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
        theImageView.image = nil
        titleLabel.text = ""
        descriptionLabel.text = ""
        viewModel = nil
    }
    
    private func setImage(_ URLString: String) {
        guard let url = URL(string: URLString) else {
            return
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard error == nil,
                let data = data,
                let image = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self?.theImageView.image = image
            }
        }.resume()
    }
}

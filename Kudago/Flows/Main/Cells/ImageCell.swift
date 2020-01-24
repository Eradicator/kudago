//
//  ImageCell.swift
//  Kudago
//
//  Created by Alexander Polyakov on 23/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class ImageCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cancellationToken?.cancel()
        imageView.image = nil
    }

    private weak var cancellationToken: URLSessionTask?
    
    func setImage(with location: String) {
        cancellationToken = imageView.setImage(with: location)
    }
}

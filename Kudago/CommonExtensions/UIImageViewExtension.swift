//
//  UIImageViewExtension.swift
//  Kudago
//
//  Created by Alexander Polyakov on 23/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

extension UIImageView {
    func setImage(with location: String) -> URLSessionTask? {
        guard let url = URL(string: location) else {
            return nil
        }
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard error == nil,
                let data = data,
                let image = UIImage(data: data) else {
                    return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
        }
        task.resume()
        return task
    }
}

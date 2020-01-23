//
//  EventViewController.swift
//  Kudago
//
//  Created by Alexander Polyakov on 23/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class EventViewController: UIViewController {
    var viewModel: EventDetailViewModel!
    
    @IBOutlet private weak var placeLabel: UILabel!
    @IBOutlet private weak var tagsLabel: UILabel!
    @IBOutlet private weak var bodyTextView: UITextView!
    @IBOutlet private weak var bodyTextViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.title
        placeLabel.text = viewModel.place
        tagsLabel.text = viewModel.tags
        priceLabel.text = viewModel.price
        bodyTextView.attributedText = viewModel.bodyText
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        bodyTextViewHeightConstraint.constant = bodyTextView.calculateViewHeightWithCurrentWidth()
    }
}

fileprivate extension UITextView {
    // Note: This will trigger a text rendering!
    func calculateViewHeightWithCurrentWidth() -> CGFloat {
        let textWidth = self.frame.width -
            self.textContainerInset.left -
            self.textContainerInset.right -
            self.textContainer.lineFragmentPadding * 2.0 -
            self.contentInset.left -
            self.contentInset.right
        
        let maxSize = CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude)
        var calculatedSize = self.attributedText.boundingRect(with: maxSize,
                                                              options: [.usesLineFragmentOrigin, .usesFontLeading],
                                                                      context: nil).size
        calculatedSize.height += self.textContainerInset.top
        calculatedSize.height += self.textContainerInset.bottom
        
        return ceil(calculatedSize.height)
    }
}

extension EventViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if UIApplication.shared.canOpenURL(URL) {
            UIApplication.shared.open(URL, options: [:], completionHandler: nil)
        }
        return false
    }
}

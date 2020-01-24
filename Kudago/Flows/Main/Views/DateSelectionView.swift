//
//  DateSelectionView.swift
//  Kudago
//
//  Created by Alexander Polyakov on 20/01/2020.
//  Copyright © 2020 Eradicator_kai. All rights reserved.
//

import UIKit

final class DateSelectionView: UIView {
    var onSelectedDateChanged: ((Date) -> ())?
    
    private static let pagesCount = 10000
    private static let defaultPage: Int = pagesCount / 2
    
    private var cellWidth: CGFloat = 0
    private var cellHeight: CGFloat = 0
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private weak var pickerResponderView: PickerResponderView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(UINib(nibName: "DateCell", bundle: nil), forCellWithReuseIdentifier: "DateCell")
        
        selectedDate = Date()
        let pickerResponderView = PickerResponderView(minDate: date(for: 0), maxDate: date(for: type(of: self).pagesCount - 1)) { [weak self] (date) in
            guard let self = self else {
                return
            }
            let newPage = self.page(for: date)
            self.collectionView.scrollToItem(at: IndexPath(item: newPage, section: 0), at: .centeredHorizontally, animated: true)
        }
        
        addSubview(pickerResponderView)
        self.pickerResponderView = pickerResponderView
    }
    
    // dispatch_once
    private lazy var preScrollToDefaultItemOnce: Void = {
        collectionView.scrollToItem(at: IndexPath(item: type(of: self).defaultPage, section: 0), at: .centeredHorizontally, animated: false)
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cellWidth = frame.size.width
        cellHeight = frame.size.height
        
        _ = preScrollToDefaultItemOnce
    }
    
    private func date(for page: Int) -> Date {
        let daysDiff = page - type(of: self).defaultPage
        let calendar = Calendar.autoupdatingCurrent
        let today = calendar.date(from: calendar.dateComponents([.day, .year, .month], from: Date()))
        let date = calendar.date(byAdding: .day, value: daysDiff, to: today ?? Date())
        return date ?? Date()
    }
    
    private func page(for date: Date) -> Int{
        let minDate = self.date(for: 0)
        
        let daysDiff = Calendar.autoupdatingCurrent.dateComponents([.day], from: minDate, to: date)
        return daysDiff.day ?? 0
    }
    
    private func centerCurrentItem () {
        let centerPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.frame.midX, y: 0)
        if let path = collectionView.indexPathForItem(at: centerPoint) {
            collectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        }
    }
    
    private var selectedDate = Date() {
        didSet {
            guard oldValue != selectedDate else {
                return
            }
            onSelectedDateChanged?(selectedDate)
        }
    }
    
    @IBAction func didTapButton(_ sender : UIButton ) {
        let scrollDistance: CGFloat = sender.tag == 1 ? cellWidth : -cellWidth // tag 0 - prev, 1 - next
        let centerPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.frame.midX + scrollDistance, y: 0)
        if let path = collectionView.indexPathForItem(at: centerPoint) {
            collectionView.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
        }
    }
}

extension DateSelectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return type(of: self).pagesCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as? DateCell else {
            print("❗️ERROR: Cell not found")
            return UICollectionViewCell()
        }
        cell.date = date(for: indexPath.item)
        return cell
    }
}

extension DateSelectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pickerResponderView?.date = date(for: indexPath.item)
        _ = pickerResponderView?.becomeFirstResponder()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCurrentItem()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        centerCurrentItem()
        
        let page = Int(scrollView.contentOffset.x) / Int(cellWidth)
        selectedDate = date(for: page)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCurrentItem()
        }
    }
}

extension DateSelectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

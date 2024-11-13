//
//  CalendarLayout.swift
//  Practice_Calendar
//
//  Created by anh.nguyen3 on 7/11/24.
//
import Foundation
import UIKit

class CalendarLayout: UICollectionViewLayout {
    var dataSource: CalendarDataSource!

    private var cache = [UICollectionViewLayoutAttributes]()

    let itemHeight: CGFloat = 60 // cell height, weekday header height, timeSlot header height
    let itemWidth: CGFloat = UIScreen.main.bounds.width / 8 // cell width, weekday header width, timeSlot header width

    override func prepare() {
        guard cache.isEmpty else { return }

        // weekday header
        for (index, _) in dataSource.weekdays.enumerated() {
            let indexPath = IndexPath(item: index, section: CalendarDataSource.Section.weekdayHeader.rawValue)
            let frame = CGRect(
                x: CGFloat(index) * itemWidth + itemWidth, // + width of time slot column
                y: 0,
                width: itemWidth,
                height: itemHeight
            )
            let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, with: indexPath)
            attribute.frame = frame
            cache.append(attribute)
        }

        // timeslot header
        for (index, _) in dataSource.timeSlots.enumerated() {
            let indexPath = IndexPath(item: index, section: CalendarDataSource.Section.timeSlotHeader.rawValue)
            let frame = CGRect(
                x: 0,
                y: CGFloat(index) * itemHeight + itemHeight,
                width: itemWidth,
                height: itemHeight
            )
            let attribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "timeslotHeader", with: indexPath)
            attribute.frame = frame
            cache.append(attribute)
        }

        // cells
        for timeSlotIndex in 0..<dataSource.timeSlots.count  {
                for weekdayIndex in 0..<dataSource.weekdays.count {
                    let indexPath = IndexPath(item: weekdayIndex + timeSlotIndex * dataSource.weekdays.count, section: CalendarDataSource.Section.eventCell.rawValue)
                    let frame = CGRect(
                        x: CGFloat(weekdayIndex) * itemWidth + itemWidth,
                        y: CGFloat(timeSlotIndex) * itemHeight + itemHeight,
                        width: itemWidth,
                        height: itemHeight
                    )
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = frame
                    cache.append(attributes)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cache.filter { $0.frame.intersects(rect) }
    }

    // TODO: use if want to adjust item attribute (layout, shaddow, color,...)
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return cache[indexPath.item + dataSource.weekdays.count +  dataSource.timeSlots.count]
//    }
//
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return cache[indexPath.item]
//    }
}

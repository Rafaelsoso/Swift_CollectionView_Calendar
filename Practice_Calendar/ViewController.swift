//
//  ViewController.swift
//  Practice_Calendar
//
//  Created by anh.nguyen3 on 7/11/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!

    // MARK: - Injections
    var dataSource: CalendarDataSource = CalendarDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // data
        let events: [Event] = [
            Event(day: 0, startTime: "01:00", endTime: "01:30", title: "Math 101"),
            Event(day: 1, startTime: "10:00", endTime: "12:00", title: "Biology 201")
        ]
        let weekDays: [String] = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        let timeSlots = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
        dataSource.events = events
        dataSource.weekdays = weekDays
        dataSource.timeSlots = timeSlots

        // layout
        let layout = CalendarLayout()
        layout.dataSource = dataSource
        collectionView.collectionViewLayout = layout

        // register cells
        let headerViewNib = UINib(nibName: "WeekdayHeader", bundle: nil)
        collectionView.register(headerViewNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "weekdayHeader")
        collectionView.register(headerViewNib, forSupplementaryViewOfKind: "timeslotHeader", withReuseIdentifier: "weekdayHeader")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellIdentifier")
    }
}

// MARK: - CollectionView
extension ViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case CalendarDataSource.Section.weekdayHeader.rawValue:
            return dataSource.weekdays.count
        case CalendarDataSource.Section.timeSlotHeader.rawValue:
            return dataSource.timeSlots.count
        case CalendarDataSource.Section.eventCell.rawValue:
            return dataSource.weekdays.count * dataSource.timeSlots.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.section == CalendarDataSource.Section.eventCell.rawValue else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellIdentifier", for: indexPath)
            return cell
        }

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "calendarCell", for: indexPath) as! CalendarCell
        cell.title.text = ""

        // Check if there are events in this cell's time slot
        let dayIndex = indexPath.item % (dataSource.weekdays.count)
        let timeSlotIndex = indexPath.item / (dataSource.weekdays.count)

        let startTime = String(format: "%02d:00", timeSlotIndex) // Start at 8:00 AM
        let endTime = String(format: "%02d:00", timeSlotIndex + 1) // Each slot is 1 hour
        
        // Find event in this time slot
        if let event = dataSource.events.first(where: { $0.day == dayIndex && $0.startTime <= endTime && $0.endTime > startTime }) {
            cell.title.text = event.title // Set the event title
            cell.backgroundColor = .green.withAlphaComponent(0.5)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "weekdayHeader", for: indexPath) as! WeekdayHeader
            header.backgroundColor = .brown.withAlphaComponent(0.5)
            header.title.text = dataSource.weekdays[indexPath.item]
            return header
        } else if kind == "timeslotHeader" {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "weekdayHeader", for: indexPath) as! WeekdayHeader
            header.title.text = dataSource.timeSlots[indexPath.item]
            header.backgroundColor = .brown.withAlphaComponent(0.5)
            return header
        }
        return UICollectionReusableView() // Fallback
    }
    
}

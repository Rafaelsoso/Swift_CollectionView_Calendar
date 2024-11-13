//
//  CalendarDataSource.swift
//  Practice_Calendar
//
//  Created by anh.nguyen3 on 7/11/24.
//

import Foundation

class CalendarDataSource: NSObject {
    enum Section: Int {
        case weekdayHeader
        case timeSlotHeader
        case eventCell
    }

    var weekdays: [String] = []
    var timeSlots: [String] = []
    var events: [Event] = []

}

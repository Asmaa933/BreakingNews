//
//  Date+Ext.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 25/12/2021.
//

import Foundation

extension Date {
    func getDifferenceInMinutes() -> Int {
        let currentDate = Date()
        let component: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = Calendar.current.dateComponents(component, from: self, to: currentDate)
        return difference.minute ?? 0
    }
}

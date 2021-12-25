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
        let difference = Int(self.timeIntervalSince1970 - currentDate.timeIntervalSince1970)
        let hours = difference / 3600
        let minutes = (difference - hours * 3600) / 60
        return minutes
    }
}

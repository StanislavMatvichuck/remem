//
//  EntensionPoint.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 26.01.2022.
//

import Foundation

extension Point {
    var time: String {
        guard let date = dateTime else { return "time" }

        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium

        let dateString = formatter.string(from: date)

        return dateString
    }
}

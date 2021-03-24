//
//  Dateformatter+ShortDebug.swift
//  One Rep Max
//
//  Created by Nick Hayward on 3/22/21.
//

import Foundation

extension Date {
    var debugShort: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: self)
    }
}

//
//  DateFormatter+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/28/21.
//

import Foundation

extension DateFormatter {
    public enum DateFormatType: String {
        case yearMonthDay = "yyyy-MM-dd"
    }
    
    static func getDateString(with date: Date, dateType: DateFormatter.DateFormatType) -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = dateType.rawValue
        
        return dateFormat.string(from: date)
    }
}

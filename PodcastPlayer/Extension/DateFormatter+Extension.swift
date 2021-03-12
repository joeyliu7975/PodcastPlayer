//
//  DateFormatter+Extension.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 2/28/21.
//

import Foundation

protocol DateFormatterType {
    func string(from date: Date) -> String
    func date(from string: String) -> Date?
}

extension DateFormatter: DateFormatterType {}

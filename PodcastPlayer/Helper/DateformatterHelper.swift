//
//  DateformatterHelper.swift
//  PodcastPlayer
//
//  Created by Joey Liu on 3/12/21.
//

import Foundation

public final class DateformatterHelper {
    
    static let shared = DateformatterHelper()
    
    private init() {}
    
    private let cachedDateFormattersQueue = DispatchQueue(label: "com.boles.date.formatter.queue")
    
    private var cachedDateFormatters = [String : DateFormatter]()
    
    // MARK: - Cached Formatters
    private func cachedDateFormatter(withFormat format: DateformatterHelper.DateFormatType) -> DateFormatter {
        return cachedDateFormattersQueue.sync {
            let key = format.rawValue
            
            if let cachedFormatter = cachedDateFormatters[key] {
                return cachedFormatter
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = format.rawValue
            
            cachedDateFormatters[key] = dateFormatter
            
            return dateFormatter
        }
    }
    
    //MARK: -Format Homepage episode feed date
    public func formatEpisodeFeedDate(_ date: Date) -> String {
        let dateFormatter = cachedDateFormatter(withFormat: .yearMonthDay)
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
    
    //MARK: -Format Take date to specific Date
    public func convertDateFrom(string: String,from dateForm:DateformatterHelper.DateFormatType) -> String {
        
        let startFormatter = cachedDateFormatter(withFormat: dateForm)
                
        guard let date = startFormatter.date(from: string) else { return "Unknown"}
        
        return formatEpisodeFeedDate(date)
    }
}

extension DateformatterHelper {
    public enum DateFormatType: String {
        case yearMonthDay = "yyyy-MM-dd"
        case detail = "E, d MMM yyyy HH:mm:ss Z"
    }
}

//
//  TimestampProvider.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 19.04.2023.
//

import Foundation

protocol ICurrentTimeProvider {
    func getCurrentTimeAsString() -> String
    func getCurrentTime() -> Date
    func getCurrentTimeAsString(date: Date) -> String
}

final class CurrentTimeProvider: ICurrentTimeProvider
{
    static let shared = CurrentTimeProvider()
    
    private init() {}

    private func getCurrentTimeImpl() -> Date{
        return Date()
    }

    private func formatCurrentTime(dateFormatInput dataToConvert: Date) -> String
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss.SSS"
        return formatter.string(from: dataToConvert)
    }

    public func getCurrentTimeAsString() -> String {
        let now = getCurrentTimeImpl()
        return formatCurrentTime(dateFormatInput: now)
    }

    public func getCurrentTime() -> Date
    {
        return getCurrentTimeImpl()
    }

    public func getCurrentTimeAsString(date: Date) -> String
    {
        return formatCurrentTime(dateFormatInput: date)
    }
}

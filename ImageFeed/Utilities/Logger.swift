//
//  Logger.swift
//  ImageFeed
//
//  Created by Дмитрий Никишов on 19.04.2023.
//

import Foundation

final class Logger {
    static let currentTimeStampProvider = CurrentTimeProvider.shared

    static func info(_ infoData: String) {
        let dataToPrint = "[Info] " + currentTimeStampProvider.getCurrentTimeAsString() + " : " + infoData
        print(dataToPrint)
    }

    static func error(_ infoData: String ) {
        let dataToPrint = "[Error] " + currentTimeStampProvider.getCurrentTimeAsString() + " : " + infoData
        print(dataToPrint)
    }

    static func debug(_ infoData: String ) {
        let dataToPrint = "[Debug] " + currentTimeStampProvider.getCurrentTimeAsString() + " : " + infoData
        print(dataToPrint)
    }
}

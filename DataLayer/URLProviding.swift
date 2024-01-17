//
//  LocalFile.swift
//  Application
//
//  Created by Stanislav Matvichuck on 14.03.2023.
//

import Foundation

public protocol URLProviding {
    var url: URL { get }
}

public enum LocalFile: URLProviding {
    case pdfReport, widget, testingPdfReport, testingWidget, eventsQuerySorter, testingEventsQuerySorter

    public var url: URL {
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let containerDir = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.remem.io")!

        switch self {
        case .pdfReport: return documentDir.appendingPathComponent("DefaultReport.pdf")
        case .testingPdfReport: return documentDir.appendingPathComponent("TestingReport.pdf")
        case .widget: return containerDir.appendingPathComponent("RememWidgets.plist")
        case .testingWidget: return containerDir.appendingPathComponent("RememTestingWidgets.plist")
        case .eventsQuerySorter: return documentDir.appendingPathComponent("EventsQuerySorter.plist")
        case .testingEventsQuerySorter: return documentDir.appendingPathComponent("TestingEventsQuerySorter.plist")
        }
    }
}

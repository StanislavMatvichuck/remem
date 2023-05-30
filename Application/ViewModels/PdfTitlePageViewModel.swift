//
//  PdfTitlePageViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 30.05.2023.
//

import Domain
import Foundation

struct PdfTitlePageViewModel {
    static let title = String(localizationId: "pdf.titlePage.title")
    static let start = String(localizationId: "pdf.titlePage.start")
    static let finish = String(localizationId: "pdf.titlePage.finish")

    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    let readableStart: String
    let readableFinish: String
    let eventTitle: String

    init(event: Event, dateCreated: Date) {
        eventTitle = event.name
        readableStart = Self.formatter.string(from: event.dateCreated)
        readableFinish = Self.formatter.string(from: dateCreated)
    }
}

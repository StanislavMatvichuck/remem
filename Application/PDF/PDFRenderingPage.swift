//
//  PDFRenderingPage.swift
//  Application
//
//  Created by Stanislav Matvichuck on 24.02.2024.
//

import Foundation

enum PdfRenderingPage {
    case title(String)
    case summary(SummaryViewModel)
    case time(HourDistributionViewModel)
    case week(DayOfWeekViewModel)
    case weekInYear(WeekViewModelWithScrollIndex)

    var title: String? { switch self {
    case .title: return nil
    case .summary: return nil
    case .time: return localizationIdPdfPageTime
    case .week: return localizationIdPdfPageWeek
    case .weekInYear: return nil
    }}

    var viewModel: Any { switch self {
    case .title(let vm): return vm
    case .summary(let vm): return vm
    case .time(let vm): return vm
    case .week(let vm): return vm
    case .weekInYear(let vm): return vm
    }}

    var renderer: PDFRendering { switch self {
    case .title: return PDFWritingTitlePageView()
//    case .summary: return SummaryView()
    case .time: return HourDistributionView()
    case .week: return DayOfWeekView()
    case .weekInYear: return WeekView(list: WeekView.makeList(), viewModel: Loadable<WeekViewModel>())
    default: fatalError("todo: implement pdf rendering for a view")
    }}

    private static let pageWidth = CGFloat.screenW
    static let size = CGRect(
        origin: .zero,
        size: CGSize(
            width: Self.pageWidth,
            height: Self.pageWidth
        )
    )
}

struct WeekViewModelWithScrollIndex {
    let viewModel: WeekViewModel
    let scrollIndex: Int
}

//
//  GlobalConstants.swift
//  Application
//
//  Created by Stanislav Matvichuck on 04.06.2024.
//

import Foundation

/// Accessible by `Application` and `Widgets` targets

let UISceneConfigurationName = "Default Configuration"
let SecurityApplicationGroupId = "group.remem.io"
let WidgetStorageFile = "RememWidgets.plist"
let WidgetTimelineKind = "RememWidgets"

let collectionViewDataSourceWeekError = "view has no access to viewModel"

let localizationIdButtonAddHappening = "button.addHappening"
let localizationIdButtonCreate = "button.create"
let localizationIdDrop = "dropToDelete"
let localizationIdEventsListNew = "eventsList.new"
let localizationIdEventsListTitle = "eventsList.title"
let localizationIdEventsListHintEmpty = "eventsList.hint.empty"
let localizationIdEventsListHintFirstHappening = "eventsList.hint.firstHappening"
let localizationIdEventsListHintFirstVisit = "eventsList.hint.firstVisit"
let localizationIdEventsListHintPermanent = "eventsList.hint.permanentlyVisible"
let localizationIdEventsListEventCellTimeSince = "eventsList.timeSince"
let localizationIdOrderingTitle = "eventsSorting.title"
let localizationIdOrderingName = "eventsSorting.name"
let localizationIdOrderingTotal = "eventsSorting.total"
let localizationIdOrderingDateCreated = "eventsSorting.dateCreated"
let localizationIdOrderingManual = "eventsSorting.manual"
let localizationIdGoalsCreate = "goals.create"
let localizationIdGoalsCreatedAt = "goal.createdAt"
let localizationIdGoalLeftToAchieve = "goal.leftToAchieve"
let localizationIdGoalAchievedAt = "goal.achievedAt"
let localizationIdPdfButtonShare = "pdf.share"
let localizationIdPdfButtonDownload = "pdf.download"
let localizationIdPdfButtonCreate = "pdf.create"
let localizationIdPdfTitle = "pdf.titlePage.title"
let localizationIdPdfStart = "pdf.titlePage.start"
let localizationIdPdfFinish = "pdf.titlePage.finish"
let localizationIdPdfPageFirst = "Swipes recording report\n"
let localizationIdPdfPageTime = "Time"
let localizationIdPdfPageWeek = "Week"
let localizationIdSummaryTotal = "summary.total"
let localizationIdSummaryWeekAverage = "summary.weekAverage"
let localizationIdSummaryDayAverage = "summary.dayAverage"
let localizationIdSummaryDaysTracked = "summary.daysTracked"
let localizationIdSummaryDaysSinceLastHappening = "summary.daysSinceLastHappening"
let localizationIdSummaryDateStart = "summary.dateStart"
let localizationIdSummaryDateEnd = "summary.dateEnd"
let localizationIdWeekNumber = "Week.weekNumberDescription"
let localizationIdWeekTotal = "Week.totalNumberDescription"
let localizationIdWidgetEmpty = "widget.emptyRow"

let dayDetailsDateFormat = "d MMMM"
let weekPageDateFormat = "LLLL"

let collectionCellReuseIdentifierHint = "HintCell"
let collectionCellReuseIdentifierEvent = "EventCell"
let collectionCellReuseIdentifierCreate = "CreateEventCell"
let collectionCellReuseIdentifierGoalCreate = "CreateGoalViewModel"
let collectionCellReuseIdentifierWeekPage = "WeekPageView"
let collectionCellReuseIdentifierDayHappening = "DayHappeningCell"

//
//  GoalsViewModel.swift
//  Application
//
//  Created by Stanislav Matvichuck on 27.02.2024.
//

import Foundation

struct GoalsViewModel {
    enum Section: Int, CaseIterable { case goals, createGoal }

    let cells: [Section: [any GoalCellViewModeling]]

    init(cells: [Section: [any GoalCellViewModeling]] = [:]) {
        self.cells = cells
    }

    /// Order is critical
    var sections: [Section] {
        var result: [Section] = []
        for section in Section.allCases {
            if cells[section] != nil { result.append(section) }
        }
        return result
    }

    func cellsIdentifiers(for section: Section) -> [String] { cells[section]?.map { $0.id } ?? [] }
    func cell(identifier: String) -> (any GoalCellViewModeling)? {
        for section in sections {
            if let cells = cells[section] {
                for cell in cells { if cell.id == identifier { return cell } }
            }
        }
        return nil
    }

    func cellsRequireReconfigurationIds(oldValue: GoalsViewModel) -> [String] { cells[.goals]?.map { $0.id } ?? [] }
}

//
//  ViewMain.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

final class EventsListView: UIView {
    let input = EventInputView()

    let table: UITableView = {
        let table = UITableView(al: true)
        table.backgroundColor = .clear
        table.separatorStyle = .none
        return table
    }()

    lazy var dataSource = EventsListDataSource(table: table)

    var viewModel: EventsListViewModel? { didSet {
        guard let viewModel else { return }
        dataSource.viewModel = viewModel
        configureContent(viewModel)
    }}

    init() {
        super.init(frame: .zero)
        backgroundColor = .bg
        addAndConstrain(table)
        addAndConstrain(input)
    }

    func configureContent(_ viewModel: EventsListViewModel) {
        if let renamedItem = viewModel.renamedItem {
            input.rename(oldName: renamedItem.title)
        } else if viewModel.inputVisible {
            input.show(value: viewModel.inputContent)
        }
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

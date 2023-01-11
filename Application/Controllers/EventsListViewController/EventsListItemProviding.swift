//
//  EventsListItemProtocol.swift
//  Application
//
//  Created by Stanislav Matvichuck on 06.01.2023.
//

import UIKit

protocol EventsListItemProviding {
    func register(_ table: UITableView)
    func dequeue(
        _ table: UITableView,
        indexPath: IndexPath,
        viewModel: EventsListItemViewModel
    ) -> UITableViewCell
}

struct HintItemProvider: EventsListItemProviding {
    func register(_ table: UITableView) {
        table.register(HintItem.self, forCellReuseIdentifier: "HintItem")
    }

    func dequeue(_ table: UITableView, indexPath: IndexPath, viewModel: EventsListItemViewModel) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(
            withIdentifier: "HintItem",
            for: indexPath
        ) as? HintItem
        else { fatalError("unable to dequeue typed cell") }

        guard let itemViewModel = viewModel as? HintItemViewModel
        else { fatalError("unable to cast item view model") }

        cell.viewModel = itemViewModel
        return cell
    }
}

struct EventItemProvider: EventsListItemProviding {
    func register(_ table: UITableView) {
        table.register(EventItem.self, forCellReuseIdentifier: "EventItem")
    }

    func dequeue(_ table: UITableView, indexPath: IndexPath, viewModel: EventsListItemViewModel) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(
            withIdentifier: "EventItem",
            for: indexPath
        ) as? EventItem
        else { fatalError("unable to dequeue typed cell") }

        guard let itemViewModel = viewModel as? EventItemViewModel
        else { fatalError("unable to cast item view model") }

        cell.viewModel = itemViewModel
        return cell
    }
}

struct FooterItemProvider: EventsListItemProviding {
    func register(_ table: UITableView) {
        table.register(FooterItem.self, forCellReuseIdentifier: "FooterItem")
    }

    func dequeue(_ table: UITableView, indexPath: IndexPath, viewModel: EventsListItemViewModel) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(
            withIdentifier: "FooterItem",
            for: indexPath
        ) as? FooterItem
        else { fatalError("unable to dequeue typed cell") }

        guard let itemViewModel = viewModel as? FooterItemViewModel
        else { fatalError("unable to cast item view model") }

        cell.viewModel = itemViewModel
        return cell
    }
}

//
//  ViewPointsList.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 25.01.2022.
//

import UIKit

class ViewPointsList: UIView {
    //

    // MARK: - Public properties

    //

    let viewTable: UITableView = {
        let view = UITableView(frame: .zero)

        view.register(CellPoint.self, forCellReuseIdentifier: CellPoint.reuseIdentifier)
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.contentInsetAdjustmentBehavior = .never
        view.backgroundColor = .systemBackground

        view.tableFooterView = UIView()
        view.allowsSelection = false
        view.separatorStyle = .none
//        view.transform = CGAffineTransform(scaleX: 1, y: -1)
//        view.showsVerticalScrollIndicator = false

        return view
    }()

    //

    // MARK: - Private properties

    //
    //

    // MARK: - Initialization

    //
    init() {
        super.init(frame: .zero)
        
        addAndConstrain(viewTable)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //

    // MARK: - Behaviour

    //
    func showEmptyState() {}
    func hideEmptyState() {}
}

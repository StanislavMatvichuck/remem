//
//  ExtensionString.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.09.2022.
//

import Foundation

extension String {
    init(localizationId: String) {
        self = NSLocalizedString(localizationId, comment: "")
    }
}

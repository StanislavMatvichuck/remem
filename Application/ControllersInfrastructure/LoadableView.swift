//
//  LoadableView.swift
//  Application
//
//  Created by Stanislav Matvichuck on 28.05.2024.
//

import UIKit

let LoadingViewOverlayTag = 999

protocol LoadableView: UIView {}

extension LoadableView {
    private var loadingViewOverlay: UIView? { subviews.filter { $0.tag == LoadingViewOverlayTag }.first }

    func displayLoading() {
        guard loadingViewOverlay == nil else { return }

        let view = UIView(al: true)
        view.tag = LoadingViewOverlayTag
        view.backgroundColor = .red
        addAndConstrain(view)
    }

    func disableLoadingCover() { loadingViewOverlay?.removeFromSuperview() }
}

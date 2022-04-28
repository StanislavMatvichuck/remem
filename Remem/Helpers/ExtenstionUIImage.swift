//
//  ExtenstionUIImage.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 28.04.2022.
//

import UIKit

extension UIImage {
    /// This method creates an image of a view
    /// it is used in `EntriesListController` to create `UIContextualAction` views for flipped upside down table view
    convenience init?(view: UIView) {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        let image = renderer.image { rendererContext in
            view.layer.render(in: rendererContext.cgContext)
        }

        if let cgImage = image.cgImage {
            self.init(cgImage: cgImage, scale: UIScreen.main.scale, orientation: .downMirrored)
        } else {
            return nil
        }
    }
}

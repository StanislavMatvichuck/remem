//
//  AtlasProducing.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 02.01.2024.
//

import iOSSnapshotTestCase

protocol AtlasProducing: FBSnapshotTestCase {
    var atlas: UIView! { get set }
}

extension AtlasProducing {
    var scale: CGFloat { 0.5 }
    var spacing: CGFloat { 16.0 * scale }
    var width: CGFloat { UIScreen.main.bounds.width }
    var height: CGFloat { UIScreen.main.bounds.height }

    func configureAtlasView() {
        atlas = UIView(frame: CGRect(origin: .zero, size: CGSize(width: spacing, height: spacing)))
        atlas.translatesAutoresizingMaskIntoConstraints = false
        atlas.backgroundColor = UIColor.purple
    }
    
    func makeAtlasFor(testNames: [String]) {
        atlas.addAndConstrain(makeRow(testNames: testNames), constant: spacing)
        
        FBSnapshotVerifyView(atlas)
    }
    
    func makeImageViewFor(testName: String?) -> UIImageView {
        let view = UIImageView(image: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: width * scale),
            view.heightAnchor.constraint(equalToConstant: height * scale),
        ])
        
        let directory = getReferenceImageDirectory(withDefault: nil).appending("_64")
        let path = "\(directory)/\(testName ?? "nil").png"
        
        if let image = UIImage(contentsOfFile: path) {
            view.image = image
        } else { print("image not found for \(path)") }
        
        return view
    }
    
    func makeRow(testNames: [String?]) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = spacing * scale
        
        for name in testNames {
            horizontalStack.addArrangedSubview(makeImageViewFor(testName: name))
        }
        
        return horizontalStack
    }
}

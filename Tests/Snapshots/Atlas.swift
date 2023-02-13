//
//  SnapshotsAtlas.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 15.01.2023.
//

import iOSSnapshotTestCase
import UIKit

final class ZAtlas: FBSnapshotTestCase {
    var scale: CGFloat { 0.5 }
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    var spacing: CGFloat { 16.0 * scale }
    var atlasSize: CGSize { CGSize(width: 6 * (width + spacing) * scale, height: 1 * (height + spacing) * scale) }
    var atlasFrame: CGRect { CGRect(origin: .zero, size: atlasSize) }
    
    var parent: UIView!
    
    override func setUp() {
        super.setUp()
        configureCommonOptions()
        
        parent = UIView(frame: CGRect(origin: .zero, size: CGSize(width: spacing, height: spacing)))
        parent.translatesAutoresizingMaskIntoConstraints = false
        parent.backgroundColor = UIColor.purple
    }
    
    override func tearDown() {
        executeRunLoop()
        parent = nil
        super.tearDown()
    }
 
    func test01_rendersPurpleBackground() {
        FBSnapshotVerifyView(parent)
    }
    
    func test02_snapshotImageCanBeAdded() {
        let view = makeImageViewFor(testName: "EventsList/test_empty")
        
        parent.addAndConstrain(view, constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    func test03_someSnapshotsCanBeAddedHorizontally() {
        parent.addAndConstrain(
            makeRow(testNames: [
                "EventsList/test_empty",
                "EventsList/test_addButton_inputShown",
                "EventsList/test_oneItem",
                "EventsList/test_oneItem_swiped",
            ]),
            constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    func test04_emptyRowItemCanBeAdded() {
        parent.addAndConstrain(
            makeRow(testNames: [
                nil,
                "EventsList/test_empty",
            ]),
            constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    func test05_eventsListBasicFlow() {
        parent = UIView(frame: atlasFrame)
        parent.backgroundColor = UIColor.purple
        
        let row01 = makeRow(testNames: [
            "EventsList/test_empty",
            "EventsList/test_addButton_inputShown",
            "EventsList/test_oneItem",
            "EventsList/test_oneItem_swiped",
            "EventDetails/test_singleHappening",
            "EventsList/test_oneItem_visited",
        ])
        
        parent.addAndConstrain(row01, constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    func test06_eventsListBasicFlow_dark() {
        parent = UIView(frame: atlasFrame)
        parent.backgroundColor = UIColor.purple
        
        let row01 = makeRow(testNames: [
            "EventsList/test_empty_dark",
            "EventsList/test_addButton_inputShown_dark",
            "EventsList/test_oneItem_dark",
            "EventsList/test_oneItem_swiped_dark",
            "EventDetails/test_singleHappening_dark",
            "EventsList/test_oneItem_visited_dark",
        ])
        
        parent.addAndConstrain(row01, constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    private func makeRow(testNames: [String?]) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = spacing * scale
        
        for name in testNames {
            horizontalStack.addArrangedSubview(makeImageViewFor(testName: name))
        }
        
        return horizontalStack
    }
    
    private func makeImageViewFor(testName: String?) -> UIImageView {
        let view = UIImageView(image: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: width * scale),
            view.heightAnchor.constraint(equalToConstant: height * scale),
        ])
        
        let directory = getReferenceImageDirectory(withDefault: nil).appending("_64")
        let screenSize = "_\(Int(width))x\(Int(height))"
        let path = "\(directory)/\(testName ?? "nil")\(screenSize).png"
        
        if let image = UIImage(contentsOfFile: path) {
            view.image = image
        } else { print("image not found for \(path)") }
        
        return view
    }
}

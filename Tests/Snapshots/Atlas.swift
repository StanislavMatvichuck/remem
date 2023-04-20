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
        let view = makeImageViewFor(testName: "\(deviceName)/light/EventsList/test_empty")
        
        parent.addAndConstrain(view, constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    func test03_someSnapshotsCanBeAddedHorizontally() {
        parent.addAndConstrain(
            makeRow(testNames: [
                "\(deviceName)/light/EventsList/test_empty",
                "\(deviceName)/light/EventsList/test_addButton_inputShown",
                "\(deviceName)/light/EventsList/test_oneItem",
                "\(deviceName)/light/EventsList/test_oneItem_swiped",
            ]),
            constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    func test04_emptyRowItemCanBeAdded() {
        parent.addAndConstrain(
            makeRow(testNames: [
                nil,
                "\(deviceName)/light/EventsList/test_empty",
            ]),
            constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    func test05_eventsListBasicFlow() {
        parent = UIView(frame: atlasFrame)
        parent.backgroundColor = UIColor.purple
        
        let row01 = makeRow(testNames: [
            "\(deviceName)/light/EventsList/test_empty",
            "\(deviceName)/light/EventsList/test_addButton_inputShown",
            "\(deviceName)/light/EventsList/test_oneItem",
            "\(deviceName)/light/EventsList/test_oneItem_swiped",
            "\(deviceName)/light/EventDetails/test_singleHappening",
            "\(deviceName)/light/EventsList/test_oneItem_visited",
        ])
        
        parent.addAndConstrain(row01, constant: spacing)
        
        FBSnapshotVerifyView(parent)
    }
    
    func test06_eventsListBasicFlow_dark() {
        parent = UIView(frame: atlasFrame)
        parent.backgroundColor = UIColor.purple
        
        let row01 = makeRow(testNames: [
            "\(deviceName)/dark/EventsList/test_empty_dark",
            "\(deviceName)/dark/EventsList/test_addButton_inputShown_dark",
            "\(deviceName)/dark/EventsList/test_oneItem_dark",
            "\(deviceName)/dark/EventsList/test_oneItem_swiped_dark",
            "\(deviceName)/dark/EventDetails/test_singleHappening_dark",
            "\(deviceName)/dark/EventsList/test_oneItem_visited_dark",
        ])
        
        parent.addAndConstrain(row01, constant: spacing)
        
        if let folderName { self.folderName = folderName.replacingOccurrences(of: "light", with: "dark") }
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
        let path = "\(directory)/\(testName ?? "nil").png"
        
        if let image = UIImage(contentsOfFile: path) {
            view.image = image
        } else { print("image not found for \(path)") }
        
        return view
    }
}

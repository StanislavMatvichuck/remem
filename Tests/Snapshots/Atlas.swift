//
//  SnapshotsAtlas.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 15.01.2023.
//

import iOSSnapshotTestCase
import UIKit

final class Atlas: FBSnapshotTestCase {
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    let spacing = 16.0
    
    var parent: UIView!
    
    override func setUp() {
        super.setUp()
        recordMode = false
        folderName = "Atlas"
        
        parent = UIView(frame: CGRect(x: 0, y: 0, width: 2 * 1920, height: 2 * 1080))
        parent.backgroundColor = UIColor.purple
    }
    
    override func tearDown() {
        executeRunLoop()
        parent = nil
        super.tearDown()
    }
 
    func test01_rendersFullHDPurpleBackground() {
        FBSnapshotVerifyView(parent)
    }
    
    func test02_snapshotImageCanBeAdded() {
        let directory = getReferenceImageDirectory(withDefault: nil).appending("_64")
        let testName = "EventsList/test_empty"
        guard let image = UIImage(contentsOfFile: "\(directory)/\(testName)@2x.png") else { return }
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false

        parent.addSubview(view)
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            view.topAnchor.constraint(equalTo: parent.topAnchor),
            view.widthAnchor.constraint(equalToConstant: image.size.width),
            view.heightAnchor.constraint(equalToConstant: image.size.height),
        ])
        
        FBSnapshotVerifyView(parent)
    }
    
    func test03_someSnapshotsCanBeAddedHorizontally() {
        let row = makeRow(testNames: [
            "EventsList/test_empty",
            "EventsList/test_addButton_inputShown",
            "EventsList/test_oneItem",
            "EventsList/test_oneItem_swiped",
        ])
        
        parent.addSubview(row)
        
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            row.topAnchor.constraint(equalTo: parent.topAnchor),
        ])
        
        FBSnapshotVerifyView(parent)
    }
    
    func test04_emptyRowItemCanBeAdded() {
        let row = makeRow(testNames: [
            nil,
            "EventsList/test_empty",
        ])
        
        parent.addSubview(row)
        
        NSLayoutConstraint.activate([
            row.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            row.topAnchor.constraint(equalTo: parent.topAnchor),
        ])
        
        FBSnapshotVerifyView(parent)
    }
    
    func test05_eventsListBasicFlow() {
        parent = UIView(frame: CGRect(x: 0, y: 0, width: 6 * (width + spacing), height: 2 * (height + spacing)))
        parent.backgroundColor = UIColor.purple
        
        let row01 = makeRow(testNames: [
            "EventsList/test_empty",
            "EventsList/test_addButton_inputShown",
            "EventsList/test_oneItem",
            "EventsList/test_oneItem_swiped",
            nil,
            "EventsList/test_oneItem_visited",
        ])
        
        let row02 = makeRow(testNames: [
            nil,
            nil,
            nil,
            nil,
            "Event/test_singleHappening",
        ])
        
        parent.addSubview(row01)
        parent.addSubview(row02)
        
        NSLayoutConstraint.activate([
            row01.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            row01.topAnchor.constraint(equalTo: parent.topAnchor),
            row02.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            row02.topAnchor.constraint(equalTo: row01.bottomAnchor),
        ])
        
        FBSnapshotVerifyView(parent)
    }
    
    func test06_eventsListBasicFlow_dark() {
        parent = UIView(frame: CGRect(x: 0, y: 0, width: 6 * (width + spacing), height: 2 * (height + spacing)))
        parent.backgroundColor = UIColor.purple
        
        let row01 = makeRow(testNames: [
            "EventsList/test_empty_dark",
            "EventsList/test_addButton_inputShown_dark",
            "EventsList/test_oneItem_dark",
            "EventsList/test_oneItem_swiped_dark",
            nil,
            "EventsList/test_oneItem_visited_dark",
        ])
        
        let row02 = makeRow(testNames: [
            nil,
            nil,
            nil,
            nil,
            "Event/test_singleHappening_dark",
        ])
        
        parent.addSubview(row01)
        parent.addSubview(row02)
        
        NSLayoutConstraint.activate([
            row01.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            row01.topAnchor.constraint(equalTo: parent.topAnchor),
            row02.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            row02.topAnchor.constraint(equalTo: row01.bottomAnchor),
        ])
        
        FBSnapshotVerifyView(parent)
    }
    
    private func makeRow(testNames: [String?]) -> UIStackView {
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = spacing
        
        for name in testNames {
            horizontalStack.addArrangedSubview(makeImageViewFor(testName: name))
        }
        
        return horizontalStack
    }
    
    private func makeImageViewFor(testName: String?) -> UIImageView {
        guard let testName else {
            let view = UIImageView(image: nil)
            view.translatesAutoresizingMaskIntoConstraints = false
            let width = UIScreen.main.bounds.width
            let height = UIScreen.main.bounds.height
            NSLayoutConstraint.activate([
                view.widthAnchor.constraint(equalToConstant: width),
                view.heightAnchor.constraint(equalToConstant: height),
            ])
            return view
        }
        
        let directory = getReferenceImageDirectory(withDefault: nil).appending("_64")
        guard let image = UIImage(contentsOfFile: "\(directory)/\(testName)@2x.png") else { fatalError("unable to find image") }
        
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: image.size.width),
            view.heightAnchor.constraint(equalToConstant: image.size.height),
        ])
        
        return view
    }
}

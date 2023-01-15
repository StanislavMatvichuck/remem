//
//  SnapshotsAtlas.swift
//  ApplicationSnapshotsTests
//
//  Created by Stanislav Matvichuck on 15.01.2023.
//

import iOSSnapshotTestCase
import UIKit

final class SnapshotsAtlas: FBSnapshotTestCase {
    var parent: UIView!
    
    override func setUp() {
        super.setUp()
        recordMode = true
        folderName = "Atlas"
        
        parent = UIView(frame: CGRect(x: 0, y: 0, width: 1920, height: 1080))
        parent.backgroundColor = UIColor.purple
    }
    
    override func tearDown() {
        executeRunLoop()
        parent = nil
        super.tearDown()
    }
 
    func test_rendersFullHDPurpleBackground() {
        FBSnapshotVerifyView(parent)
    }
    
    func test_snapshotImageCanBeAdded() {
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
    
    func test_someSnapshotsCanBeAddedHorizontally() {
        let directory = getReferenceImageDirectory(withDefault: nil).appending("_64")
        let testNames = [
            "EventsList/test_empty",
            "EventsList/test_addButton_inputShown",
            "EventsList/test_oneItem",
            "EventsList/test_oneItem_swiped",
        ]
        
        let horizontalStack = UIStackView()
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.axis = .horizontal
        
        for name in testNames {
            horizontalStack.addArrangedSubview(makeImageViewFor(testName: name))
        }
        
        parent.addSubview(horizontalStack)
        
        NSLayoutConstraint.activate([
            horizontalStack.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
            horizontalStack.topAnchor.constraint(equalTo: parent.topAnchor),
        ])
        
        FBSnapshotVerifyView(parent)
    }
    
    private func makeImageViewFor(testName: String) -> UIImageView {
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

//
//  ViewController.swift
//  Remem
//
//  Created by Stanislav Matvichuck on 06.01.2022.
//

import UIKit

class ControllerMain: UIViewController, UITextFieldDelegate {
    //
    
    // MARK: - Private properties
    
    //
    
    fileprivate let viewRoot = ViewMain()
    
    fileprivate var textField = UITextField()
    
    fileprivate var list = EntriesList(entries: [])
    
    //
    
    // MARK: - Initialization
    
    //
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    
    // MARK: - View lifecycle
    
    //
    
    override func loadView() { view = viewRoot }
    
    override func viewDidLoad() {
        viewRoot.viewTable.dataSource = self
        textField.delegate = self
        
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        title = "Remem"
        
        //
        // Right temporary button
        //
        
        let addImage = UIImage(systemName: "plus")?
            .withTintColor(.orange)
            .withRenderingMode(.alwaysOriginal)
            .withConfiguration(UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20)))
        
        let addButton = UIBarButtonItem(image: addImage, style: .plain, target: self, action: #selector(handlePressAdd))
        
        navigationItem.setRightBarButton(addButton, animated: false)
    }
    
    //

    // MARK: - Events handling

    //
    
    @objc private func handlePressAdd() {
        let alert = UIAlertController(title: "New entry", message: "Give your event a name", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: handlePressAddConfirm)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
            
        alert.addTextField { textField in
            self.textField = textField
        }
            
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func handlePressAddConfirm(_: UIAlertAction) {
        print(#function)
        
        guard let name = textField.text, !name.isEmpty else { return }
        
        list.entries.append(Entry(name: name))
        
        viewRoot.viewTable.reloadData()
    }
}

extension ControllerMain: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if list.entries.count == 0 {
            viewRoot.showEmptyState()
        } else {
            viewRoot.hideEmptyState()
        }
        
        return list.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let row = tableView.dequeueReusableCell(withIdentifier: ViewMainRow.reuseIdentifier) as? ViewMainRow
        else { return UITableViewCell() }
        
        let data = list.entries[indexPath.row]
        
        row.update(name: data.name)
        row.update(value: data.value)
        
        return row
    }
}

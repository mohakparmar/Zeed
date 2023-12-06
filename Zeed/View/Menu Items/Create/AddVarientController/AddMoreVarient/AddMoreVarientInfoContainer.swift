//
//  AddMoreVarientInfoContainer.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//
import UIKit

protocol AddMoreVarientInfoContainerDelegate: AnyObject {
    func didChangeVarientValue(varientValue: String, forIndex index: Int)
}

class AddMoreVarientInfoContainer: UITableViewCell, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Properties
    weak var delegate: AddMoreVarientInfoContainerDelegate?
    
    var tableView: UITableView

    var editVariant: CreateItemVariant? {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    //MARK: - UI Elements
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(AddMoreVarientInfoCell.self, forCellReuseIdentifier: AddMoreVarientInfoCell.reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .appBackgroundColor
        selectionStyle = .none
        
        contentView.addSubview(tableView)
        tableView.fillSuperview()
    }
    
    
    //MARK: - Delegate UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddMoreVarientInfoCell.reuseIdentifier, for: indexPath) as! AddMoreVarientInfoCell
        cell.delegate = self
        cell.indexPath = indexPath
        cell.editVariant = editVariant
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let customView = UIView()
        customView.backgroundColor = .appBackgroundColor
        customView.alpha = 0.7
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = "89 AddMoreVarientInfoContainer"
        
        customView.addSubview(label)
        label.anchor(left: customView.leftAnchor, right: customView.rightAnchor, paddingLeft: 10, paddingRight: 10)
        label.centerY(inView: customView)
        
        return customView
    }
}

//MARK: - Delegate AddMoreVarientInfoCellDelegate
extension AddMoreVarientInfoContainer: AddMoreVarientInfoCellDelegate {
    func didChangeVarientValue(varientValue: String, fromCell cell: AddMoreVarientInfoCell) {
//        guard let category = category else { return }
        let index = tableView.indexPath(for: cell)!
        
        delegate?.didChangeVarientValue(varientValue: varientValue, forIndex: index.section)
    }
}

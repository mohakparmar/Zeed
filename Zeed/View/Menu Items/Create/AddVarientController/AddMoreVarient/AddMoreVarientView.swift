//
//  AddMoreVarientView.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit

enum AddMoreVarientCellType: Int, CaseIterable {
    case info
    case price
    case quantity
    
    var description: String {
        switch self {
        case .info:
            return "Info"
        case .price:
            return "Price"
        case .quantity:
            return "Quantity Available"
        }
    }
}

protocol AddMoreVarientViewDelegate: AnyObject {
    func addMoreVarientView(_ addMoreVarientView: AddMoreVarientView, tableView: UITableView, didSaveVarient: CreateItemVariant)
}

class AddMoreVarientView: UIView {
    //MARK: - Properties
    weak var delegate: AddMoreVarientViewDelegate?
    var tableView: UITableView
    
    var editVariant: CreateItemVariant? {
        didSet {
            guard let editVariant = editVariant else { return }
////            varientValue = editVariant.attributes
//            varientPrice = editVariant.price
//            varientQuantity = editVariant.quantity
        }
    }
    var isEditingAtIndex: IndexPath?
    
    var varientValue = [String]() {
        didSet {
            checkValueStatus()
        }
    }
    
    var varientPrice: Double? {
        didSet {
            checkValueStatus()
        }
    }
    
    var varientQuantity: Int? {
        didSet {
            checkValueStatus()
        }
    }
    
    //MARK: - UI Elements
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .appPrimaryColor
        label.text = "Create Varient"
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        return label
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(handleDone), for: .touchUpInside)
        
        button.isEnabled = false
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AddMoreVarientInfoContainer.self, forCellReuseIdentifier: AddMoreVarientInfoContainer.reuseIdentifier)
        tableView.register(AddMoreVarientPriceCell.self, forCellReuseIdentifier: AddMoreVarientPriceCell.reuseIdentifier)
        tableView.register(AddMoreVarientQuantityCell.self, forCellReuseIdentifier: AddMoreVarientQuantityCell.reuseIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        configureView()
        setupToHideKeyboardOnTapOnView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleDone() {
        guard let quantity = varientQuantity else { return }
        guard let price = varientPrice else { return }
        
//        let varient = CreateItemVarient(attributes: varientValue, price: price, quantity: quantity)
//        delegate?.addMoreVarientView(self, tableView: tableView, didSaveVarient: varient)
    }
    
    func checkValueStatus() {
        doneButton.isEnabled = false
        
        var valueIsNilBool = true
        
        varientValue.forEach({ (value) in
            if value == "" {
                valueIsNilBool = false
            }
        })
        
        guard varientQuantity != nil, varientPrice != nil, valueIsNilBool else { return }
        
        doneButton.isEnabled = true
    }
    
    
    @objc func dismissKeyboard()
    {
        endEditing(true)
    }
    
    //MARK: - Helper Functions
    func configureView() {
        backgroundColor = .appBackgroundColor
        tableView.backgroundColor = .appBackgroundColor
        layer.cornerRadius = 11
        clipsToBounds = true
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 5, height: 50)
        titleLabel.centerX(inView: self)
        
        addSubview(doneButton)
        doneButton.anchor(bottom: safeAreaLayoutGuide.bottomAnchor, paddingBottom: 10)
        doneButton.setDimensions(height: 45, width: frame.width - 20)
        doneButton.centerX(inView: self)
        
        addSubview(tableView)
        tableView.anchor(top: titleLabel.bottomAnchor, left: leftAnchor, bottom: doneButton.topAnchor, right: rightAnchor, paddingTop: 6, paddingLeft: 18, paddingBottom: 8, paddingRight: 18)
    }
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
    }
}

//MARK: - DataSource UITableViewDataSource
extension AddMoreVarientView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return AddMoreVarientCellType.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = AddMoreVarientCellType(rawValue: indexPath.section)!
        
        switch type {
        case .info:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddMoreVarientInfoContainer.reuseIdentifier, for: indexPath) as! AddMoreVarientInfoContainer
            cell.editVariant = editVariant
            cell.delegate = self
            return cell
        case .price:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddMoreVarientPriceCell.reuseIdentifier, for: indexPath) as! AddMoreVarientPriceCell
            cell.editVariant = editVariant
            cell.delegate = self
            return cell
        case .quantity:
            let cell = tableView.dequeueReusableCell(withIdentifier: AddMoreVarientQuantityCell.reuseIdentifier, for: indexPath) as! AddMoreVarientQuantityCell
            cell.editVariant = editVariant
            cell.delegate = self
            return cell
        }
    }
}

//MARK: - Delegate UITableViewDelegate
extension AddMoreVarientView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = AddMoreVarientCellType(rawValue: indexPath.section)!
        
        if type == .info {
            return CGFloat(1 * (50 + 28))
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionType = AddMoreVarientCellType(rawValue: section)!
 
        let customView = UIView()
        customView.backgroundColor = .appBackgroundColor
        customView.alpha = 0.7
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.text = sectionType.description
        
        customView.addSubview(label)
        label.anchor(left: customView.leftAnchor, right: customView.rightAnchor, paddingLeft: 10, paddingRight: 10)
        label.centerY(inView: customView)
        
        return customView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let sectionType = AddMoreVarientCellType(rawValue: section)!
        if sectionType == .info {
            return 0
        }
        return 28
    }
}

//MARK: - Delegate AddMoreVarientInfoCellDelegate
extension AddMoreVarientView: AddMoreVarientInfoContainerDelegate {
    func didChangeVarientValue(varientValue: String, forIndex index: Int) {
        self.varientValue[index] = varientValue
    }
}

//MARK: - Delegate AddMoreVarientPriceCellDelegate
extension AddMoreVarientView: AddMoreVarientPriceCellDelegate {
    func didChangePrice(price: Double) {
        self.varientPrice = price
    }
}
//MARK: - Delegate AddMoreVarientQuantityCellDelegate
extension AddMoreVarientView: AddMoreVarientQuantityCellDelegate {
    func didChangeQuantity(quantity: Int) {
        self.varientQuantity = quantity
    }
}

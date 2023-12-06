//
//  AddVarientCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 30/03/21.
//

import UIKit
import GMStepper

protocol AddVarientCellDelegate: AnyObject {
    func didTapDelete(for cell: XYZCell)
    func didTapEdit(for cell: XYZCell)
    func didTapActive(for cell: XYZCell)
}

class XYZCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Properties
    weak var delegate: AddVarientCellDelegate?
    
    var tableView: UITableView
    
    var varient: CreateItemVariant? {
        didSet {
            guard let varient = varient else { return }
//            itemPriceLabel.text = "\(varient.price) KD"
//            quantityStepper.value = Double(varient.quantity) 
            
//            activeButton.isSelected = varient.isActive
//            if activeButton.isSelected {
                activeButton.backgroundColor = .white
                activeButton.layer.borderWidth = 0.5
//            } else {
//                activeButton.backgroundColor = .appPrimaryColor
//                activeButton.layer.borderWidth = 0
//            }
            
            tableView.setDimensions(height: CGFloat(40 * 1), width: frame.width - 30)
            
            tableView.reloadData()
        }
    }
    //MARK: - UI Elements
    let itemNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Item Name Label"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    private let itemPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "PRice"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()
    
    
    private let quantityAvailableLabel: UILabel = {
        let label = UILabel()
        label.text = "Quantity Available"
        label.font = UIFont.systemFont(ofSize: 16, weight: .light)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var quantityStepper: GMStepper = {
        let stepper = GMStepper()
        stepper.buttonsBackgroundColor = UIColor.appPrimaryColor.withAlphaComponent(0.6)
        stepper.buttonsTextColor = .white
        
        stepper.labelBackgroundColor = .white
        stepper.labelTextColor = UIColor.appPrimaryColor.withAlphaComponent(0.6)
        stepper.labelFont = UIFont(name: "AvenirNext-Bold", size: 19)!
        
        stepper.limitHitAnimationColor = .systemRed
        
        stepper.minimumValue = 0
        stepper.maximumValue = 999
        
        stepper.setDimensions(height: 35, width: 120)
        return stepper
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 6
        
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 6
        
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var activeButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .appPrimaryColor
        button.layer.cornerRadius = 6
        
        button.setTitle("Active", for: .selected)
        button.setTitle("In Active", for: .normal)
        
        button.tintColor = .clear
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.appPrimaryColor, for: .selected)
        
        button.layer.borderColor = UIColor.appPrimaryColor.cgColor
        
        button.addTarget(self, action: #selector(handleActive), for: .touchUpInside)
        
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        super.init(frame: frame)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isUserInteractionEnabled = false
        
        tableView.register(AddVariantInfoCell.self, forCellReuseIdentifier: AddVariantInfoCell.reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleEdit() {
        delegate?.didTapEdit(for: self)
    }
    
    @objc func handleDelete() {
        delegate?.didTapDelete(for: self)
    }
    
    @objc func handleActive(sender: UIButton) {
        sender.isSelected.toggle()
        delegate?.didTapActive(for: self)
    }
    
    //MARK: - Helper Functions
    func configureCell() {
        layer.cornerRadius = 8
        backgroundColor = .white
        clipsToBounds = true
        addShadow()
        
        let itemInfoStack = UIStackView(arrangedSubviews: [itemNameLabel, itemPriceLabel])
        itemInfoStack.alignment = .center
        itemInfoStack.distribution = .equalSpacing
        itemInfoStack.anchor(width: frame.width - 30, height: 40)
        
        
        let quantityInfoStack = UIStackView(arrangedSubviews: [quantityAvailableLabel, quantityStepper])
        quantityInfoStack.alignment = .center
        quantityInfoStack.distribution = .equalCentering
        quantityInfoStack.anchor(width: frame.width - 30, height: 40)
        
        let buttonsStack = UIStackView(arrangedSubviews: [editButton, deleteButton, activeButton])
        buttonsStack.alignment = .fill
        buttonsStack.distribution = .fillEqually
        buttonsStack.spacing = 8
        buttonsStack.anchor(width: frame.width - 30, height: 40)
        
        let mainStack = UIStackView(arrangedSubviews: [itemInfoStack, tableView, quantityInfoStack, buttonsStack])
        mainStack.axis = .vertical
        mainStack.alignment = .center
        mainStack.distribution = .fillProportionally
        mainStack.spacing = 5
        mainStack.setCustomSpacing(20, after: quantityInfoStack)
        
        addSubview(mainStack)
        mainStack.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
    }
    
    //MARK: - DataSource & Delegate UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddVariantInfoCell.reuseIdentifier, for: indexPath) as! AddVariantInfoCell
        cell.selectionStyle = . none
        cell.varientTypeLabel.text = "205 ADDVARIANTCELL \(indexPath.row)"
//        cell.varientSubTypeLabel.text = varient!.attributes[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

//
//  NewABCPopup.swift
//  Zeed
//
//  Created by Shrey Gupta on 23/08/21.
//

import UIKit

protocol AttributePickerDelegate: AnyObject {
    func attributePicker(_ attributePicker: AttributePicker, didSelectAttribute attribute: ItemAttribute, atIndexPath indexPath: IndexPath, forVariantType: VariantAttributeType)
}


class AttributePicker: UIView, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Properties
    var tableView: UITableView
    
    weak var delegate: AttributePickerDelegate?
    
    var allAttributes = [ItemAttribute]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var forIndexPath: IndexPath?
    var forVariantType: VariantAttributeType?
    
    //MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = appDele!.isForArabic ? Select_Variant_ar : Select_Variant_en
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        tableView = UITableView(frame: .zero, style: .plain)
        
        super.init(frame: frame)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.reuseIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        addSubview(tableView)
        tableView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: rightAnchor, paddingTop: 45, paddingLeft: 4, paddingRight: 4)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    
    //MARK: - Helper Funtions
    func configureUI() {
        tableView.backgroundColor = .clear
        backgroundColor = .appBackgroundColor
        layer.cornerRadius = 10
        addShadow()
        
        addSubview(titleLabel)
        titleLabel.anchor(top: topAnchor, paddingTop: 12)
        titleLabel.centerX(inView: self)
        
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().tranFormingView(toArabic: self)
        }
    }
    
    //MARK: - DataSource & Delegate UICollectionViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return allAttributes.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allAttributes[section].options.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allAttributes[section].name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.reuseIdentifier, for: indexPath)
        cell.textLabel?.text = appDele!.isForArabic ? allAttributes[indexPath.section].options[indexPath.row].name : allAttributes[indexPath.section].options[indexPath.row].name
        cell.textLabel?.textAlignment = appDele!.isForArabic ? .right : .left
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedOption = allAttributes[indexPath.section].options[indexPath.row]
        allAttributes[indexPath.section].selectedOption = selectedOption

        guard let forIndexPath = forIndexPath else { return }
        guard let forVariantType = forVariantType else { return }
        delegate?.attributePicker(self, didSelectAttribute: allAttributes[indexPath.section], atIndexPath: forIndexPath, forVariantType: forVariantType)
    }
}



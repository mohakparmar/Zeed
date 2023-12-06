//
//  FeedExpandedVarientView.swift
//  Zeed
//
//  Created by Shrey Gupta on 17/04/21.
//

import UIKit

protocol FeedExpandedVarientViewDelegate: AnyObject {
    func didUpdateSelectedVariant(itemAttributes: [ItemAttribute])
    func didUpdateSelectedVariantIndex(itemAttributes: ItemVariant, index:Int)

}

class FeedExpandedVarientView: UIView, UITableViewDataSource, UITableViewDelegate {
    //MARK: - Properties
    weak var delegate: FeedExpandedVarientViewDelegate?
    
    var tableView: UITableView
    
    var post: PostItem? {
        didSet {
            guard let post = post else { return }
            
            itemAttributes.removeAll()
            itemAttributes = post.variants

            tableView.reloadData()
        }
    }
    
    var itemAttributes = [ItemVariant]()
    
    //MARK: - UI Elements
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        tableView = UITableView(frame: frame, style: .plain)
        
        super.init(frame: frame)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.isScrollEnabled = false
        
        if #available(iOS 15.0, *) {
//            tableView.sectionHeaderTopPadding = 0.0
        }
        
        tableView.register(FeedExpandedVarientContainer.self, forCellReuseIdentifier: FeedExpandedVarientContainer.reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Selectors

    //MARK: - Helper Functions
    func configure() {
        tableView.backgroundColor = .white
        addSubview(tableView)
        tableView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    //MARK: - UITableViewDelegate & UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedExpandedVarientContainer.reuseIdentifier, for: indexPath) as! FeedExpandedVarientContainer
//        let attribute = itemAttributes[indexPath.section]
        cell.attribute = itemAttributes
        cell.delegate = self
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: cell)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let customView = UIView()
        customView.backgroundColor = .white
        
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        label.text = "Select \(itemAttributes[section].name)"
        label.text = appDele!.isForArabic ? "أختار نوع" : "Select Variant"
        label.textColor = .darkGray
        
        customView.addSubview(label)
        label.anchor(left: customView.leftAnchor, right: customView.rightAnchor)
        label.centerY(inView: customView)
        
        if appDele!.isForArabic == true {
            ConvertArabicViews.init().convertSingleView(toAr: customView)
            label.textAlignment = . right
        }

        
        return customView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 28
    }
}

extension FeedExpandedVarientView: FeedExpandedVarientContainerDelegate {
    func didSelectOption(updatedAttribute: ItemAttribute, fromContainer container: FeedExpandedVarientContainer) {
        let indexPath = tableView.indexPath(for: container)!
        
//        self.itemAttributes[indexPath.section] = updatedAttribute
//        delegate?.didUpdateSelectedVariant(itemAttributes: self.itemAttributes)
//        tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
    }
    
    func didSelectOptionWithIndex(updatedAttribute: ItemVariant, fromContainer container: FeedExpandedVarientContainer, index: Int) {
        self.delegate?.didUpdateSelectedVariantIndex(itemAttributes: updatedAttribute, index: index)
    }
}

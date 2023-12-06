//
//  BiddingStories.swift
//  Zeed
//
//  Created by Shrey Gupta on 28/02/21.
//

import UIKit

internal var isDeleteSnapEnabled = true

protocol BiddingStoriesDelegate: AnyObject {
    func presentStory(forUser user: User)
    func presentStory1(forUser user: User)
}

class BiddingStories: UICollectionViewCell {
    //MARK: - Properties
    weak var delegate: BiddingStoriesDelegate?
//    private var viewModel: StoriesViewModel = StoriesViewModel()
    var allStories = [User]() {
        didSet {
            storiesCollectionView.reloadData()
        }
    }
    //MARK: - UI Elements
    lazy var storiesLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 100, height: 100)
        return flowLayout
    }()
    
    lazy var storiesCollectionView: UICollectionView = {
        let cv = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: storiesLayout)
        cv.backgroundColor = .white
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        
        cv.register(LiveListCell.self, forCellWithReuseIdentifier: LiveListCell.reuseIdentifier)
        cv.register(StoryListCell.self, forCellWithReuseIdentifier: StoryListCell.reuseIdentifier)
        
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    private lazy var storyView: UIView = {
        let storyView = UIView()
        storyView.setDimensions(height: 100, width: frame.width)
        return storyView
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configure() {
        configureStoriesView()
    }
    
    func configureStoriesView() {
        storiesCollectionView.dataSource = self
        storiesCollectionView.delegate = self
        
        addSubview(storyView)
        
        storyView.addSubview(storiesCollectionView)
        storiesCollectionView.fillSuperview()

        storyView.fillSuperview()
        
    }
}
//MARK: - DataSource UICollectionViewDataSource

extension BiddingStories: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allStories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        if indexPath.row <= 1 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LiveListCell.reuseIdentifier,for: indexPath) as? LiveListCell else { fatalError() }
            cell.user = allStories[indexPath.row]
            return cell
//        }
//        else {
//            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryListCell.reuseIdentifier,for: indexPath) as? StoryListCell else { fatalError() }
//            cell.user = allStories[indexPath.row]
//
//            return cell
//        }
    }
}

//MARK: - Delegate UICollectionViewDelegateFlowLayout
extension BiddingStories: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        isDeleteSnapEnabled = false
        DispatchQueue.main.async {
            self.delegate?.presentStory1(forUser: self.allStories[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

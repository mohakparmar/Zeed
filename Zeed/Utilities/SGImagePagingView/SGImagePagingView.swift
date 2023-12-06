//
//  SGImagePagingView.swift
//  Zeed
//
//  Created by Shrey Gupta on 01/03/21.
//

import UIKit

protocol SGImagePagingViewDelegate: AnyObject {
    func currentlySelectedIndex(index: IndexPath)
}

class SGImagePagingView: UIView {
    //MARK: - Properties
    weak var delegate: SGImagePagingViewDelegate?
    
    var medias: [ItemMedia] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    var collectionView: UICollectionView
    
    var isZoomEffectsEnabled: Bool
    
    //MARK: - UI Elements
    
    //MARK: - Lifecycle
    init(forMedias medias: [ItemMedia], isZoomEnabled: Bool) {
        self.medias = medias
        self.isZoomEffectsEnabled = isZoomEnabled
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(frame: .zero)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.backgroundWhiteColor
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(SGImagePagingCell.self, forCellWithReuseIdentifier: SGImagePagingCell.reuseIdentifier)
        collectionView.register(SGImageScrollPagingCell.self, forCellWithReuseIdentifier: SGImageScrollPagingCell.reuseIdentifier)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    func configure() {
        addSubview(collectionView)
        collectionView.fillSuperview()
    }
}

//MARK: - DataSource UICollectionViewDataSource
extension SGImagePagingView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isZoomEffectsEnabled {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SGImageScrollPagingCell.reuseIdentifier, for: indexPath) as! SGImageScrollPagingCell
            cell.itemImageView.loadImage(from: medias[indexPath.row].url)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SGImagePagingCell.reuseIdentifier, for: indexPath) as! SGImagePagingCell
            cell.itemImageView.loadImage(from: medias[indexPath.row].url)
            return cell
        }
    }
}

//MARK: - Delegate UICollectionViewDelegate
extension SGImagePagingView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 0
    }
}

//MARK: - Delegate UIScrollk.jlugViewDelegate
extension SGImagePagingView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let point = convert(collectionView.center, to: collectionView)
        
        guard let indexPath = collectionView.indexPathForItem(at: point), indexPath.item < 4 else { return }
        delegate?.currentlySelectedIndex(index: indexPath)
    }
}

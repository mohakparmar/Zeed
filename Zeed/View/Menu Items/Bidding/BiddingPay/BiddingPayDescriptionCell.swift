//
//  BiddingPayDescriptionCell.swift
//  Zeed
//
//  Created by Shrey Gupta on 02/04/21.
//

import UIKit

class BiddingPayDescriptionCell: UITableViewCell {
    //MARK: - Properties
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "The quick, brown fox jumps over a lazy dog. DJs flock by when MTV ax quiz prog. Junk MTV quiz graced by fox whelps. Bawds jog, flick quartz, vex nymphs. Waltz, bad nymph, for quick jigs vex! Fox nymphs grab quick-jived waltz. Brick quiz whangs jumpy veldt fox. Bright vixens jump; dozy fowl quack. Quick wafting zephyrs vex bold Jim. Quick zephyrs blow, vexing daft Jim. Sex-charged fop blew my junk TV quiz. How quickly daft jumping zebras."
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    //MARK: - Helper Functions
    func configureCell() {
        backgroundColor = .clear
        
        selectionStyle = .none
        
        addSubview(descriptionLabel)
        descriptionLabel.fillSuperview(padding: UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
    }
}

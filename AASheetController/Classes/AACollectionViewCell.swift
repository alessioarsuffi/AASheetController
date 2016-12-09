//
//  RSCollectionViewCell.swift
//  RSAlertController
//
//  Created by Alessio Arsuffi on 07/12/2016.
//  Copyright © 2016 Alessio Arsuffi. All rights reserved.
//

import UIKit

class AACollectionViewCell: UICollectionViewCell {

    // MARK: Properties
    
    static let identifier = "AACollectionViewCellIdentifier"
    
    var representedAssetIdentifier: String!
    
    // MARK: IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}

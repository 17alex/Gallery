//
//  CalleryCell.swift
//  Gallery
//
//  Created by Alex on 16.02.2021.
//

import UIKit
import SDWebImage

class GalleryCell: UICollectionViewCell {

    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    func set(photoModel: PhotoViewModel) {
        nameLabel.text = photoModel.photographer
        fotoImageView.sd_setImage(with: URL(string: photoModel.link))
    }
}

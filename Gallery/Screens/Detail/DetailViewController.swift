//
//  DetailViewController.swift
//  Gallery
//
//  Created by Alex on 16.02.2021.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var fotoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: - Variables
    
    var photo: Photo?
    
    //MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo {
            let photoModel = PhotoViewModel(photo: photo)
            fotoImageView.sd_setImage(with: URL(string: photoModel.link))
            titleLabel.text = photoModel.photographer
            dateLabel.text = photoModel.date
        }
    }
   
    //MARK: - IBActions
    
    @IBAction func closeButton() {
        dismiss(animated: true)
    }
}

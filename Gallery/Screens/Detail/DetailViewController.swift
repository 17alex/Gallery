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
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
    //MARK: - Variables
    
    var photo: Photo?
    
    //MARK: - LiveCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let photo = photo {
            let photoModel = PhotoViewModel(photo: photo)
            navItem.title = photoModel.photographer
            fotoImageView.sd_setImage(with: URL(string: photoModel.link))
            dateLabel.text = photoModel.date
        }
    }
   
    //MARK: - IBActions
    @IBAction func actionButtonPress(_ sender: UIBarButtonItem) {
        guard let image = fotoImageView.image else { return }
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = sender
        activityController.popoverPresentationController?.permittedArrowDirections = .any
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func closeButtonPress(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

}

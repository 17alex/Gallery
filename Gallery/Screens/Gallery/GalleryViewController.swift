//
//  GalleryViewController.swift
//  Gallery
//
//  Created by Alex on 16.02.2021.
//

import UIKit

protocol GalleryViewInput: class {
    func show(message: String)
    func reloadCollection()
    func insertItems(at indexArr: [Int])
}

final class GalleryViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            let cellNibName = String(describing: GalleryCell.self)
            collectionView.register(UINib(nibName: cellNibName, bundle: nil), forCellWithReuseIdentifier: cellNibName)
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    //MARK: - Variables
    
    var presenter: GalleryViewOutput!
    
    //MARK: - LiceCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.start()
    }
}

//MARK: - GalleryViewInput

extension GalleryViewController: GalleryViewInput {
    
    func insertItems(at indexArr: [Int]) {
        let indexPaths = indexArr.map { IndexPath(item: $0, section: 0) }
        collectionView.insertItems(at: indexPaths)
    }
    
    func reloadCollection() {
        collectionView.reloadData()
    }
    
    func show(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

//MARK: - UICollectionViewDataSource

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GalleryCell.self), for: indexPath) as! GalleryCell
        cell.set(photoModel: PhotoViewModel(photo: presenter.photos[indexPath.item]))
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension GalleryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constans.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didPressPhoto(by: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.willShowPhoto(by: indexPath.item)
    }
}
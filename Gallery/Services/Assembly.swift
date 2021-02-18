//
//  Assembly.swift
//  Gallery
//
//  Created by Alex on 17.02.2021.
//

import UIKit

class Assembly {
    
    let networkManager = NetworkService()
    let storeManager = StoreService()
    
    func getStartVC() -> UIViewController {
        return getGalleryVC()
    }
    
    func getGalleryVC() -> UIViewController {
        let view = GalleryViewController()
        let presenter = GalleryPresenter(view: view)
        let router = GalleryRouter(view: view)
        presenter.networkService = networkManager
        presenter.storeService = storeManager
        presenter.router = router
        router.assembly = self
        view.presenter = presenter
        return view
    }
    
    func getDetailVC(by photo: Photo) -> UIViewController {
        let view = DetailViewController()
        view.modalPresentationStyle = .fullScreen
        view.photo = photo
        return view
    }
}

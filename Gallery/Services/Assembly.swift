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
        let interactor = GalleryInteractor(presenter: presenter)
        let router = GalleryRouter(view: view)
        interactor.networkService = networkManager
        interactor.storeService = storeManager
        presenter.interactor = interactor
        presenter.router = router
        router.assembly = self
        view.presenter = presenter
        return view
    }
    
    func getDetailVC(by photoViewModel: PhotoViewModel) -> UIViewController {
        let view = DetailViewController()
        view.modalPresentationStyle = .fullScreen
        view.photoViewModel = photoViewModel
        return view
    }
}

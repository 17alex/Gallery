//
//  GalleryPresenter.swift
//  Gallery
//
//  Created by Alex on 17.02.2021.
//

import Foundation

protocol GalleryViewOutput {
    var photos: [Photo] { get }
    func start()
    func didPressSearch(by text: String)
    func didPressPhoto(by index: Int)
    func willShowPhoto(by index: Int)
}

class GalleryPresenter {
    
    //MARK: - Variables
    
    unowned var view: GalleryViewInput
    var router: GalleryRouterProtocol!
    
    var networkService: NetworkServiceProtocol!
    var storeService: StoreServiceProtocol!
    
    var photos: [Photo] = []
    private var nextPageUrl: String?
    private var isLoading = false
    
    init(view: GalleryViewInput) {
        self.view = view
    }
    
    //MARK: - Metods
    
    private func getPhotosFromStore() {
        storeService.getPhotos { storePhotos in
            photos = storePhotos
            view.reloadCollection()
        }
    }
    
    private func appendPhotos(_ response: Response) {
        storeService.addPhotos(response.photos)
        nextPageUrl = response.nextPageUrl
        let startIndex = self.photos.count
        photos.append(contentsOf: response.photos)
        let endIndex = self.photos.count
        let indexArr = (startIndex..<endIndex).map { Int($0) }
        view.insertItems(at: indexArr)
    }
    
    private func updatePhotos(_ response: Response) {
        storeService.deleteAllPhotos()
        storeService.addPhotos(response.photos)
        photos = []
        photos.append(contentsOf: response.photos)
        nextPageUrl = response.nextPageUrl
        view.reloadCollection()
    }
}

//MARK: - GalleryViewOutput

extension GalleryPresenter: GalleryViewOutput {
    
    func start() {
        getPhotosFromStore()
    }
    
    func didPressPhoto(by index: Int) {
        router.showDetail(by: photos[index])
    }
    
    func didPressSearch(by text: String) {
        isLoading = true
        networkService.loadFotosBy(text: text) { (result) in
            switch result {
            case .failure(let error):
                self.view.show(message: error.localizedDescription)
            case .success(let response):
                self.updatePhotos(response)
            }
            self.isLoading = false
        }
    }
    
    func willShowPhoto(by index: Int) {
        if !isLoading,
           index >= photos.count - Constans.preLoadPhotoCount,
           let nextPageUrl = nextPageUrl {
            isLoading = true
            networkService.loadFotosFrom(url: nextPageUrl) { (result) in
                switch result {
                case .failure(let error):
                    self.view.show(message: error.localizedDescription)
                case .success(let response):
                    self.appendPhotos(response)
                }
                self.isLoading = false
            }
        }
    }
}

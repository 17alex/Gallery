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
        storeService.getPhotos { photos in
            self.photos = photos
            view.reloadCollection()
        }
    }
    
    private func loadPhotos(fromUrlString urlString: String, complete: @escaping (Result<Response, Error>) -> Void) {
        isLoading = true
        networkService.loadFotos(fromUrlString: urlString) { (result) in
            complete(result)
            self.isLoading = false
        }
    }
    
    private func appendPhotos(_ response: Response) {
        self.storeService.addPhotos(response.photos)
        self.nextPageUrl = response.nextPageUrl
        let startIndex = self.photos.count
        self.photos.append(contentsOf: response.photos)
        let endIndex = self.photos.count
        let indexArr = (startIndex..<endIndex).map { Int($0) }
        view.insertItems(at: indexArr)
    }
}

//MARK: - GalleryViewOutput

extension GalleryPresenter: GalleryViewOutput {
    
    func didPressPhoto(by index: Int) {
        router.showDetail(by: photos[index])
    }
    
    func willShowPhoto(by index: Int) {
        if !isLoading,
           index >= photos.count - Constans.preLoadPhotoCount,
           let nextPageUrl = nextPageUrl {
            loadPhotos(fromUrlString: nextPageUrl) { result in
                switch result {
                case .failure(let error):
                    self.view.show(message: error.localizedDescription)
                case .success(let response):
                    self.appendPhotos(response)
                }
            }
        }
    }
    
    func start() {
        getPhotosFromStore()
        loadPhotos(fromUrlString: Constans.apiUrlString) { result in
            switch result {
            case .failure(let error):
                self.view.show(message: error.localizedDescription)
            case .success(let response):
                self.storeService.deleteAllPhotos()
                self.photos = []
                self.storeService.addPhotos(response.photos)
                self.nextPageUrl = response.nextPageUrl
                self.photos.append(contentsOf: response.photos)
                self.view.reloadCollection()
            }
        }
    }
}

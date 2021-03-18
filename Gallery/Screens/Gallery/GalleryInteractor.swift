//
//  GalleryInteractor.swift
//  Gallery
//
//  Created by Alex on 18.03.2021.
//

import Foundation

protocol GalleryInteractorInput {
    var photos: [Photo] { get }
    func getPhotos()
    func getSearchPhotos(by text: String)
    func willShowPhoto(by index: Int)
}

final class GalleryInteractor {
    
    unowned let presenter: GalleryInteractorOutput
    var networkService: NetworkServiceProtocol!
    var storeService: StoreServiceProtocol!
    
    var photos: [Photo] = []
    private var nextPageUrl: String?
    private var isLoading = false
    
    init(presenter: GalleryInteractorOutput) {
        self.presenter = presenter
        print("GalleryInteractor init")
    }
    
    deinit {
        print("GalleryInteractor deinit")
    }
    
    //MARK: - Metods
    
    private func appendPhotos(_ response: Response) {
        storeService.addPhotos(response.photos)
        nextPageUrl = response.nextPageUrl
        let startIndex = self.photos.count
        photos.append(contentsOf: response.photos)
        let endIndex = self.photos.count
        let indexArr = (startIndex..<endIndex).map { Int($0) }
        presenter.didAppendPhotos(at: indexArr)
    }
    
    private func updatePhotos(_ response: Response) {
        storeService.deleteAllPhotos()
        storeService.addPhotos(response.photos)
        photos = []
        photos.append(contentsOf: response.photos)
        nextPageUrl = response.nextPageUrl
        presenter.didUpdatePhotos()
    }
}

//MARK: - GalleryInteractorInput

extension GalleryInteractor: GalleryInteractorInput {
    
    func getPhotos() {
        storeService.getPhotos { storePhotos in
            photos = storePhotos
            presenter.didUpdatePhotos()
        }
    }
    
    func getSearchPhotos(by text: String) {
        isLoading = true
        networkService.loadPhotosBy(text: text) { (result) in
            switch result {
            case .failure(let error):
                self.presenter.didCameError(error)
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
            networkService.loadPhotosFrom(url: nextPageUrl) { (result) in
                switch result {
                case .failure(let error):
                    self.presenter.didCameError(error)
                case .success(let response):
                    self.appendPhotos(response)
                }
                self.isLoading = false
            }
        }
    }
}

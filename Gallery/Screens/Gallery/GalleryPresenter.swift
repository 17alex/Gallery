//
//  GalleryPresenter.swift
//  Gallery
//
//  Created by Alex on 17.02.2021.
//

import Foundation

protocol GalleryViewOutput {
    var photoViewModels: [PhotoViewModel] { get }
    func viewDidLoad()
    func didPressSearch(by text: String)
    func didPressPhoto(by index: Int)
    func willShowPhoto(by index: Int)
}

protocol GalleryInteractorOutput: class {
    func didObtain(photos: [Photo])
    func didAppendPhotos(at indexArr: [Int])
    func didUpdatePhotos()
    func didCameError(_ error: Error)
}

class GalleryPresenter {
    
    //MARK: - Variables
    
    unowned var view: GalleryViewInput
    var interactor: GalleryInteractorInput!
    var router: GalleryRouterProtocol!
    
    var photoViewModels: [PhotoViewModel] = []
    
    init(view: GalleryViewInput) {
        self.view = view
        print("GalleryPresenter init")
    }
    
    deinit {
        print("GalleryPresenter deinit")
    }
}

//MARK: - GalleryViewOutput

extension GalleryPresenter: GalleryViewOutput {
    
    func viewDidLoad() {
        interactor.getPhotos()
    }
    
    func didPressPhoto(by index: Int) {
        router.showDetail(by: photoViewModels[index])
    }
    
    func didPressSearch(by text: String) {
        interactor.getSearchPhotos(by: text)
    }
    
    func willShowPhoto(by index: Int) {
        interactor.willShowPhoto(by: index)
    }
}

extension GalleryPresenter: GalleryInteractorOutput {
    
    func didObtain(photos: [Photo]) {
        photoViewModels = photos.map { PhotoViewModel(photo: $0) }
        view.reloadCollection()
    }
    
    func didAppendPhotos(at indexArr: [Int]) {
        let photoViewModels = indexArr.map { PhotoViewModel(photo: interactor.photos[$0]) }
        self.photoViewModels.append(contentsOf: photoViewModels)
        view.insertItems(at: indexArr)
    }
    
    func didUpdatePhotos() {
        photoViewModels = interactor.photos.map { PhotoViewModel(photo: $0) }
        view.reloadCollection()
    }
    
    func didCameError(_ error: Error) {
        view.show(message: error.localizedDescription)
    }
}

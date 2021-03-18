//
//  GalleryRouter.swift
//  Gallery
//
//  Created by Alex on 17.02.2021.
//

import UIKit

protocol GalleryRouterProtocol {
    func showDetail(by photosViewModels: PhotoViewModel)
}

final class GalleryRouter {
    
    unowned let view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
    }
}

//MARK: - GalleryRouterProtocol

extension GalleryRouter: GalleryRouterProtocol {
    
    func showDetail(by photosViewModel: PhotoViewModel) {
        let detailVC = DetailBilder.getDetailVC(by: photosViewModel)
        view.present(detailVC, animated: true)
    }
}

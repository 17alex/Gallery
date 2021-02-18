//
//  PhotoViewModel.swift
//  Gallery
//
//  Created by Alex on 17.02.2021.
//

import Foundation

struct PhotoViewModel {
    let photographer: String
    let link: String
    let date: String
    
    init(photo: Photo) {
        self.photographer = photo.photographer
        self.link = photo.links.medium
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_EN")
        dateFormatter.dateStyle = .medium
        self.date = dateFormatter.string(from: photo.date)
    }
}

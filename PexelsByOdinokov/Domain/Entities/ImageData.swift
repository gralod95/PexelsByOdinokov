//
//  ImageData.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 17.06.2024.
//

struct ImageData: ImageShortInfo {
    let id: Int
    let imageName: String
    let ownerName: String
    let previewUrl: String
    let imageUrl: String
    var previewImage: ImageState = .notLoaded
    var image: ImageState = .notLoaded
}

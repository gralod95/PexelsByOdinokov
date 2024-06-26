//
//  ImageShortInfo.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

protocol ImageShortInfo {
    var id: Int { get }
    var imageName: String { get }
    var ownerName: String { get }
    var previewImage: ImageState { get }
}

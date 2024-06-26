//
//  ImagesDataDto.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import Foundation

struct ImagesDataDto: Codable {
    let photos: [ImageDataDto]
}

extension ImagesDataDto {
    struct ImageDataDto: Codable {
        let id: Int
        let photographer: String
        let alt: String
        let src: Source
    }

    struct Source: Codable {
        let small: String
        let original: String
    }
}

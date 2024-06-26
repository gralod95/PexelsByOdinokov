//
//  MainSceneTableViewCellData.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

struct MainSceneTableViewCellData: Hashable {
    let id: Int
    let title: String
    let subtitle: String
    let image: Image

    enum Image {
        case loading
        case image(UIImage)
        case failedToLoad

        private var id: String {
            switch self {
            case .loading:
                return "loading"
            case .image:
                return "image"
            case .failedToLoad:
                return "failedToLoad"
            }

        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lth: Self, rth: Self) -> Bool {
        lth.id == rth.id
    }
}

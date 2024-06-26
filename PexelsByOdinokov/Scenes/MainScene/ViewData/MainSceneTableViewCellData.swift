//
//  MainSceneTableViewCellData.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import UIKit

struct MainSceneTableViewCellData {
    let id: Int
    let title: String
    let subtitle: String
    let image: Image
}

extension MainSceneTableViewCellData {
    enum Image {
        case loading
        case image(UIImage)
        case failedToLoad
    }
}

extension MainSceneTableViewCellData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func ==(lth: Self, rth: Self) -> Bool {
        lth.id == rth.id
    }
}

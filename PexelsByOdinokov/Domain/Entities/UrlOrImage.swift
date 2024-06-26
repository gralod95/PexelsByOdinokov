//
//  UrlOrImage.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 20.06.2024.
//

import UIKit

enum UrlOrImage {
    case url(String)
    case image(UIImage)
    case outOfScopeError
}

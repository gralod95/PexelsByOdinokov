//
//  DetailSceneViewData.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 20.06.2024.
//

import UIKit

enum DetailSceneViewData {
    case loading
    case loadingError(LoadingErrorViewData)
    case image(UIImage)
}

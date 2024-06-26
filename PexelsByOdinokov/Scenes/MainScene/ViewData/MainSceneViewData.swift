//
//  MainSceneViewData.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

import Foundation

enum MainSceneViewData {
    case loading
    case loadingError(LoadingErrorViewData)
    case cellsData([MainSceneTableViewCellData])
}

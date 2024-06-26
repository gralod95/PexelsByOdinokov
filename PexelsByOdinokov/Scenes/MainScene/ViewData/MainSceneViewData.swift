//
//  MainSceneViewData.swift
//  PexelsByOdinokov
//
//  Created by Odinokov G. A. on 16.06.2024.
//

enum MainSceneViewData {
    case loading
    case loadingError(LoadingErrorViewData)
    case cellsData([MainSceneTableViewCellData])
}

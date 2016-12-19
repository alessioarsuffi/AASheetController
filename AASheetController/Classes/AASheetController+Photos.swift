//
//  RSAlertController+Photos.swift
//  RSAlertController
//
//  Created by Alessio Arsuffi on 07/12/2016.
//  Copyright © 2016 Alessio Arsuffi. All rights reserved.
//

import Photos

/// This extension add 
extension AASheetController {
    
    func fetchAllPhotos() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        if status == .authorized {
            prepareFetchResult()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status) in
                DispatchQueue.main.async {
                    if status != .authorized {
                        self.showCollectionView = false
                    } else {
                        self.prepareFetchResult()
                    }
                }
            })
        }
    }
    
    fileprivate func prepareFetchResult() {
        if self.fetchResult == nil {
            let allPhotosOptions = PHFetchOptions()
            allPhotosOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            self.fetchResult = PHAsset.fetchAssets(with: allPhotosOptions)
        }
    }
    
    func targetSize() -> CGSize {
        let scale = UIScreen.main.scale
        return CGSize(width: scale * imageSize.width, height: scale * imageSize.height)
    }
}

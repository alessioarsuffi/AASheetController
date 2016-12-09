//
//  RSAlertController.swift
//  RSAlertController
//
//  Created by Alessio Arsuffi on 07/12/2016.
//  Copyright © 2016 Alessio Arsuffi. All rights reserved.
//

import UIKit
import Photos

public protocol AASheetControllerDelegate: class {
    
    func didSelect(image: UIImage)
}

public class AASheetController: UIViewController {
    
    // MARK: Properties
    
    /// This variable is the size of the image that you want back in delegate didSelect(image:) method
    public var imageSize = CGSize.zero
    
    public let cellSize = CGSize(width: 100, height: 100)
    
    /// Whether a cancel button should be visible at the bottom of the actionSheet
    /// - note: default = true
    public var showCancelButton: Bool = true {
        didSet {
            shouldShowCancelButton()
        }
    }
    
    public weak var delegate: AASheetControllerDelegate?
    
    /// Whether system photoLibrary should be visible at the top of the actionSheet
    /// - note: default = true
    public var showCollectionView: Bool = true {
        didSet {
            shouldShowCollectionView()
        }
    }
    
    /// Change this value to edit action view height
    public var alertStackViewHeight : CGFloat = 57
    
    
    var separator = UIImageView()
    
    var fetchResult: PHFetchResult<PHAsset>! {
        didSet {
            collectionView.reloadData()
            imageManager = PHCachingImageManager()
        }
    }
    
    var imageManager: PHCachingImageManager? = nil
    
    // MARK: IBOutlets
    
    @IBOutlet weak var alertMaskBackground: UIImageView!
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var upperView: UIView! {
        didSet {
            upperView.layer.cornerRadius = 13
        }
    }
    
    @IBOutlet weak var alertActionStackView: UIStackView!
    
    @IBOutlet weak var cancelButtonView: UIView! {
        didSet {
            cancelButtonView.layer.cornerRadius = 13
        }
    }
    
    @IBOutlet weak var alertStackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            
            let cellNib = UINib.init(nibName: "AACollectionViewCell", bundle: Bundle(for: self.classForCoder))
            
            collectionView.register(cellNib, forCellWithReuseIdentifier: AACollectionViewCell.identifier)
        }
    }
    
    @IBOutlet weak var alertViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var alertDescription: UILabel!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var alertImage: UIImageView!
    
    // MARK: View lifecycle
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateAppearing()
        shouldShowCollectionView()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animateDisappearing()
    }
    
    //MARK: - Initialiser
    @objc public convenience init(barButtonItem: UIBarButtonItem?) {
        self.init()
        let nib = loadNibAlertController()
        if nib != nil{
            self.view = nib![0] as! UIView
        }
        
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        
        if let popover = popoverPresentationController, barButtonItem != nil {
            popover.barButtonItem = barButtonItem
            modalPresentationStyle = .popover
        }
        
        shouldShowCancelButton()
        dismissOnTapOutside()
    }
    
    // MARK: - Separator
    
    fileprivate func addSeparator() {
        separator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        alertActionStackView.addSubview(separator)
        
        // Autolayout separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.topAnchor.constraint(equalTo: alertActionStackView.topAnchor).isActive = true
        separator.centerXAnchor.constraint(equalTo: alertActionStackView.centerXAnchor).isActive = true
        separator.heightAnchor.constraint(equalTo: alertActionStackView.heightAnchor).isActive = true
        separator.widthAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    //MARK: - Actions
    @objc public func addAction(_ alertAction: AASheetAction) {
        alertActionStackView.addArrangedSubview(alertAction)
        
        alertActionStackView.axis = .vertical
        
        alertStackViewHeightConstraint.constant = alertStackViewHeight * CGFloat(alertActionStackView.arrangedSubviews.count)
        
        alertAction.addTarget(self, action: #selector(AASheetController.dismissAlertController(_:)), for: .touchUpInside)
    }
    
    fileprivate func addCancelAction() {
        let cancelAction = AASheetAction(title: "Cancel", style: .cancel)
        
        cancelButtonView.addSubview(cancelAction)
        cancelAction.translatesAutoresizingMaskIntoConstraints = false
        cancelAction.widthAnchor.constraint(equalTo: cancelButtonView.widthAnchor).isActive = true
        cancelAction.heightAnchor.constraint(equalTo: cancelButtonView.heightAnchor).isActive = true
        cancelAction.centerXAnchor.constraint(equalTo: cancelButtonView.centerXAnchor).isActive = true
        cancelAction.topAnchor.constraint(equalTo: cancelButtonView.topAnchor).isActive = true
        
        cancelAction.addTarget(self, action: #selector(AASheetController.dismissAlertController(_:)), for: .touchUpInside)
    }
    
    @objc fileprivate func dismissAlertController(_ sender: AASheetAction) {
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func dismissOnTapOutside() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AASheetController.dismissAlertController(_:)))
        
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        
        alertMaskBackground.addGestureRecognizer(tapGesture)
        alertMaskBackground.isUserInteractionEnabled = true
    }
    
    //MARK: - Customizations
    
    fileprivate func shouldShowCancelButton() {
        if showCancelButton {
            cancelButtonView.isHidden = false
            addCancelAction()
        } else {
            cancelButtonView.subviews.forEach({ $0.removeFromSuperview() })
            cancelButtonView.isHidden = true
        }
    }
    
    fileprivate func shouldShowCollectionView() {
        if showCollectionView {
            fetchAllPhotos()
        } else {
            collectionView.isHidden = true
        }
    }
    
    @objc fileprivate func loadNibAlertController() -> [AnyObject]? {
        let podBundle = Bundle(for: self.classForCoder)
        
        if let bundleURL = podBundle.url(forResource: "AASheetController", withExtension: "bundle"){
            
            if let bundle = Bundle(url: bundleURL) {
                return bundle.loadNibNamed("AASheetController", owner: self, options: nil) as [AnyObject]?
            }
            else {
                assertionFailure("Could not load the bundle")
            }
            
        }
        else if let nib = podBundle.loadNibNamed("AASheetController", owner: self, options: nil) as [AnyObject]? {
            return nib
        }
        else{
            assertionFailure("Could not create a path to the bundle")
        }
        return nil
    }
    
    //MARK: - Animations
    
    fileprivate func animateAppearing() {
        alertMaskBackground.backgroundColor = UIColor.black.withAlphaComponent(0.00)
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
            var alertViewFrame = self.alertView.frame
            alertViewFrame.origin.y -= self.view.frame.size.height
            
            self.alertView.frame = alertViewFrame
            self.alertMaskBackground.backgroundColor = self.modalPresentationStyle == .overCurrentContext ? UIColor.black.withAlphaComponent(0.40) : .clear
        }, completion: { (finished: Bool) in
        })
    }
    
    fileprivate func animateDisappearing() {
        alertMaskBackground.backgroundColor = modalPresentationStyle == .overCurrentContext ? UIColor.black.withAlphaComponent(0.40) : .clear
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseInOut, animations: {
            var alertViewFrame = self.alertView.frame
            alertViewFrame.origin.y += self.view.frame.size.height
            
            self.alertView.frame = alertViewFrame
            self.alertMaskBackground.backgroundColor = UIColor.black.withAlphaComponent(0.00)
        }, completion: { (finished: Bool) in
        })
    }
}


// MARK: - UICollectionViewDataSource, UICollectionViewDelegate, 
extension AASheetController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult == nil ? 0 : fetchResult.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AACollectionViewCell.identifier, for: indexPath) as! AACollectionViewCell
        
        let asset = fetchResult.object(at: indexPath.item)
        cell.representedAssetIdentifier = asset.localIdentifier
        imageManager?.requestImage(for: asset, targetSize: cellSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.representedAssetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        })
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = fetchResult.object(at: indexPath.item)
        
        imageManager?.requestImage(for: asset, targetSize: targetSize(), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            self.delegate?.didSelect(image: image!)
            self.dismiss(animated: true, completion: nil)
        })
    }
}

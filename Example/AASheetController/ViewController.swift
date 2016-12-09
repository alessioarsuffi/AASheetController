//
//  ViewController.swift
//  AASheetController
//
//  Created by Alessio Arsuffi on 12/09/2016.
//  Copyright (c) 2016 Alessio Arsuffi. All rights reserved.
//

import UIKit
import AASheetController

class ViewController: UIViewController {

    // MARK: IBOutlets
    
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var showActionSheetBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var showBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var chosenImageView: UIImageView!
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    
    @IBAction func showAppleActionSheetPressed(_ sender: Any) {
        let alertController = UIAlertController(title: "This is a title", message: "This is a message", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            print("cancel pressed")
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("ok pressed")
        }
        alertController.addAction(OKAction)
        
        let destroyAction = UIAlertAction(title: "Destroy", style: .destructive) { (action) in
            print("destroy pressed")
        }
        alertController.addAction(destroyAction)
        
        alertController.modalPresentationStyle = .popover
        
        if let popover = alertController.popoverPresentationController {
            popover.barButtonItem = showActionSheetBarButtonItem
        }
        
        self.present(alertController, animated: true) {}
    }
    
    @IBAction func showBarButtonItemPressed(_ sender: Any) {
        
        let alertVC = AASheetController(barButtonItem: showBarButtonItem)
        
        /// Wanna hide cancel button?
        //alertVC.showCancelButton = false
        
        /// Wanna hide collectionView with images?
        //alertVC.showCollectionView = false
        
        alertVC.delegate = self
        alertVC.imageSize = chosenImageView.frame.size
        
        alertVC.addAction(AASheetAction(title: "Custom", style: .default, action: { () -> Void in
            print("custom pressed")
        }))
        
        alertVC.addAction(AASheetAction(title: "Destructive", style: .destructive, action: { () in
            print("destructive pressed")
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension ViewController: AASheetControllerDelegate {
    
    func didSelect(image: UIImage) {
        chosenImageView.image = image
    }
}

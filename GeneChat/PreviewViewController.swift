//
//  PreviewViewController.swift
//  GeneChat
//
//  Created by ChaCha on 9/12/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController
{
    
    @IBOutlet weak var imagePreview: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                let (__, fullFileName) = CameraViewController.getSnapFileName()
        imagePreview.image = UIImage(contentsOfFile: fullFileName)
    }
}

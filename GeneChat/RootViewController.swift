//
//  ViewController.swift
//  GeneChat
//
//  Created by ChaCha on 9/10/14.
//  Copyright (c) 2014 ChaCha_gmo. All rights reserved.
//

import UIKit

class RootViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    var redViewController : RedViewController!
    var cameraViewController : CameraViewController!
    var blueViewController : BlueViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        self.redViewController =
            self.storyboard?.instantiateViewControllerWithIdentifier("redViewController") as? RedViewController
        self.redViewController.title = "Red"
        
        self.cameraViewController =
            self.storyboard?.instantiateViewControllerWithIdentifier("cameraViewController") as? CameraViewController
        self.cameraViewController.title = "Camera"
        
        self.blueViewController =
            self.storyboard?.instantiateViewControllerWithIdentifier("blueViewController") as? BlueViewController
        self.blueViewController.title = "Azul"
        
        var startingViewControllers : NSArray = [self.cameraViewController]
    
        self.setViewControllers(startingViewControllers, direction: .Forward, animated: false, completion: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
//        println(viewController.title!)
        switch viewController.title! {
        case "Red":
            return nil
        case "Camera":
            return redViewController
        case "Azul":
            return cameraViewController
        default:
            return nil
            
        }
        
    }
   
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
       
//        println(viewController.title!)
        switch viewController.title! {
        case "Red":
            return cameraViewController
        case "Camera":
            return blueViewController
        case "Azul":
            return nil
        default:
            return nil
    }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


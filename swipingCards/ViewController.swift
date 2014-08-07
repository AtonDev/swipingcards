//
//  ViewController.swift
//  swipingCards
//
//  Created by APG on 06/08/14.
//  Copyright (c) 2014 APG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet weak var _progressBar: UIProgressView!
    @IBOutlet weak var _queryBox: UITextField!
    @IBOutlet weak var _webView: UIWebView!
    
    var pageTitles:[String] = ["one", "two", "three", "four"]
    var pageColors:[UIColor] = [UIColor.blueColor(), UIColor.greenColor(), UIColor.redColor(), UIColor.yellowColor()]
    var pageViewController:UIPageViewController!
    
    @IBAction func searchButton(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._webView.loadRequest(NSURLRequest(URL: NSURL(string: "http://en.wikipedia.org/wiki/Albert_Einstein")))
        
        self.pageViewController = self.storyboard.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
        self.pageViewController.dataSource = self
        
        let startingController:PageContentViewController = self.viewControllerAtIndex(0)!
        let viewControllers: NSArray = [startingController]
        self.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        
        self.pageViewController.view.frame = CGRect(x:0, y:60, width:self.view.frame.width, height: self.view.frame.height-60)
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController!.didMoveToParentViewController(self)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewControllerAtIndex(index:Int)->PageContentViewController? {
        if self.pageTitles.count == 0 || index >= self.pageTitles.count
        {
            return nil
        }
        let pageView:PageContentViewController = self.storyboard.instantiateViewControllerWithIdentifier("PageContentViewController") as PageContentViewController
        pageView.pageIndex = index

        return pageView
    }
    
    // MARK: - page controller data source
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController! {
        var index:Int = (viewController as PageContentViewController).pageIndex
        if ((index==0) || (index == NSNotFound)) {
            return nil
        }
        
        index--;
        println("before \(String(index))")
        return self.viewControllerAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController! {
        var index:Int = (viewController as PageContentViewController).pageIndex
        if index == NSNotFound {
            return nil
        }
        
        index++
        if index==self.pageTitles.count {
            return nil
        }
        println("after \(String(index))")
        return self.viewControllerAtIndex(index)
    }



}


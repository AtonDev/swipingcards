//
//  ViewController.swift
//  swipingCards
//
//  Created by APG on 06/08/14.
//  Copyright (c) 2014 APG. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIWebViewDelegate, UIPageViewControllerDelegate, UISearchBarDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var _progressBar: UIProgressView!
    //@IBOutlet weak var _queryBox: UITextField!
    @IBOutlet weak var _webView: UIWebView!
    @IBOutlet weak var _searchBar: UISearchBar!

    
    
    var _pageViewController:UIPageViewController!
    
    let searchURLstr =  "http://search.alts.io/scomp?search="
    
    var _urls = []
    var _abstracts = []
    var _titles = []
    var _dispurls = []
    var _currentIndex = 0
    
    //@IBAction func searchButton(sender: AnyObject) {
    //    self.beginSearch()
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self._webView.delegate = self
        //self._queryBox.delegate = self
        self._searchBar.delegate = self
        self._progressBar.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
        
        // Do any additional setup after loading the view.
        let activateCards : Selector = "activateCards"
        let rightSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: activateCards)
        let leftSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: activateCards)
        rightSwipe.edges = UIRectEdge.Left
        leftSwipe.edges = UIRectEdge.Right
        self._webView.addGestureRecognizer(rightSwipe)
        view.addGestureRecognizer(leftSwipe)

    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - cards methods
    
    func initCards() {
        //self._webView.loadRequest(NSURLRequest(URL: NSURL(string: self._urls[0] as String)))
        
        self._pageViewController = self.storyboard.instantiateViewControllerWithIdentifier("PageViewController") as UIPageViewController
        self._pageViewController.dataSource = self
        self._pageViewController.delegate = self
        
        let startingController:PageContentViewController = self.cardAtIndex(0)!
        let viewControllers: NSArray = [startingController]
        self._pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
        
        self._pageViewController.view.frame = CGRect(x:0, y:66, width:self.view.frame.width, height: self.view.frame.height-60)
        
        self.addChildViewController(self._pageViewController)
        self.view.addSubview(self._pageViewController.view)
        self._pageViewController!.didMoveToParentViewController(self)
        
        for gesture in self._pageViewController.gestureRecognizers {
            (gesture as UIGestureRecognizer).delegate = self
        }
        
    }
    
    @IBAction func activateCards() {
        self._pageViewController.view.alpha = 1
    }
    
    func cardAtIndex(index:Int)->PageContentViewController? {
        if self._urls.count == 0 || index >= self._urls.count {return nil}
        let pageView:PageContentViewController = self.storyboard.instantiateViewControllerWithIdentifier("PageContentViewController") as PageContentViewController
        //pageView._index = index
        pageView._pageIndex = index
        pageView._title = self._titles[index] as String
        pageView._abstract = self._abstracts[index] as String
        
        
        return pageView
    }
        
    // MARK: - searchbar delegate methods
    
    func beginSearch(query:String) {
        self.getURLs(query)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar!) {
        beginSearch(searchBar.text)
        searchBar.resignFirstResponder()
    }
    
    
    // MARK: - web view helpers
    func getURLs(query:String) {
        var url:NSURL = NSURL(string: (self.searchURLstr + query).stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()))
        println("getURLs called")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url){(data, response, error) in
            if data.length != 0 {
                self._currentIndex = 0
                let jsonDict = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: nil) as NSDictionary
                self._urls = jsonDict["urls"] as NSArray
                self._abstracts = jsonDict["abstracts"] as NSArray
                self._titles = jsonDict["titles"] as NSArray
                self._dispurls = jsonDict["dispurls"] as NSArray
                
                self.loadURL(0)
                //println(response)
                
                //callback runs on a background thread and UI elements cannot be updated from background threads
                //this sends the ui update call to the main thread
                dispatch_async(dispatch_get_main_queue(), {self.initCards()})
            }
        }
        task.resume()
        
    }
    
    func loadURL(idx:Int) {
        let url: NSURL = (NSURL(string: self._urls[idx] as String))
        self._webView.loadRequest(NSURLRequest(URL: url))
    }
    
    
    
    
    // MARK: - page controller data source
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerBeforeViewController viewController: UIViewController!) -> UIViewController! {
        var index:Int = (viewController as PageContentViewController)._pageIndex
        if ((index==0)) {
            return nil
        }
        
        index--;
        //println("before \(String(index))")
        return self.cardAtIndex(index)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController!, viewControllerAfterViewController viewController: UIViewController!) -> UIViewController! {
        var index:Int = (viewController as PageContentViewController)._pageIndex
        //if index == NSNotFound {return nil}
        
        index++
        if index==self._urls.count {return nil}
        //println("after \(String(index))")
        return self.cardAtIndex(index)
    }
    
    
    // MARK: - page controller delegate
    
    func pageViewController(pageViewController: UIPageViewController!, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject]!, transitionCompleted completed: Bool) {
        if completed {
            loadURL(self._currentIndex)
        }
        
    }
    
    func pageViewController(pageViewController: UIPageViewController!, willTransitionToViewControllers pendingViewControllers: [AnyObject]!) {
        self.movePageViewOnTop()
        var idx:Int = (pendingViewControllers[0] as PageContentViewController)._pageIndex
        self._currentIndex = idx
    }
   
    // MARK: - web view delegate methods
    
    var webViewLoads_:Int = 0
    
    func webViewDidStartLoad(webView: UIWebView!) {
        if webViewLoads_ == 0 { self.startLoadingProgressBar() }
        webViewLoads_++
        self.movePageViewOnTop()
    }
    
    func webViewDidFinishLoad(webView: UIWebView!) {
        webViewLoads_--
        if webViewLoads_ == 0 {
            self.stopLoadingProgressBar()
            self.moveWebViewOnTop()
        }
        //self._pageViewController.view.alpha = 0
    }
    
    func webView(webView: UIWebView!, didFailLoadWithError error: NSError!) {
        webViewLoads_--
    }
    
    func moveWebViewOnTop() {
        var mainWindow:UIWindow = UIApplication.sharedApplication().keyWindow
        mainWindow.addSubview(self._webView)
    }
    
    func movePageViewOnTop() {
        var mainWindow:UIWindow = UIApplication.sharedApplication().keyWindow
        mainWindow.addSubview(self._pageViewController.view)
    }
    
    
    //MARK: - progress bar stuff
    var timer:NSTimer!
    var isLoading:Bool!
    
    func startLoadingProgressBar() {
        self._progressBar.hidden = false
        self._progressBar.progress = 0
        isLoading = true
        timer = NSTimer.scheduledTimerWithTimeInterval(0.016667, target: self, selector: "timerCallback", userInfo: nil, repeats: true)
    }
    
    func stopLoadingProgressBar() {
        //println("stop loading called")
        isLoading = false
    }
    
    func timerCallback() {
        //println("is loading \(isLoading)")
        if (isLoading == true) {
            self._progressBar.progress += 0.01
            if self._progressBar.progress > 0.95 { self._progressBar.progress = 0.95 }
        } else {
            //println("\(self._progressBar.progress)")
            if self._progressBar.progress >= 1 {
                timer.invalidate()
                self._progressBar.hidden = true
            } else { self._progressBar.progress += 0.05 }
        }
    }
    
}


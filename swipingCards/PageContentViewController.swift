//
//  PageContentViewController.swift
//  swipingCards
//
//  Created by APG on 06/08/14.
//  Copyright (c) 2014 APG. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    //var _index = 0
    var _pageIndex: Int!
    var _title = ""
    var _abstract = ""
    @IBOutlet var _backgroundView: UIView!
    @IBOutlet weak var _cardView: UIView!
    @IBOutlet weak var _cardTitle: UILabel!
    @IBOutlet weak var _cardAbstract: UITextView!
    
    
    
    override func viewDidLoad() {
        //self._pageIndex = self._index
        //println("loading content view with index \(String(self._pageIndex))")
        super.viewDidLoad()
        let bg:UIColor = UIColor(red:0, green: 0, blue: 0, alpha: 0.3)
        self._backgroundView.backgroundColor = bg
        self._cardTitle.text = self._title
        self._cardAbstract.text = self._abstract
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //self._pageIndex = self._index
        println("current index \(self._pageIndex)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

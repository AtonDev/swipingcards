//
//  PageContentViewController.swift
//  swipingCards
//
//  Created by APG on 06/08/14.
//  Copyright (c) 2014 APG. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {
    
    var pageIndex:Int = 0
    @IBOutlet var _backgroundView: UIView!
    @IBOutlet weak var _cardView: UIView!
    @IBOutlet weak var _cardTitle: UILabel!
    @IBOutlet weak var _cardAbstract: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bg:UIColor = UIColor(red:0, green: 0, blue: 0, alpha: 0.3)
        self._backgroundView.backgroundColor = bg
        
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

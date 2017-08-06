//
//  WebViewController.swift
//  Hubtele
//
//  Created by NakamaTakaaki on 2016/06/02.
//  Copyright © 2016年 NakamaTakaaki. All rights reserved.
//

import Foundation
import UIKit

class MyWebViewController:UIViewController,UIWebViewDelegate{
    
   
    @IBOutlet weak var webView: UIWebView!
    var url:String?
    var title1:String?
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: "MyWebViewController", bundle: nil)
    }
    
    convenience init(url:String, title:String) {
        self.init(nibName: nil, bundle: nil)
        self.url=url
        self.title1=title
    }
    
    override func viewDidLoad() {
        self.title=title1
        webView.delegate=self
        webView.loadRequest(NSURLRequest(URL:NSURL(string:self.url!)!))
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        if(request.URL?.path=="/"){
            self.navigationController?.popViewControllerAnimated(true)
            
            return false
        }else{
            return true
        }
    }
}
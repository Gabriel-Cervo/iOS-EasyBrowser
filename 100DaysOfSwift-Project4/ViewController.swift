//
//  ViewController.swift
//  100DaysOfSwift-Project4
//
//  Created by João Gabriel Dourado Cervo on 28/01/21.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    
    override func loadView() {
        // Muda a view principal para carregar o webView ao invés do storyboard
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://github.com")!
        
        webView.load(URLRequest(url: url)) // Necessario fazer o request, se nao webView nao carrega a pag
        webView.allowsBackForwardNavigationGestures = true // Passar dedo pra ir/votar pag, sempre bom ter
    }


}


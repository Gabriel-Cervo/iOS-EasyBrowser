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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        let url = URL(string: "https://google.com")!
        
        webView.load(URLRequest(url: url)) // Necessario fazer o request, se nao webView nao carrega a pag
        webView.allowsBackForwardNavigationGestures = true // Passar dedo pra ir/votar pag, sempre bom ter
    }
    
    @objc func openTapped() {
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        alertController.addAction(UIAlertAction(title: "github.com", style: .default, handler: openPage))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        
        present(alertController, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "http://\(action.title!)")!
        
        webView.load(URLRequest(url: url)) // carrega na webView
    }
    
    // Metodo que faz algo quando pag for carregada
    // necessario webView delegate ser para esta classe
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }


}


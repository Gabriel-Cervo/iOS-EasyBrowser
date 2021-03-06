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
    var progressView: UIProgressView!
    var websites = ["google.com", "apple.com", "github.com"]
    
    override func loadView() {
        // Muda a view principal para carregar o webView ao invés do storyboard
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        progressView = UIProgressView(progressViewStyle: .default) // tem tambem o modo .bar, ele nao mostra uma linha vazia, mas nesse caso o .default fica melhor
        progressView.sizeToFit() // Enquadra conteudo para ver inteiro
        
        let progressButton = UIBarButtonItem(customView: progressView) // Cria um BarButton com uma custom view
        
        // Itens para toolbar
        let goBack = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: webView, action: #selector(webView.goBack))
        let goForward = UIBarButtonItem(image: UIImage(systemName: "arrow.right"), style: .plain, target: webView, action: #selector(webView.goForward))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        navigationItem.rightBarButtonItem = refresh
        
        toolbarItems = [goBack, spacer, progressButton, spacer, goForward] // define os itens
        navigationController?.isToolbarHidden = false // mostra a toolbar
        // Toolbar -> barra embaixo
        
        let url = URL(string: "https://\(websites[0])")!
        
        webView.load(URLRequest(url: url)) // Necessario fazer o request, se nao webView nao carrega a pag
        webView.allowsBackForwardNavigationGestures = true // Passar dedo pra ir/votar pag, sempre bom ter
        
        /**
         KVO -> Key-value-observing: visa a view quando o valor X da propriedade Y mudar
         
         #Warning: in more complex applications, all calls to addObserver() should be matched with a call to removeObserver() when you're finished observing – for example, when you're done with the view controller.
         */
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        /**
        o options .new manda junto o novo valor, e nao apenas diz que mudou, .old o fantigo e etc...
        self no observer pois é esta classe que vai observar as mudanças
         
        keyPath funciona como o #selector... Faz com que o compilador verifique que o valor existe de fato ali
         
        o context provem um valor unico, que é mandado de volta quando se tem a notificação que o valor mudou, isso faz com que consiga se verificar o contexto e ter certeza que foi o observer x que foi chamado
        */
    }
    
    @objc func openTapped() {
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        for website in websites {
            alertController.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        
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
    
    /**
     @escaping diz que a closure pode ser chamada depois do metodo, por exemplo:
        chamar o decisionHandler apos o usuario fazer algo (perguntar algo, etc), e nao na execucao deste metodo
     */
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        
        // nem todos sites tem host, necessario checkar
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }
        
        cancelLoading(decisionHandler)
    }
    
    // Necessario implementar devido ai KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func cancelLoading(_ decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let alertController = UIAlertController(title: "This website is blocked!", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(alertController, animated: true)
        
        decisionHandler(.cancel)
    }
}


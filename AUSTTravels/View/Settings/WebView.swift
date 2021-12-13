//
//  WebView.swift
//  AUSTTravels
//
//  Created by Shahriar Nasim Nafi on 13/12/21.
//  Copyright © 2021 Shahriar Nasim Nafi. All rights reserved.
//

import SwiftUI
import WebKit
import UIKit

struct Webview: UIViewRepresentable {
    let url: URL
    let trigger: () -> ()
    
    func makeUIView(context: UIViewRepresentableContext<Webview>) -> WKWebView {
        let webview = WKWebView()
        webview.navigationDelegate = context.coordinator
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
        return webview
    }
    
    func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<Webview>) {
        let request = URLRequest(url: self.url, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(trigger: trigger)
    }
}

class Coordinator: NSObject, WKNavigationDelegate {
    
    let trigger: () -> ()
    
    init(trigger: @escaping () -> ()) {
        self.trigger = trigger
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
       trigger()
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("didStartProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("webviewDidCommit")
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("didReceiveAuthenticationChallenge")
        completionHandler(.performDefaultHandling, nil)
    }
}

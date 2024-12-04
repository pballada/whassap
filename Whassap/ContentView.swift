//
//  ContentView.swift
//  Whassap
//
//  Created by Pau on 7/10/24.
//

import SwiftUI
@preconcurrency import WebKit

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    var parent: WhatsAppWebView
    
    init(_ parent: WhatsAppWebView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            if url.host != "web.whatsapp.com" {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
                return
            }
        }
        decisionHandler(.allow)
    }
}

struct WhatsAppWebView: UIViewRepresentable {
    let url: URL
    @Binding var webView: WKWebView?

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator

        let customUserAgent = "Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1"
        webView.customUserAgent = customUserAgent
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        DispatchQueue.main.async {
            self.webView = webView
        }
        
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}

    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
}

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var webView: WKWebView?

    var body: some View {
        TabView(selection: $selectedTab) {
            ZStack {
                WhatsAppWebView(url: URL(string: "https://web.whatsapp.com")!, webView: $webView)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            webView?.reload()
                        }) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 20))
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .foregroundColor(.white)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .tabItem {
                Image(systemName: "message")
                Text("WhatsApp")
            }
            .tag(0)
            
            VStack {
                Text("Welcome to the Extra Tab!")
                    .font(.title)
                    .padding()
                
                Text("This tab can be used for additional features or information related to your app.")
                    .multilineTextAlignment(.center)
                    .padding()
                
                Text("You can customize this tab with any content you'd like to include.")
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .tabItem {
                Image(systemName: "info.circle")
                Text("Info")
            }
            .tag(1)
        }
    }
}

@main
struct VisionProApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

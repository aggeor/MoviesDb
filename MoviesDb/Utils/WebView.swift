
import SwiftUI
import WebKit

struct WebView: View {
    let url:String
    var body: some View {
        WebViewUIViewRepresentable(url: url)
    }
}

struct WebViewUIViewRepresentable: UIViewRepresentable {
    var url: String
    let webView: WKWebView
    
    init(url: String) {
        self.url=url
        webView = WKWebView(frame: .zero)
    }
 
    
    
    func makeUIView(context: Context) -> WKWebView {
        return webView
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        webView.load(URLRequest(url: URL(string: url)!))
    }
}

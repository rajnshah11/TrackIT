//
//  FinanceNewsView.swift
//  TrackIT
//
//  Created by Raj Shah on 4/17/24.
//

import SwiftUI
import WebKit

struct FinanceNewsView: View {
    @ObservedObject var viewModel = FinanceNewsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.news) { newsItem in
                VStack(alignment: .leading, spacing: 8) {
                    Text(newsItem.title)
                        .font(.headline)
                    HStack {
                        Text("Author:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(newsItem.author)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    HStack {
                        Text("Published on:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Text(newsItem.date)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    NavigationLink(destination: WebView(url: newsItem.link)) {
                        Text("Read more...")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("Financial News", displayMode: .automatic)
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}

struct WebView: View {
    let url: String

    var body: some View {
        WebViewContainer(url: url)
            .edgesIgnoringSafeArea(.all)
            .navigationBarTitle("", displayMode: .inline)
    }
}

struct WebViewContainer: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    }
}

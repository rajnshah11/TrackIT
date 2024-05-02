//
//  ExpenseVideo.swift
//  TrackIT
//
//  Created by Raj Shah on 4/18/24.
//
import SwiftUI
import Firebase
import CoreData
import WebKit
struct ExpenseVideo: View {
    let videoIDs = ["IfpAjsytwy0", "VaiqGsot5ws", "bMXTGGxrQ3A", "J6oHchaCxvM", "4j2emMn7UaI"] // Array of YouTube video IDs
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                Text("Expense Videos")
                    .font(.largeTitle)
                    .bold() 
                ForEach(videoIDs, id: \.self) { videoID in
                    YouTubePlayer(videoID: videoID)
                        .frame(height: 200)
                        .padding(10)
                }
            }
        }
    }
    
    
    struct YouTubePlayer: UIViewRepresentable {
        let videoID: String
        
        func makeUIView(context: Context) -> WKWebView {
            let webView = WKWebView()
            return webView
        }
        
        func updateUIView(_ uiView: WKWebView, context: Context) {
            let embedHTML = """
            <iframe width="100%" height="95%" src="https://www.youtube.com/embed/\(videoID)" frameborder="0" allowfullscreen></iframe>
            """
            uiView.loadHTMLString(embedHTML, baseURL: nil)
        }
    }
}

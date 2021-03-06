//
//  ContentView.swift
//  playintSwiftUi
//
//  Created by Klaus Fischer on 04.03.21.
//

import SwiftUI

struct ContentView: View {
    @State var news: [HackerNews] = [HackerNews]()
    
    var body: some View {
        VStack {
            Text("Hacker news")
            List(news, id: \.id) { item in
                NewsItemTile(news: item)
            }
            .onAppear(perform: {
                loadNews()
            })
        }
    }
    
    private func loadNews() {
        HackerNewsService().getNews { (data) in
            print("Received data")
            print(data)
            self.news = data
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

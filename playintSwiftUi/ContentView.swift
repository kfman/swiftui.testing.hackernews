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
        List(news, id: \.id){ item in
            Text(item.headline)
        }
        .onAppear(perform: {
            loadNews()
        } )
    }
    

    private func loadNews(){
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

//
//  NewsItemTile.swift
//  playintSwiftUi
//
//  Created by Klaus Fischer on 06.03.21.
//

import SwiftUI

struct NewsItemTile: View {
    
    let news: HackerNews
    
    var body: some View {
        VStack {
            Text(news.title ?? "")
            Text(news.by ?? "")
        }.onTapGesture {
            print(news.url ?? "")
        }
    }
}

struct NewsItemTile_Previews: PreviewProvider {
    static var previews: some View {
        NewsItemTile(news: HackerNews(by: "Klaus", descendants: 10, id: 1000, kids: [123], score: 120, time: 1200, title: "Title", type: "Demo", url: "http://www.google.de"))
    }
}

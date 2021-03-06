//
//  RestBaseService.swift
//  playintSwiftUi
//
//  Created by Klaus Fischer on 04.03.21.
//

import Foundation


class RestBaseService<TModel> where TModel: Codable{
    
    func get(url: URL, finished: (Any)-> Void ){
        
        URLSession.init(configuration: .default).dataTask(with: url, completionHandler: { (data, response, error) in
            if let data = data {
                if let result = try? JSONDecoder().decode(TModel.self, from: data){
                    print("Got what...\(result)")
                }
            }
        }).resume()
        
    }
    
}

struct HackerNews : Codable{
    let id: Int
    let url: URL
    let headline: String
}

class NewsCollection:RestBaseService<[String]>{
    
    private let url: String
    
    init(url: String){
        self.url = url
    }
    
    func getTopStoryIds(onLoaded: @escaping ([String]) -> Void){
        
    }
    
    func getStory(id: String, onLoaded: @escaping (HackerNews) -> Void ){
        
    }
}




class HackerNewsService {
    
    func getNews( _ finished: @escaping ([HackerNews])->Void){
        var news = [HackerNews]()
        news.append(HackerNews(id: 0, url: URL(string: "http://www.google.de")!, headline: "Test #1"))
        news.append(HackerNews(id: 1, url: URL(string: "http://www.google.de")!, headline: "Test #2"))
        news.append(HackerNews(id: 2, url: URL(string: "http://www.google.de")!, headline: "Test #3"))
        news.append(HackerNews(id: 3, url: URL(string: "http://www.google.de")!, headline: "Test #4"))
        news.append(HackerNews(id: 4, url: URL(string: "http://www.google.de")!, headline: "Test #5"))
        news.append(HackerNews(id: 5, url: URL(string: "http://www.google.de")!, headline: "Test #6"))
        news.append(HackerNews(id: 6, url: URL(string: "http://www.google.de")!, headline: "Test #7"))
        news.append(HackerNews(id: 7, url: URL(string: "http://www.google.de")!, headline: "Test #8"))
        news.append(HackerNews(id: 8, url: URL(string: "http://www.google.de")!, headline: "Test #9"))
        news.append(HackerNews(id: 9, url: URL(string: "http://www.google.de")!, headline: "Test #10"))
        
        finished(news)
    }
    
}


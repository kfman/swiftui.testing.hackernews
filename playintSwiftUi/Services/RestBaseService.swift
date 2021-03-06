//
//  RestBaseService.swift
//  playintSwiftUi
//
//  Created by Klaus Fischer on 04.03.21.
//

import Foundation

struct Settings{
    static let baseUrl : String = "https://hacker-news.firebaseio.com/v0"
}

class RestBaseService{


    func get<TResult>(endpoint: String, finished: @escaping (TResult) -> Void) where TResult: Codable{
        let completeUrl = "\(Settings.baseUrl)\(endpoint)"
        guard let callUrl = URL(string: completeUrl) else {
            print("Error on creating url \(completeUrl)")
            return
        }
        
        URLSession.init(configuration: .default).dataTask(with: callUrl, completionHandler: { (data, response, error) in
            if let data = data {
                if let result = try? JSONDecoder().decode(TResult.self, from: data){
                    print("Got what...\(result)")
                    finished(result)
                }else{
                    print("Error on decoding \(TResult.self) result \(String(bytes: data, encoding: .utf8) ?? "Bad error")")
                }
            }
            
            if let error = error {
                    print(error)
            }
            
        }).resume()
        

    }
}

struct HackerNews : Codable{
    let id: Int
    let url: URL
    let headline: String
}

class NewsCollection:RestBaseService{
    
    private let endpoint: String
    
    init(endpoint: String){
        self.endpoint = endpoint
    }
    
    func getTopStoryIds(onLoaded: @escaping ([Int]) -> Void){
        super.get(endpoint: endpoint) { (data: [Int]) in
            onLoaded(data)
        }
    }
    
    func getStory(id: Int, onLoaded: @escaping (HackerNews) -> Void ){
        
    }
}




class HackerNewsService {
    let newsCollection: NewsCollection
    
    
    init() {
        newsCollection = NewsCollection(endpoint: "/topstories.json")
    }
    
    func getNews( _ finished: @escaping ([HackerNews])->Void){
        var news = [HackerNews]()
//        news.append(HackerNews(id: 0, url: URL(string: "http://www.google.de")!, headline: "Test #1"))
//        news.append(HackerNews(id: 1, url: URL(string: "http://www.google.de")!, headline: "Test #2"))
//        news.append(HackerNews(id: 2, url: URL(string: "http://www.google.de")!, headline: "Test #3"))
//        news.append(HackerNews(id: 3, url: URL(string: "http://www.google.de")!, headline: "Test #4"))
//        news.append(HackerNews(id: 4, url: URL(string: "http://www.google.de")!, headline: "Test #5"))
//        news.append(HackerNews(id: 5, url: URL(string: "http://www.google.de")!, headline: "Test #6"))
//        news.append(HackerNews(id: 6, url: URL(string: "http://www.google.de")!, headline: "Test #7"))
//        news.append(HackerNews(id: 7, url: URL(string: "http://www.google.de")!, headline: "Test #8"))
//        news.append(HackerNews(id: 8, url: URL(string: "http://www.google.de")!, headline: "Test #9"))
//        news.append(HackerNews(id: 9, url: URL(string: "http://www.google.de")!, headline: "Test #10"))
        
        let group = DispatchGroup()
        newsCollection.getTopStoryIds { (ids) in
            for id in ids {
                group.enter()
                self.newsCollection.getStory(id: id) { (item) in
                    news.append(item)
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main, execute: {
            finished(news)
        })
    }
    
}


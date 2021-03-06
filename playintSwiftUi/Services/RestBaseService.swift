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
    var by: String?
    var descendants, id: Int?
    var kids: [Int]?
    var score, time: Int?
    var title, type: String?
    var url: String?
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
        // https://hacker-news.firebaseio.com/v0/item/8863.json
        super.get(endpoint: "/item/\(id).json") { (news: HackerNews) in
            onLoaded(news)
        }
    }
}




class HackerNewsService {
    let newsCollection: NewsCollection
    
    
    init() {
        newsCollection = NewsCollection(endpoint: "/topstories.json")
    }
    
    func getNews( _ finished: @escaping ([HackerNews])->Void){
        var news = [HackerNews]()
        let group = DispatchGroup()
        group.enter()
        newsCollection.getTopStoryIds { (ids) in
            for id in ids {
                group.enter()
                self.newsCollection.getStory(id: id) { (item) in
                    news.append(item)
                    group.leave()
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main, execute: {
            finished(news)
        })
    }
    
}


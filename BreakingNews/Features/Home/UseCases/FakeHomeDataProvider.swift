//
//  FakeHomeDataProvider.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 26/12/2021.
//

import Foundation

struct FakeHomeDataSource: HomeDataProviderUseCase {
    var shouldReturnError: Bool
    var error: Error?
    
    let mockJSONResponse: [String:Any] = [
        "status": "ok",
        "totalResults": 70,
        "articles" :[
            [
                "source": [
                    "id": "afaf",
                    "name": "9to5google.com"
                ],
                "author": "fefe",
                "title": "These are the first things you should do on Pixel, Samsung Galaxy, and other new Android phones - 9to5Google",
                "description": "When you get a new phone, there are a few things that you may not realize you should do. Here's what you should do to set up a new Android device.",
                "url": "https://9to5google.com/2021/12/25/these-are-the-first-things-you-should-do-on-pixel-samsung-galaxy-and-other-new-android-phones/",
                "urlToImage": "https://i2.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/10/pixel_6_pro_retail_box_1.jpg?resize=1200%2C628&quality=82&strip=all&ssl=1",
                "publishedAt": "2021-12-25T20:00:00Z",
                "content": "Between getting a new phone, activating it, and making it yours, there are a few important steps. Follow along to get your Android phone’s email, messaging, and even homescreen set up.\r\nBefore we get… [+8265 chars]"
            ],
            [
                "source": [
                    "id": "afaf",
                    "name": "9to5google.com"
                ],
                "author": "fefaffe",
                "title": "These are the first things you should do on Pixel, Samsung Galaxy, and other new Android phones - 9to5Google",
                "description": "When you get a new phone, there are a few things that you may not realize you should do. Here's what you should do to set up a new Android device.",
                "url": "https://9to5google.com/2021/12/25/these-are-the-first-things-you-should-do-on-pixel-samsung-galaxy-and-other-new-android-phones/",
                "urlToImage": "https://i2.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/10/pixel_6_pro_retail_box_1.jpg?resize=1200%2C628&quality=82&strip=all&ssl=1",
                "publishedAt": "2021-12-25T20:00:00Z",
                "content": "Between getting a new phone, activating it, and making it yours, there are a few important steps. Follow along to get your Android phone’s email, messaging, and even homescreen set up.\r\nBefore we get… [+8265 chars]"
            ],
            [
                "source": [
                    "id": "afaf",
                    "name": "9to5google.com"
                ],
                "author": "fefe",
                "title": "These are the first things you should do on Pixel, Samsung Galaxy, and other new Android phones - 9to5Google",
                "description": "When you get a new phone, there are a few things that you may not realize you should do. Here's what you should do to set up a new Android device.",
                "url": "https://9to5google.com/2021/12/25/these-are-the-first-things-you-should-do-on-pixel-samsung-galaxy-and-other-new-android-phones/",
                "urlToImage": "https://i2.wp.com/9to5google.com/wp-content/uploads/sites/4/2021/10/pixel_6_pro_retail_box_1.jpg?resize=1200%2C628&quality=82&strip=all&ssl=1",
                "publishedAt": "2021-12-25T20:00:00Z",
                "content": "Between getting a new phone, activating it, and making it yours, there are a few important steps. Follow along to get your Android phone’s email, messaging, and even homescreen set up.\r\nBefore we get… [+8265 chars]"
            ]
        ]
    ]
    
    
    func loadData(requestParameters: HeadlineArticleParameters, completion: ArticleBlock?) {
        if shouldReturnError {
            completion?(.failure(error!))
            return
        }
        
        let data = try! JSONSerialization.data(withJSONObject: mockJSONResponse, options: .prettyPrinted)
        let decodedObject = try! JSONDecoder().decode(ArticleResponse.self, from: data)
        completion?(.success(decodedObject))
    }
}


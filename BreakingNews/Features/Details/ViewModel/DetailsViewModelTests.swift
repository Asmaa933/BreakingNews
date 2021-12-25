//
//  DetailsViewModelTests.swift
//  BreakingNewsTests
//
//  Created by Asmaa Tarek on 26/12/2021.
//

import XCTest
@testable import BreakingNews

class FakeArticle {
    let source = Source(id: "123", name: "Kotaku")
    lazy var article = Article(source: self.source,
                          author: "Ethan Gach",
                          title: "aqqqqq",
                          articleDescription: "feguiee",
                          url: "https://kotaku.com/11-things-every-new-nintendo-switch-owner-should-try-or-1848266762",
                          urlToImage: "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/ca7e86daa4e595e4007cee02dac5b46f.jpg",
                          publishedAt: "2021-12-25T17:00:00Z",
                          content: "afefe")
    
    lazy var articleWithInvalidURL = Article(source: self.source,
                                             author: "Ethan Gach",
                                             title: "aqqqqq",
                                             articleDescription: "feguiee",
                                             url: "ssss",
                                             urlToImage: "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/ca7e86daa4e595e4007cee02dac5b46f.jpg",
                                             publishedAt: "2021-12-25T17:00:00Z",
                                             content: "afefe")
    
    lazy var articleWithArabicWords = Article(source: self.source,
                                             author: "Ethan Gach",
                                             title: "aqqqqq",
                                             articleDescription: "feguiee",
                                             url: "https://www.elkhabar.com/press/article/200636/إطلاق-مناقصة-لإنجاز-مشروع-سولار-1000-ميغاواط/",
                                             urlToImage: "https://i.kinja-img.com/gawker-media/image/upload/c_fill,f_auto,fl_progressive,g_center,h_675,pg_1,q_80,w_1200/ca7e86daa4e595e4007cee02dac5b46f.jpg",
                                             publishedAt: "2021-12-25T17:00:00Z",
                                             content: "afefe")
}

class DetailsViewModelTests: XCTestCase {

    func testArticleDetails() {
        let sut = DetailsViewModel(article: FakeArticle().article)
        XCTAssertEqual(sut.article.author, "Ethan Gach")
        XCTAssertEqual(sut.article.title, "aqqqqq")
        XCTAssertEqual(sut.article.articleDescription, "feguiee")
    }
    
    func testSuccessOpenSafari() {
        let sut = DetailsViewModel(article: FakeArticle().article)
        let fakeView = FakeDetailsViewController()
        sut.statePresenter = fakeView
        sut.openArticleInSafari()
        XCTAssertTrue(fakeView.openSafari)
    }
    
    func testFailOpenSafari() {
        let articleWithInvalidURL = FakeArticle().articleWithInvalidURL
        let sut = DetailsViewModel(article: articleWithInvalidURL)
        let fakeView = FakeDetailsViewController()
        sut.statePresenter = fakeView
        sut.openArticleInSafari()
        XCTAssertFalse(fakeView.openSafari)
        XCTAssertTrue(fakeView.errorMessage == ErrorHandler.invalidURL.message)
    }
    
    func testSuccessOpenSafariWhenArabicWordsInURL() {
        let articleWithArabicWords = FakeArticle().articleWithArabicWords
        let sut = DetailsViewModel(article: articleWithArabicWords)
        let fakeView = FakeDetailsViewController()
        sut.statePresenter = fakeView
        sut.openArticleInSafari()
        XCTAssertTrue(fakeView.openSafari)
        XCTAssertFalse(fakeView.errorMessage == ErrorHandler.invalidURL.message)
    }

}

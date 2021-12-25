//
//  ApiHandler.swift
//  BreakingNews
//
//  Created by Asmaa Tarek on 24/12/2021.
//

import Foundation
import Alamofire

typealias NetworkResponse<T> = (Result<T, Error>) -> Void

protocol ApiHandlerProtocol {
    func fetchData<T: Decodable>(request: Requestable, mappingClass: T.Type, completion: NetworkResponse<T>?)
}

class ApiHandler: ApiHandlerProtocol {
    
    static let shared = ApiHandler()
    
    private init() { }
    
    func fetchData<T: Decodable>(request: Requestable, mappingClass: T.Type, completion: NetworkResponse<T>?) {
        getRequestData(request: request).validate(statusCode: 200...300).responseJSON { [weak self] response in
            guard let self = self else { return }
            let response = self.handleResponse(response: response, mappingClass: T.self)
            switch response {
            case .success(let decodedObject):
                completion?(.success(decodedObject))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
}

private extension ApiHandler {

    func getRequestData(request: Requestable) -> DataRequest {
        let requestData = AF.request(request.baseURL + request.path,
                                     method: request.method,
                                     parameters: request.parameters,
                                     encoding: request.encoding,
                                     headers: request.headers)
    
        return requestData
    }

    func handleResponse<T: Decodable> (response: AFDataResponse<Any>, mappingClass: T.Type) -> Result<T, Error> {
        guard let jsonResponse = response.data else {
            return .failure(ErrorHandler.generalError)
        }
        switch response.result {
        case .success:
            do {
                let decodedObj = try JSONDecoder().decode(T.self, from: jsonResponse)
                return .success(decodedObj)
            } catch (let error) {
                debugPrint("Error in decoding ** \n \(error.localizedDescription)")
                return .failure(ErrorHandler.generalError)
            }

        case .failure(let error):
            debugPrint(error.localizedDescription)
            do {
                let errorModel = try JSONDecoder().decode(ErrorModel.self, from: jsonResponse)
                return .failure(ErrorHandler.custom(errorModel.message ?? ""))
            } catch {
                return .failure(error)
            }
        }
    }
}

//
//  DemoBackend.swift
//  eIAM
//
//  Created by Stefan Mitterrutzner on 02.06.22.
//  Copyright © 2022 Ubique Innovation AG. All rights reserved.
//

import UIKit

class DemoBackend: ObservableObject {
    static let instance = DemoBackend()
    private init() {
    }

    public weak var service: EIAMAuthorizationService?

    @Published public var showReLoginPopup = false

    public var reLoginPopUpCallback: ((Bool) -> Void)? {
        didSet {
            DispatchQueue.main.async {
                self.showReLoginPopup = self.reLoginPopUpCallback != nil
            }
        }
    }

    private let session = URLSession(configuration: .ephemeral)

    struct TestRequestResult {
        let statusCode: Int
        let message: String
    }

    enum TestRequestError: Error {
        case getTokenError(EIAMGetTokenError?)
        case decodingError
        case networkError(Error)

        var description: String {
            switch self {
                case let .getTokenError(error):
                    return "TestRequestError.getTokenError(\(error?.description ?? ""))"
                case .decodingError:
                    return "TestRequestError.decodingError"
                case let .networkError(error):
                    return "TestRequestError.networkError(\(error.localizedDescription)"
            }
        }
    }

    public typealias TestRequestCallback = (Result<TestRequestResult, TestRequestError>) -> Void
    func testRequest(forceFreshToken: Bool = false, retryCount: Int = 0, callback: @escaping TestRequestCallback) {
        guard retryCount < 3 else {
            callback(.failure(.getTokenError(nil)))
            return
        }
        service?.getToken { result in
            switch result {
                case .failure(.recoverableAuthError):
                    self.reLoginPopUpCallback = { [weak self] shouldReLogin in
                        guard let self = self else { return }
                        self.reLoginPopUpCallback = nil
                        DispatchQueue.main.async {
                            guard shouldReLogin else {
                                self.service?.logout()
                                return
                            }
                            guard let rootViewController = UIApplication.shared.windows.first?.rootViewController else {
                                return
                            }
                            self.service?.authenticate(viewController: rootViewController) { [weak self] _ in
                                guard let self = self else { return }
                                DispatchQueue.global().async {
                                    self.testRequest(callback: callback)
                                }
                            }
                        }
                    }
                case let .failure(error):
                    DispatchQueue.main.async { callback(.failure(.getTokenError(error))) }
                    return
                case let .success(token):
                    guard let accessToken = token.accessToken else {
                        DispatchQueue.main.async { callback(.failure(.getTokenError(nil))) }
                        return
                    }
                    var request = URLRequest(url: StagingEnvironment.current.testRequestUrl)
                    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                    let task = self.session.dataTask(with: request) { data, response, error in

                        if let error = error {
                            DispatchQueue.main.async { callback(.failure(.networkError(error))) }
                            return
                        }

                        guard let response = response as? HTTPURLResponse else {
                            DispatchQueue.main.async { callback(.failure(.decodingError)) }
                            return
                        }

                        if response.statusCode == 401 {
                            // "401 Unauthorized" generally indicates there is an issue with the authorization
                            // force a fresh token and retry request
                            self.testRequest(forceFreshToken: true, retryCount: retryCount + 1, callback: callback)
                            return
                        }

                        guard let data = data,
                              let dataString = String(data: data, encoding: .utf8) else {
                            DispatchQueue.main.async { callback(.failure(.decodingError)) }
                            return
                        }

                        let result = TestRequestResult(statusCode: response.statusCode, message: dataString)
                        DispatchQueue.main.async { callback(.success(result)) }
                    }

                    task.resume()
            }
        }
    }
}

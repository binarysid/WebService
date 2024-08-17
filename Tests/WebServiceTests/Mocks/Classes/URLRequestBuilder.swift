
import Foundation

public struct URLRequestBuilder {
    public init(){}
    public func createRequestWith(baseURL: String, 
                                  httpMethod: HTTPMethod? = .GET,
                                  params: [String: String]? = nil,
                                  headers: [String: String]? = nil,
                                  body:[String: Any]? = nil,
                                  bearerToken: String? = nil)
    -> URLRequest? {
        RequestBuilder()
            .addEndPoint(baseURL)
            .addHttpMethod(httpMethod)
            .addComponents()
            .addParam(params)
            .addHeader(headers)
            .addBody(body)
            .addBearerToken(bearerToken)
            .build()
    }
}

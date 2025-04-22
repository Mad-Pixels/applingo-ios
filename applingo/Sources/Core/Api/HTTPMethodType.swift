/// Enum representing HTTP method types used in network requests.
enum HTTPMethodType: String {
    /// HTTP GET method, used to retrieve data from a server.
    case get = "GET"
    
    /// HTTP POST method, used to send data to a server.
    case post = "POST"
    
    /// HTTP PATCH method, used for update data.
    case patch = "PATCH"
}

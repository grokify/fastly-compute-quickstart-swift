import Compute

struct Response: Codable {
    let foo: String
    let hello: String
    let ping: String
}

@main
struct ComputeApp {
    static func main() async throws {
        try await onIncomingRequest { req, res in
            let logger = try Logger(name: "QuickstartLog")
            switch (req.method, req.url.path) {
            case (.post, "/quickstart"):
                let content = Response(foo: "bar", hello: "world", ping: "pong")
                try logger.write("swift quickstart responded with 200")
                try await res.status(200).send(content)
            default:
                try logger.write("swift quickstart responded with 404")
                try await res.status(404).send()
            }
        }
    }
}

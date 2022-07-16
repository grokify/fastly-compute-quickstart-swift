import Compute

struct Response: Codable {
    let version: Int
    let message: String
}

@main
struct ComputeApp {
    static func main() async throws {
        try await onIncomingRequest { req, res in
            // let logger = try Logger(name: "QuickstartLog") // Logger is not yet supported.
            switch (req.method, req.url.path) {
            case (.get, "/"):
                try await res
                    .header("Content-Type", "text/html; charset=utf-8")
                    .status(200)
                    .send("<!DOCTYPE html><html><body><h1>Hello, Swift World!</h1></body></html>")
            case (.post, "/quickstart"):
                if let accept = req.headers.get("Accept") {
                    if accept.caseInsensitiveCompare("text/plain") == .orderedSame {
                        // try logger.write("swift quickstart responded with 200")
                        try await res.status(200).send("Hello, Swift World!")
                        return
                    }
                }
                let content = Response(version: 1, message: "Hello, Swift World!")
                // try logger.write("swift quickstart responded with 200")
                try await res.status(200).send(content)
            default:
                // try logger.write("swift quickstart responded with 404")
                try await res.status(404).send()
            }
        }
    }
}

# Fastly Compute@Edge Quickstart for Swift

This is an example Fastly Compute@Edge app using [Andrew Barba's Swift Compute Runtime SDK](https://github.com/AndrewBarba/swift-compute-runtime).

It's designed to demonistrate some simple functionality:

1. Routing
1. Accessing request object (method, url, headers)
1. Writing repsponse (JSON and text)
1. Setting response status (200 vs. 404)

```swift
import Compute

struct Response: Codable {
    let version: Int
    let message: String
}

@main
struct ComputeApp {
    static func main() async throws {
        try await onIncomingRequest { req, res in
            let logger = try Logger(name: "QuickstartLog")
            switch (req.method, req.url.path) {
            case (.post, "/quickstart"):
                if let accept = req.headers.get("Accept") {
                    if accept.caseInsensitiveCompare("text/plain") == .orderedSame {
                        try logger.write("swift quickstart responded with 200")
                        try await res.status(200).send("Hello, Swift World!")
                        return
                    }
                }
                let content = Response(version: 1, message: "Hello, Swift World!")
                try logger.write("swift quickstart responded with 200")
                try await res.status(200).send(content)
            default:
                try logger.write("swift quickstart responded with 404")
                try await res.status(404).send()
            }
        }
    }
}
```

## Prerequisites

1. [SwiftWasm toolchain](https://book.swiftwasm.org/getting-started/setup.html)
1. [Fastly CLI](https://github.com/fastly/cli)

## Usage

``` bash
$ fastly compute init
$ /Library/Developer/Toolchains/swift-wasm-5.6.0-RELEASE.xctoolchain/usr/bin/swift build --triple wasm32-unknown-wasi --product FastlyComputeQuickstart -c release
$ fastly compute pack --wasm-binary=./.build/release/FastlyComputeQuickstart.wasm
$ fastly compute deploy
```
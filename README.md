# Fastly Compute@Edge Quickstart for Swift

```swift
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
            let logger = try Logger().init(name: "quickstartLogger")
            switch (req.method, req.url.path) {
            case (.post, "/quickstart"):
                let content = Response(foo: "bar", hello: "world", ping: "pong")
                try await res.status(200).send(content)
                try logger.write("responded with 200")
            default:
                try await res.status(404).send()
                try logger.write("responded with 404")
            }
        }
    }
}
```

## Prerequisites

1. SwiftWasm toolchain
1. Fastly CLI

## Usage

``` bash
$ fastly compute init
$ /Library/Developer/Toolchains/swift-wasm-5.6.0-RELEASE.xctoolchain/usr/bin/swift build --triple wasm32-unknown-wasi --product FastlyComputeQuickstart -c release
$ fastly compute pack --wasm-binary=./.build/release/FastlyComputeQuickstart.wasm
$ fastly compute deploy
```
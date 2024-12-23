// swift-tools-version: 5.9
import PackageDescription

#if TUIST
    import ProjectDescription

    let packageSettings = PackageSettings(
        // Customize the product types for specific package product
        // Default is .staticFramework
        // productTypes: ["Alamofire": .framework,] 
        productTypes: [:]
    )
#endif

let package = Package(
    name: "VoiceDiaryApp",
    dependencies: [
        .package(url: "https://github.com/SnapKit/SnapKit", from: "5.7.1"),
        .package(url: "https://github.com/google/generative-ai-swift", from: "0.5.6"),
        .package(url: "https://github.com/realm/realm-swift", from: "10.54.2")
        // Add your own dependencies here:
        // .package(url: "https://github.com/Alamofire/Alamofire", from: "5.0.0"),
        // You can read more about dependencies here: https://docs.tuist.io/documentation/tuist/dependencies
    ],
    targets: [
        .target(
            name: "VoiceDiaryApp",
            dependencies: [
                "SnapKit",
                "GoogleGenerativeAI",
                "Realm",
                "RealmSwift"
            ]
        )
    ]
)

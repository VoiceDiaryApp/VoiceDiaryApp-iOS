import ProjectDescription

let project = Project(
    name: "VoiceDiaryApp",
    targets: [
        .target(
            name: "VoiceDiaryApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.FairytaleHero.VoiceDiaryApp",
            deploymentTargets: .iOS("15.0"),
            infoPlist: .extendingDefault(
                with: [
                    "CFBundleDisplayName": "똑깨비",
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "NSMicrophoneUsageDescription": "음성 일기 작성을 위해 마이크 접근이 필요합니다.",
                    "NSPhotoLibraryAddUsageDescription": "사진을 저장하기 위해 앨범 접근 권한이 필요합니다.",
                    "NSPhotoLibraryUsageDescription": "앱에서 사진을 저장하기 위해 사진 접근 권한이 필요합니다.",
                    "NSSpeechRecognitionUsageDescription": "음성 명령 입력을 위해 음성 인식 권한이 필요합니다.",
                    "API_KEY": "$(API_KEY)",
                    "UIAppFonts": [
                        "NotoSans-Bold.ttf",
                        "Pretendard-Black.ttf",
                        "Pretendard-Bold.ttf",
                        "Pretendard-ExtraBold.ttf",
                        "Pretendard-ExtraLight.ttf",
                        "Pretendard-Light.ttf",
                        "Pretendard-Medium.ttf",
                        "Pretendard-Regular.ttf",
                        "Pretendard-SemiBold.ttf",
                        "Pretendard-Thin.ttf",
                        "Roboto-Black.ttf",
                        "Roboto-Bold.ttf",
                        "Roboto-Regular.ttf",
                        "나눔손글씨 또박또박.ttf",
                        "밑미.ttf"
                    ],
                    "UIUserInterfaceStyle": "Light",
                    "UISupportedInterfaceOrientations": [
                        "UIInterfaceOrientationPortrait"
                    ],
                    "GenerativeAIConfig": [
                        "ModelVersion": "1.5",
                        "EnableDebugMode": true,
                        "DefaultLanguage": "ko"
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "SnapKit"),
                .external(name: "GoogleGenerativeAI"),
                .external(name: "Realm"),
                .external(name: "RealmSwift")
            ],
            settings: .settings(
                base: [
                    "API_KEY": "$(API_KEY)"
                ],
                configurations: [
                    .debug(name: "Debug", xcconfig: "Configs/GenerativeAI.xcconfig"),
                    .release(name: "Release", xcconfig: "Configs/GenerativeAI.xcconfig")
                ]
            )
        )
    ]
)

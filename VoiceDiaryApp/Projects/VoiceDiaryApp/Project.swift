import ProjectDescription

let project = Project(
    name: "VoiceDiaryApp",
    targets: [
        .target(
            name: "VoiceDiaryApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.FairytaleHero.VoiceDiaryApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "NSMicrophoneUsageDescription": "음성 일기 작성을 위해 마이크 접근이 필요합니다.",
                    "NSPhotoLibraryAddUsageDescription": "사진을 저장하기 위해 앨범 접근 권한이 필요합니다.",
                    "NSSpeechRecognitionUsageDescription": "음성 명령 입력을 위해 음성 인식 권한이 필요합니다.",
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
                        "Roboto-Regular.ttf"
                    ]
                ]
            ),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .external(name: "SnapKit")
            ]
        )
    ]
)

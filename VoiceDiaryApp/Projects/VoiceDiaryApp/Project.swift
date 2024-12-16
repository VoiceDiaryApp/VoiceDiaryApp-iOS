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
                        "Pretendard-Medium.otf",
                        "Pretendard-SemiBold.otf",
                        "Pretendard-Bold.otf"
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

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
                .external(name: "SnapKit"),
                .external(name: "FSCalendar")
            ]
        )
    ]
)

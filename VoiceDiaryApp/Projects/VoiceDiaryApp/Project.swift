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
                        "Fonts/NotoSans-Bold.ttf",
                        "Fonts/Pretendard-Black.ttf",
                        "Fonts/Pretendard-Bold.ttf",
                        "Fonts/Pretendard-ExtraBold.ttf",
                        "Fonts/Pretendard-ExtraLight.ttf",
                        "Fonts/Pretendard-Light.ttf",
                        "Fonts/Pretendard-Medium.ttf",
                        "Fonts/Pretendard-Regular.ttf",
                        "Fonts/Pretendard-SemiBold.ttf",
                        "Fonts/Pretendard-Thin.ttf",
                        "Fonts/Roboto-Black.ttf",
                        "Fonts/Roboto-Bold.ttf",
                        "Fonts/Roboto-Regular.ttf"
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

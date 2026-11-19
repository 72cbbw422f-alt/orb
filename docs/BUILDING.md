# Building ORBIT

## Requirements
- macOS with Xcode installed.
- XcodeGen.
- An iOS Simulator runtime installed in Xcode.

## Generate the Xcode project
From the repository root:

```sh
brew install xcodegen
xcodegen generate
open ORBIT.xcodeproj
```

The generated `ORBIT.xcodeproj` is a build artifact and is intentionally not committed. The source of truth is `project.yml`.

## Build for iOS Simulator
```sh
xcodebuild \
  -project ORBIT.xcodeproj \
  -scheme ORBIT \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

## Run tests
```sh
xcodebuild \
  -project ORBIT.xcodeproj \
  -scheme ORBIT \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO \
  test
```

## GitHub Actions
The workflow at `.github/workflows/ios-ci.yml`:

1. Generates the Xcode project.
2. Builds the iOS Simulator target.
3. Runs unit tests.
4. Archives the iOS device app without a signing identity.
5. Packages the app as `ORBIT-unsigned.ipa` and uploads it as the `ORBIT-unsigned-IPA` workflow artifact.

To retrieve the IPA:

1. Open the repository's **Actions** tab.
2. Open the latest successful **iOS CI** run.
3. Download the **ORBIT-unsigned-IPA** artifact.
4. Extract the ZIP to get `ORBIT-unsigned.ipa`.
5. Import that IPA into FlareStore and sign/install it using your usual workflow.

The artifact is intentionally unsigned. It is not installable until FlareStore signs it with a certificate/profile accepted by your device. GitHub Actions success must include both the build/test job and the IPA packaging job before the artifact is considered ready.

## Signing and secrets
Do not commit signing certificates, private keys, provisioning profiles, OAuth secrets, or account tokens to the repository. If signing is later automated, use protected GitHub Actions secrets and a separately reviewed signing workflow.

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

## Build from the command line
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
Choose an installed simulator in Xcode, or use a destination such as:

```sh
xcodebuild \
  -project ORBIT.xcodeproj \
  -scheme ORBIT \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  CODE_SIGNING_ALLOWED=NO \
  test
```

## GitHub Actions
The workflow at `.github/workflows/ios-ci.yml` generates the project, builds for the iOS Simulator, and runs unit tests on a macOS runner.

## Device installation
Simulator build success does not produce an installable device IPA. A device build requires a valid Apple signing certificate and provisioning profile. Keep signing material out of the repository and store CI secrets only in protected GitHub Actions secrets.

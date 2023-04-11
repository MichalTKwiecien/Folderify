# Folderify application

## Demo
![](readme-assets/folderify.mov)

## How to Run the Project

### Prerequisites:
- Xcode 14.3

### Setup:
1. Open `Folderify`
2. Hit `Run`
3. Login using credentials given to you

## Description
The app allows to browse hierarchy of folders and perform basic operations:
* logging in
* create folder
* delete folder
* upload file
* preview file

### Goals
#### Code quality
Due to time limitation, it's not perfect but I feel it's good enough. There are still places where I could 
write more generic reusable components.

#### Modularisation
Both login screen and folder browser are in separate packages. There are some other packages as well:
* Prelude - contains usefull extensions shared between all other modules
* Architecture - allows to write clean and testable code using MVVM-C architecture and utilisng SwiftUI, 
makes Unit and Snapshot tests very easy to achieve plus allows very powerfull SwiftUI previews.
* World - module that's the heart of this app, the idea was taken from Point Free series - it allows very easy
mocking during development and allows writing UI tests that do not use network
* Networking - small network layer using Async Await
* DesignSystem - reusable components for SwiftUI

#### Testability
Code is fully testable but due to time limtations I wasn't able to add tests. Architectures allows usto easily add:
* Unit tests
* Snapshot tests
* UI tests

### Next steps
Here's the list of next steps I would take if time would not be an issue:
1. Add session persistance
2. Add CI/CD using fastlane
3. Add project generation using XcodeGen
4. Add localizable + assets generation using SwiftGen
5. Add Snapshot tests using Point Free snapshot testing library
6. Add unit tests
7. Add more reusable components to the DesignSystem and reduce code repetitions
8. Add UI tests

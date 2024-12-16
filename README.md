# Olympus Gold

**Olympus Gold** is a mobile game developed using **SwiftUI** with integrated **Google Mobile Ads** for monetization. The app consists of a main game section and a mini-game called **SpinWheel** (Wheel of Fortune). It features a modern, dynamic user interface and ad integration to generate revenue.

<p align="center">
<a href="https://github.com/mustafos/GateOfOlympus" target="_blank"><img src="https://github.com/mustafos/mustafos/blob/master/assets/olympus.png" title="Olympus Gold"></a>
</p>

## Features

- **Game Section**: A fun and interactive gameplay experience with various levels, objectives, and mechanics such as character control, object collection, and task completion.
- **SpinWheel Mini-Game**: A Wheel of Fortune feature where users spin a wheel to randomly win prizes or bonuses.
- **Ad Monetization**: Integrated with **Google Mobile Ads** for displaying banner ads, interstitial ads, and video ads. Ads are shown strategically between levels or during waiting times, ensuring minimal disruption to gameplay.

## Technical Details

### 1. **Core Components**

#### 1.1 **Game Section**
- **SwiftUI**: The user interface is built using SwiftUI, allowing for easy adaptation to different iOS devices and ensuring a smooth user experience with animations and dynamic layout adjustments.
- **Gameplay Mechanics**: Features various levels, character controls, and object collection tasks. Each level has its own unique design and objectives.
- **Data Storage**: **UserDefaults** and **Core Data** are used to save the player's progress, achievements, and game settings locally.

#### 1.2 **SpinWheel (Wheel of Fortune)**
- **Graphics & Animations**: The SpinWheel is built using **SwiftUI** for smooth animations and interactive design. Users can spin the wheel to win random prizes or bonuses.
- **Interaction**: The wheel's spin is controlled via SwiftUI's gesture and button handling, making the experience intuitive and responsive.

#### 1.3 **Google Mobile Ads Integration**
- **Ad Formats**: **Google Mobile Ads SDK** is used to display banner ads, interstitial ads, and video ads within the app. Ads are strategically shown without disrupting gameplay.
- **Event Handling**: The app includes logic for showing and interacting with ads, such as skipping video ads after watching them.

### 2. **Architecture**
- **MVVM Pattern**: The app follows the **Model-View-ViewModel (MVVM)** architecture, ensuring a clean separation of concerns between the game logic, data management, and user interface. This pattern simplifies testing and maintains the flexibility of the app.
- **SwiftUI Animations**: SwiftUI's animation system is extensively used to create smooth transitions and engaging user interactions.

### 3. **Technical Features**
- **SwiftUI**: The app leverages **SwiftUI** for building a responsive and dynamic user interface. It integrates smoothly with UIKit for advanced UI components and animations.
- **Google Mobile Ads SDK**: Integrated via **CocoaPods**, enabling easy installation and management of ad services.
- **Core Data & UserDefaults**: Used for managing local data, such as player progress, settings, and achievements.

### 4. **Key Features**
- **iOS Device Support**: The app supports iPhones and iPads, adapting its UI to various screen sizes and resolutions.
- **Multilingual Support**: The app is available in multiple languages to reach a global audience.
- **Smooth Animations**: The app features smooth and interactive animations, built using **SwiftUI** for a high-quality visual experience.

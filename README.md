# Sorting Visualizer

A beautiful and interactive visualization tool for common sorting algorithms built with SwiftUI. Watch how different sorting algorithms work in real-time with customizable animations and settings.

![Sorting Visualizer Demo](demo.gif)

## Features

- **Multiple Sorting Algorithms:**
  - Bubble Sort
  - Selection Sort
  - Insertion Sort
  - Merge Sort
  - Quick Sort

- **Interactive Visualization:**
  - Real-time visualization of sorting process
  - Color-coded elements to track comparisons
  - Adjustable animation speed
  - Show/hide element values
  - Performance timer

- **Cross-Platform Support:**
  - iOS
  - iPadOS
  - macOS
  - visionOS

## Requirements

- iOS 18.0+
- macOS 15.0+
- visionOS 2.0+
- Xcode 16+
- Swift 6.0+

## Installation

1. Clone the repository:
```bash
git clone https://github.com/pitt500/SortingApp.git
```

2. Open `SortingApp.xcodeproj` in Xcode

3. Build and run the project

## Usage

1. Select a sorting algorithm from the top menu
2. Click "Sort" to start the visualization
3. Use "Reset" to generate a new random array
4. Click "Cancel" to stop the current sorting process

### Settings

You can customize the visualization through the settings:

- **Enable/Disable Animations:** Toggle sorting animations
- **Show/Hide Bar Values:** Display numerical values above each bar
- **Animation Speed:** Adjust the speed of the sorting animation
- **Show/Hide Timer:** Display sorting duration

## Architecture

The project follows a clean SwiftUI architecture:

- **SortingAlgorithm:** Core logic for sorting implementations
- **SortingView:** Main view controller and UI
- **SortingChartView:** Custom visualization using SwiftUI Charts
- **Settings:** User preferences and configuration

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Author

Pedro Rojas (Pitt) - [@swiftandtips](https://twitter.com/swiftandtips)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

- SwiftUI Charts for the visualization components
- Apple's Swift and SwiftUI frameworks
- The Swift community for continuous inspiration

## Screenshots

TBD

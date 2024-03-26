# Mocking Star 🌟

Mocking Star is a powerful request mocking tool designed to simplify the process of http request mocking, network debugging, and using UI tests for your mobile applications. <br>
With just a single line of code, you can use Mocking Star in your project.

![](https://github.com/Trendyol/mockingstar-ios/blob/main/MockingStarExample/MockingStarDemo.gif)

### Key Features

- **Mocking Requests**: Easily mock requests and test different cases with scenarios.
- **Modifying Requests**: Modify intercepted requests to test different edge cases, allowing you to assess your application's performance under different conditions.
- **Debugging Support**: Use Mocking Star to debug your network requests on your mac.
- **UI Testing**: Integrate Mocking Star into your UI tests, creating a reliable and controlled testing environment to validate your mobile application's functionality.

Mocking Star App -> [Mocking Star](https://github.com/Trendyol/mockingstar) <br>
Android Library -> [Mocking Star Android Library](https://github.com/Trendyol/mockingstar-android)

## Getting Started 🔥
To begin using Mocking Star in your Swift application, simply add the following line of code:

```swift
MockingStar.shared.inject()

```
This line initializes Mocking Star and prepares it to intercept and process your requests.

## How It Works 🚀
Mocking Star operates seamlessly through the use of URLProtocol to intercept incoming requests. Here's a step-by-step how it works:

1. **Injection**: With `MockingStar.shared.inject()`, Mocking Star is injected into your application, ready to work its magic.
2. **Request Intercept**: Using the power of URLProtocol, Mocking Star intercepts incoming requests before they leave your application and without change your production code.
3. **Communication with Mocking Star App**: Intercepted requests are communicated to the Mocking Star macOS application.
4. **Processing and Results**: Mocking Star app processes intercepted requests, allowing you to mock, modify, or debug them as needed. The result is then sent back to your application.

## Usage Tips ❇️
- **Mocking Requests**: With Mocking Star, mock requests and simulate different scenarios.
- **Modifying Requests**: Modify intercepted requests to test different edge cases.
- **Debugging Support**: Use Mocking Star to debug your network requests on your mac.
- **UI Testing**: Integrate Mocking Star into your UI tests for reliable and controlled testing environments.
- **Custom URLSessionConfiguration**: `MockingStar.sharedinject(configuration: URLSessionConfiguration)`

## Installation 
**For Xcode project**

You can add [mockingstar-ios](https://github.com/Trendyol/mockingstar-ios) to your project as a package.

> `https://github.com/Trendyol/mockingstar-ios`

**For Swift Package Manager**

In `Package.swift` add:

``` swift
dependencies: [
    .package(url: "https://github.com/Trendyol/mockingstar-ios", from: "1.0.0"),
]
```

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.

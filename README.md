# DIContainer

[![CI](https://github.com/JunkyTang/DIContainer/actions/workflows/ci.yml/badge.svg)](https://github.com/JunkyTang/DIContainer/actions)  [![CD](https://github.com/JunkyTang/DIContainer/actions/workflows/cd.yml/badge.svg)](https://github.com/JunkyTang/DIContainer/actions)  [![License](https://img.shields.io/github/license/JunkyTang/DIContainer)](https://github.com/JunkyTang/DIContainer/blob/main/LICENSE)  [![Release](https://img.shields.io/github/v/release/JunkyTang/DIContainer)](https://github.com/JunkyTang/DIContainer/releases)

---

A lightweight and type-safe Dependency Injection Container for Swift projects.
Designed for modular architecture, Swift Concurrency compatibility, and easy unit testing.

---

## ✨ Features

- Protocol-based module registration and resolution
- Thread-safe with `@Sendable` compliance
- `async/await` friendly
- Prevents duplicate registration
- Simple API design, lightweight core
- Fully covered by unit tests
- Works perfectly with Swift 6 and iOS 16+

---

## 📦 Installation

### CocoaPods

```ruby
pod 'DIContainer'
```

(Or include manually if it's a standalone module.)

---

## 🚀 Quick Start

### 1. Register modules

```swift
let container = DIContainer()

try container.register(interface: StoreService.self, impl: StoreServiceImpl())
```

### 2. Resolve modules

```swift
let storeService = container.resolve(StoreService.self)
```

---

## 🧹 Example Usage

```swift
protocol StoreService {
    func storeDetailPage() throws -> UIViewController
}

final class StoreServiceImpl: StoreService {
    func storeDetailPage() throws -> UIViewController {
        return StoreDetailViewController()
    }
}

let container = DIContainer()
try container.register(interface: StoreService.self, impl: StoreServiceImpl())

// Later usage
let service = container.resolve(StoreService.self)
let detailVC = try service.storeDetailPage()
```

---

## 🛡️ Thread Safety

DIContainer is designed to be safe for concurrency.

- It uses Swift 6's `Sendable` concept internally.
- If needed, you can also wrap `DIContainer` itself with `@MainActor` or `@globalActor` for more strict serial access.

---

## 🧪 Unit Test

We provide complete unit tests to ensure:

- Correct instance resolution
- Duplicate registration detection
- Thread-safety under concurrent access

Run:

```bash
xcodebuild test -scheme DIContainer_Tests -destination 'platform=iOS Simulator,name=iPhone 14'
```

---

## 📋 License

MIT License. See [LICENSE](./LICENSE) for more information.

---

## 🙌 Contributing

Welcome PRs and issues!  
If you find a bug or want a feature, feel free to open an issue or pull request!

---

## ✨ About

DIContainer is designed and maintained by [JunkyTang](https://github.com/JunkyTang).  
Inspired by simplicity, reliability, and Swift Concurrency.
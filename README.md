# Fractals App

A simple Flutter application that draws a fractal tree using isolates. Its sole purpose is to test my understanding of isolates, threading, and concurrency in Flutter.

--

## 🚀 Features

- ✅ Change the angle and depth of fractal tree
- ✅ Understanding of how the fractal tree is drawn
- ✅ Smooth experience
- ✅ Heavy computations done in a separate isolate

--

## 🛠️ Technologies used

- **Dart**
- **Flutter**

--

## 📂 Project Structure

<pre>
    lib/
    ├── models/
    │ └── line.dart
    ├── services/
    │ └── fractal_isolate.dart
    ├── ui/
    │ └── pages/ 
    │   └── homepage.dart
    │ └── painters/
    │   └── painter.dart
    ├── utils/
    │ └── fractal_tree.dart
    └── main.dart
</pre>

--

## ⚙️ How It Works

- A user slides the angle and depth sliders to achieve the desired angle and depth
- An isolate calculates the required calculations on a separate thread
- Flutter renders the fractal tree smoothly using CustomPainter
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() {
                  isLastPage = index == 2; // Last page index
                });
              },
              children: [
                OnboardingPage(
                  image: "assets/laundry1.png",
                  title: "Fast & Reliable Laundry Service",
                  description: "Get your clothes washed and delivered quickly.",
                ),
                OnboardingPage(
                  image: "assets/laundry2.png",
                  title: "Track Your Orders",
                  description: "Monitor your laundry progress in real-time.",
                ),
                OnboardingPage(
                  image: "assets/laundry3.png",
                  title: "Secure Payments",
                  description: "Make hassle-free payments using Paystack.",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: WormEffect(activeDotColor: Colors.green),
                ),
                SizedBox(height: 20),
                isLastPage
                    ? ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  },
                  child: Text("Get Started"),
                )
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => _controller.jumpToPage(2),
                      child: Text("Skip"),
                    ),
                    ElevatedButton(
                      onPressed: () => _controller.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      ),
                      child: Text("Next"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  OnboardingPage({required this.image, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 250), // Ensure images are in assets folder
          SizedBox(height: 20),
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Text(description, textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

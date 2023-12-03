import 'package:flutter/material.dart';

enum Type { FIRST, OTHER }

class OnboardPage extends StatelessWidget {
  final Type? type;
  final String imgPath;
  final String title;
  final String subtitle;
  const OnboardPage(
      {super.key,
      this.type = Type.OTHER,
      required this.imgPath,
      required this.title,
      required this.subtitle});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case Type.FIRST:
        return _buildFirstPage();
      default:
        return _buildPage();
    }
  }

  Widget _buildFirstPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100, left: 8, right: 8, bottom: 8),
        child: Container(
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  imgPath,
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    subtitle,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPage() {
    return Padding(
      padding: const EdgeInsets.only(top: 40, left: 8, right: 8, bottom: 8),
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  subtitle,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Image.asset(
                imgPath,
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

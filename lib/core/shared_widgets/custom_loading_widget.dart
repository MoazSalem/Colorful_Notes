import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: SizedBox(
          width: 200,
          height: 200,
          child: Lottie.asset('assets/animations/loading.json'),
        ),
      ),
    );
  }
}

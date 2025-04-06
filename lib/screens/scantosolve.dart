import 'package:flutter/material.dart';

class ScanToSolveScreen extends StatelessWidget {
  const ScanToSolveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Center(
        child: Column(
          
          children: [Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.camera_alt, size: 100, color: Colors.white70),
              const SizedBox(height: 20),
              const Text(
                'In Work',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 202, 122, 122),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back'),
              )
            ],
          ),
        ]),
      ),
    );
  }
}

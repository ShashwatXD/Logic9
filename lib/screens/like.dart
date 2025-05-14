import 'package:flutter/material.dart';

class LikeFeature extends StatefulWidget {
  @override
  _LikeFeatureState createState() => _LikeFeatureState();
}

class _LikeFeatureState extends State<LikeFeature> {
  bool isLiked = false;

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
     Scaffold(
       body: Center(
         child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
                  children: [
            LikeButton(isLiked: isLiked, onTap: toggleLike),
            LikeText(isLiked: isLiked),
          ],
             ),
       ),
     );
  }
}

class LikeButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onTap;

  LikeButton({required this.isLiked, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
      onPressed: onTap,
    );
  }
}

class LikeText extends StatelessWidget {
  final bool isLiked;

  LikeText({required this.isLiked});

  @override
  Widget build(BuildContext context) {
    return Text(isLiked ? "You liked this!" : "Tap to like");
  }
}

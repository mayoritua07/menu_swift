import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    const shimmerGradient = LinearGradient(
      colors: [
        Color.fromARGB(255, 235, 235, 244),
        Color.fromARGB(255, 244, 244, 244),
        Color.fromARGB(255, 235, 235, 244)
      ],
      stops: [0.1, 0.3, 0.4],
      begin: Alignment(-1.0, -0.3),
      end: Alignment(1.0, 0.3),
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return shimmerGradient.createShader(bounds);
      },
      child: widget.child,
    );
  }
}

class ShimmerImage extends StatelessWidget {
  const ShimmerImage(this.url, {super.key, this.fit, this.width, this.height});

  final String url;
  final BoxFit? fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      width: width,
      height: height,
      url,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }

        return ShimmerLoading(child: child);
      },
      fit: fit,
    );
  }
}

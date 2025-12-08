import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SongDetailPage extends StatelessWidget {
  final String mdPath;

  const SongDetailPage({super.key, required this.mdPath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(mdPath),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Markdown(
          data: snapshot.data!,
          imageBuilder: (uri, title, alt) {
            return Image.asset(
              'assets/images/${uri.path}',   // otomatis load gambar
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) =>
                  const Text("Gambar tidak ditemukan"),
            );
          },
        );
      },
    );
  }
}

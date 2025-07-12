import 'package:flutter/material.dart';
import '/screens/home_page.dart';
import 'package:video_player/video_player.dart';

class FontRaisePage extends StatefulWidget {
  final String title;

  const FontRaisePage({required this.title, Key? key}) : super(key: key);

  @override
  State<FontRaisePage> createState() => _BicepCurlPageState();
}

class _BicepCurlPageState extends State<FontRaisePage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
      'https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4', // Replace with actual video URL
    )
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.emoji_events_outlined, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Text(
                "mHealth",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.deepPurple),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 12),

                // Video Player
                _controller.value.isInitialized
                    ? AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
                    : Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.deepPurple,
                      size: 40,
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),
                const Text("Exercise Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 8),
                const Text("** Caution: Lorem Ipsum", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                const Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      "Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                ),
                const SizedBox(height: 16),
                const Text("You will need:", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text("• Dumbbells\n• Yoga mat"),
                const SizedBox(height: 16),
                const Text("Steps:", style: TextStyle(fontWeight: FontWeight.bold)),
                const Text(
                  "1. Lorem ipsum dolor sit amet, consectetur.\n"
                      "2. Adipiscing elit.\n"
                      "3. Sed do eiusmod tempor incididunt ut labore.",
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
          } else if (index == 2) {
            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), label: 'Exercise'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Activity'),
        ],
      ),
    );
  }
}

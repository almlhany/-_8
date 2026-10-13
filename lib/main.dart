import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext c) => MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: TikHome());
}

// ===== ساعة =====
class LiveClock extends StatefulWidget {
  const LiveClock({super.key});
  @override State<LiveClock> createState() => _C();
}
class _C extends State<LiveClock> {
  late Timer t; DateTime n = DateTime.now();
  @override void initState() { super.initState(); t = Timer.periodic(Duration(seconds: 1), (_) => setState(() => n = DateTime.now())); }
  @override void dispose() { t.cancel(); super.dispose(); }
  @override Widget build(BuildContext c) { String p(int v) => v.toString().padLeft(2, '0'); return Text("${p(n.hour)}:${p(n.minute)}:${p(n.second)}", style: TextStyle(fontSize: 13, color: Colors.white)); }
}

// ===== بيانات =====
class Comment { String user, text; Comment(this.user, this.text); }
class Video {
  String id, user, desc, music, imageUrl; int likes, coms, shares, books; bool liked; List<Comment> comments;
  Video({required this.id, required this.user, required this.desc, required this.music, required this.imageUrl, required this.likes, required this.coms, required this.shares, required this.books, this.liked = false, List<Comment>? comments}) : comments = comments?? [];
}

class DB {
  static List<Video> vids = [
    // ===== هنا تحط الروابط - غير اللي داخل imageUrl فقط =====
    Video(
      id: "1",
      user: "sarah",
      desc: "يومياتي كمصممة ✨ #fyp",
      music: "الصوت الاصلي",
      // ↓↓↓ الرابط الاول حطه هنا ↓↓↓
      imageUrl: "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=800",
      likes: 45200, coms: 320, shares: 1200, books: 800,
    ),
    Video(
      id: "2",
      user: "goals_sa",
      desc: "هدف اليوم خرافي ⚽️🔥",
      music: "تعليق المباراة",
      // ↓↓↓ الرابط الثاني حطه هنا ↓↓↓
      imageUrl: "https://images.unsplash.com/photo-1579952363873-27d3bfad9c0d?w=800",
      likes: 120000, coms: 4500, shares: 8000, books: 2000,
    ),
    Video(
      id: "3",
      user: "tech.riyadh",
      desc: "كيف تسوي تطبيق في Klencod",
      music: "شرح تقني",
      // ↓↓↓ الرابط الثالث حطه هنا ↓↓↓
      imageUrl: "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800",
      likes: 89100, coms: 900, shares: 5000, books: 3000,
    ),
  ];
}

class TikHome extends StatefulWidget { @override State<TikHome> createState() => _H(); }
class _H extends State<TikHome> {
  int topTab = 1;
  String searchQuery = "";
  List<Video> get filtered {
    if (searchQuery.isEmpty) return DB.vids;
    return DB.vids.where((v) => v.user.contains(searchQuery) || v.desc.contains(searchQuery)).toList();
  }

  void _showSearch() {
    showModalBottomSheet(context: context, backgroundColor: Color(0xFF121212), builder: (_) => Padding(padding: EdgeInsets.all(16), child: Column(mainAxisSize: MainAxisSize.min, children: [TextField(autofocus: true, onChanged: (q) => setState(() => searchQuery = q), decoration: InputDecoration(hintText: "بحث عن @sarah", prefixIcon: Icon(Icons.search), filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)))), SizedBox(height: 10), Text("النتائج: ${filtered.length}")])));
  }

  void _addVideo() {
    String d = ""; String url = "";
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Color(0xFF1E1E1E), builder: (_) => Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16), child: Column(mainAxisSize: MainAxisSize.min, children: [
      Text("اضافة فيديو", style: TextStyle(fontWeight: FontWeight.bold)), SizedBox(height: 10),
      TextField(maxLines: 2, onChanged: (v) => d = v, decoration: InputDecoration(hintText: "الوصف...", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
      SizedBox(height: 10),
      TextField(onChanged: (v) => url = v, decoration: InputDecoration(hintText: "الصق رابط صورة هنا (اختياري)", filled: true, fillColor: Colors.white10, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
      SizedBox(height: 10),
      FilledButton(onPressed: () { if (d.isNotEmpty) { setState(() => DB.vids.insert(0, Video(id: DateTime.now().millisecondsSinceEpoch.toString(), user: "انت", desc: d, music: "الصوت الاصلي", imageUrl: url.isEmpty? "https://picsum.photos/seed/${DateTime.now().millisecond}/800/1200" : url, likes: 0, coms: 0, shares: 0, books: 0))); Navigator.pop(context); } }, child: Text("نشر")), SizedBox(height: 20)
    ])));
  }

  @override Widget build(BuildContext c) => Scaffold(
    body: Stack(children: [
      PageView.builder(scrollDirection: Axis.vertical, itemCount: filtered.length, itemBuilder: (_, i) => VideoItem(video: filtered[i], refresh: () => setState(() {}))),
      SafeArea(child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: Row(children: [
        LiveClock(), Spacer(),
        GestureDetector(onTap: () => setState(() => topTab = 0), child: Text("متابعون", style: TextStyle(fontWeight: topTab == 0? FontWeight.w900 : FontWeight.w400, color: topTab == 0? Colors.white : Colors.white60))),
        SizedBox(width: 16),
        GestureDetector(onTap: () => setState(() => topTab = 1), child: Text("For You", style: TextStyle(fontWeight: topTab == 1? FontWeight.w900 : FontWeight.w400, color: topTab == 1? Colors.white : Colors.white60))),
        Spacer(), GestureDetector(onTap: _showSearch, child: Icon(Icons.search, size: 28)),
      ]))),
    ]),
    bottomNavigationBar: BottomNavigationBar(backgroundColor: Colors.black, selectedItemColor: Colors.white, unselectedItemColor: Colors.white54, type: BottomNavigationBarType.fixed, currentIndex: 0, onTap: (i) { if (i == 2) _addVideo(); }, items: [
      BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "الرئيسية"),
      BottomNavigationBarItem(icon: Icon(Icons.people), label: "اصدقاء"),
      BottomNavigationBarItem(icon: Container(padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)), child: Icon(Icons.add, color: Colors.black)), label: ""),
      BottomNavigationBarItem(icon: Icon(Icons.inbox), label: "صندوق"),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
    ]),
  );
}

class VideoItem extends StatelessWidget {
  final Video video; final VoidCallback refresh; const VideoItem({required this.video, required this.refresh});
  @override Widget build(BuildContext c) {
    return Stack(children: [
      Positioned.fill(child: Image.network(video.imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey[900], child: Center(child: Icon(Icons.broken_image, size: 50))))),
      Positioned.fill(child: Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black54])))),
      Positioned(left: 12, right: 80, bottom: 18, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("@${video.user}", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), SizedBox(height: 4), Text(video.desc, style: TextStyle(fontSize: 13)), SizedBox(height: 6), Row(children: [Icon(Icons.music_note, size: 13), SizedBox(width: 4), Text(video.music, style: TextStyle(fontSize: 11, color: Colors.white70))])])),
      Positioned(right: 8, bottom: 90, child: Column(children: [
        CircleAvatar(radius: 28, backgroundColor: Colors.white, child: Text(video.user[0].toUpperCase(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
        SizedBox(height: 18),
        GestureDetector(onTap: () { video.liked =!video.liked; video.likes += video.liked? 1 : -1; refresh(); }, child: Column(children: [Icon(video.liked? Icons.favorite : Icons.favorite_border, color: video.liked? Colors.red : Colors.white, size: 34), Text("${video.likes >= 1000? "${(video.likes / 1000).toStringAsFixed(1)}K" : video.likes}", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))])),
        SizedBox(height: 14),
        Column(children: [Icon(Icons.chat_bubble, size: 30), Text("${video.coms}", style: TextStyle(fontSize: 11))]),
        SizedBox(height: 14),
        Column(children: [Icon(Icons.bookmark_border, size: 30), Text("${video.books}", style: TextStyle(fontSize: 11))]),
        SizedBox(height: 14),
        Column(children: [Icon(Icons.share, size: 30), Text("${video.shares}", style: TextStyle(fontSize: 11))]),
      ])),
    ]);
  }
}
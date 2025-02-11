import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '/model/song.dart';
import '/colors.dart';
import '/screens/pages/add_music_page.dart';
import '/screens/pages/play_audio_page.dart';

class MusicTab extends StatefulWidget {
  const MusicTab({Key? key}) : super(key: key);

  @override
  State<MusicTab> createState() => _MusicTabState();
}

class _MusicTabState extends State<MusicTab> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
              child: Align(
                  alignment: Alignment.topCenter,
                  child: Text("Music Gallery", style: TextStyle(fontSize: 22, color: mainFontColor, fontWeight: FontWeight.bold,),)
              ),
            ),
            SingleChildScrollView(
              child: Container(
                margin: const EdgeInsets.all(10),
                height: MediaQuery.of(context).size.height * 0.6,
                child: StreamBuilder<List<SongData>>(
                  stream: getSongs(),
                  builder: (context, snapshot){
                    if (snapshot.hasError){
                      return Text('Something went wrong. ${snapshot.error}');
                    } else if (snapshot.hasData){
                      final songs = snapshot.data!;

                      return ListView(
                        padding: EdgeInsets.all(10),
                        children: songs.map(showSong).toList(),
                      );
                    }else {
                      return const Center(child: CircularProgressIndicator(),);
                    }
                  },
                ),
              ),
            )
            ],
          ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MusicAddPage()),
              );
            },
            label: const Text('Add Music'),
            icon: const Icon(Icons.add_circle_rounded),
            backgroundColor: darkOrangeColor,
          ),
        ),
      ]
    );
  }

  Widget showSong(SongData song) => Card(
    margin: const EdgeInsets.only(bottom: 12),
    color: mainBGColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: ListTile(
      textColor: mainFontColor,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(song.imageUrl),
      ),
      title: Text(song.name),
      subtitle: Text(song.artist),
      trailing: const Icon(Icons.play_circle, color: darkOrangeColor,),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayAudioPage(song : song),
          ),
        );
      },
    ),
  );

  Stream<List<SongData>> getSongs() =>
      FirebaseFirestore.instance
          .collection('songs')
          .snapshots()
          .map((snapshot) =>
          snapshot.docs.map((doc) =>
              SongData.fromJson(doc.data())).toList(),
      );


}

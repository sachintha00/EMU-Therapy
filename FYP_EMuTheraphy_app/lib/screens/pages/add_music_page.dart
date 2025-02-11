import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '/model/song.dart';
import '/colors.dart';

class MusicAddPage extends StatefulWidget {
  const MusicAddPage({super.key});

  @override
  State<MusicAddPage> createState() => _MusicAddPageState();
}

class _MusicAddPageState extends State<MusicAddPage> {

  PlatformFile? pickedImage;
  UploadTask? uploadTaskImage;
  String? imageUrlDB;

  Future uploadImage() async{

    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });

    final path = 'image/${pickedImage!.name!}';
    final file = File(pickedImage!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTaskImage = ref.putFile(file);

    final snapshot = await uploadTaskImage!.whenComplete(() {});

    imageUrlDB = await snapshot.ref.getDownloadURL();
    print("link $imageUrlDB");
  }

  PlatformFile? pickedAudio;
  UploadTask? uploadTaskAudio;
  String? audioUrlDB;

  Future uploadAudio() async{

    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedAudio = result.files.first;
    });

    final path = 'song/${pickedAudio!.name!}';
    final file = File(pickedAudio!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTaskAudio = ref.putFile(file);

    final snapshot = await uploadTaskAudio!.whenComplete(() {});

    audioUrlDB = await snapshot.ref.getDownloadURL();
    print("link $audioUrlDB");
  }


  final songTypeController = TextEditingController();
  final songNameController = TextEditingController();
  final songArtistController = TextEditingController();

  Future uploadSongData(SongData songData) async{
    final song = FirebaseFirestore.instance.collection('songs').doc();

    songData.id = song.id;

    final json = songData.toJson();
    await song.set(json);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondBGColor,
      appBar: AppBar(
        title: const Text("Upload Music"),
        backgroundColor: darkOrangeColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const Text(
                  'For what mood you recommend .?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                ),
                TextFormField(
                  controller: songTypeController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.emoji_emotions, color: mainFontColor,),
                    hintText: "Happy/ Sad/ Surprised",
                    hintStyle: TextStyle(
                      color: mainFontColor,
                      fontStyle: FontStyle.italic,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkOrangeColor),
                      ),
                    ),
                  ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  'Song Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                ),
                TextFormField(
                  controller: songNameController,
                  decoration: const InputDecoration(
                    //prefixIcon: Icon(Icons.emoji_emotions, color: mainFontColor,),
                    hintStyle: TextStyle(
                      color: mainFontColor,
                      fontStyle: FontStyle.italic,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkOrangeColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  'Artist Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                ),
                TextFormField(
                  controller: songArtistController,
                  decoration: const InputDecoration(
                    //prefixIcon: Icon(Icons.emoji_emotions, color: mainFontColor,),
                    hintStyle: TextStyle(
                      color: mainFontColor,
                      fontStyle: FontStyle.italic,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: darkOrangeColor),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                const Text(
                  'Upload Image',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: uploadImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBGColor, // background color
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_library, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Open Gallery',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 35,
                ),
                const Text(
                  'Upload Song',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: mainFontColor),
                ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: uploadAudio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBGColor, // background color
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.audio_file, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Open Audio Files',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkOrangeColor, // background color
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(MediaQuery.of(context).size.width * 0.9, MediaQuery.of(context).size.width * 0.15),
                  ),
                    onPressed: (){
                      final songData = SongData(
                          name: songNameController.text.trim(),
                          artist: songArtistController.text.trim(),
                          type: songTypeController.text.trim(),
                          imageUrl: imageUrlDB!,
                          audioUrl: audioUrlDB!,
                      );
                      uploadSongData(songData);
                    },
                    child: const Text("Upload to Gallery",
                        style: TextStyle(fontSize: 20, color: mainFontColor),
                    ),
                ),
              ),
              ],
          ),
        ),
      ),
    );
  }

}

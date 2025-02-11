class SongData {

  late String id;
  late final String name;
  late final String artist;
  late final String type;
  late final String imageUrl;
  late final String audioUrl;

  SongData({
    this.id = '',
    required this.name,
    required this.artist,
    required this.type,
    required this.imageUrl,
    required this.audioUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'artist': artist,
    'type': type,
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
  };

  static SongData fromJson(Map<String, dynamic> json) => SongData(
      name: json['name'],
      artist: json['artist'],
      type: json['type'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl']
  );

}
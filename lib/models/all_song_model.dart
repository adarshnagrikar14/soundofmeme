class Song {
  final int songId;
  final String userId;
  final String songName;
  final String songUrl;
  final int likes;
  final int views;
  final String imageUrl;
  final String lyrics;
  final List<String> tags;
  final String dateTime;

  Song({
    required this.songId,
    required this.userId,
    required this.songName,
    required this.songUrl,
    required this.likes,
    required this.views,
    required this.imageUrl,
    required this.lyrics,
    required this.tags,
    required this.dateTime,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      songId: json['song_id'],
      userId: json['user_id'],
      songName: json['song_name'],
      songUrl: json['song_url'],
      likes: json['likes'],
      views: json['views'],
      imageUrl: json['image_url'],
      lyrics: json['lyrics'],
      tags: List<String>.from(json['tags']),
      dateTime: json['date_time'],
    );
  }
}

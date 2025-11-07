import 'movie.dart';
import 'seat.dart';

class Showtime {
  final int showtimeId;
  final String startTime;
  final String endTime;
  final Movie? movie;
  final List<Seat>? seats;

  Showtime({
    required this.showtimeId,
    required this.startTime,
    required this.endTime,
    this.movie,
    this.seats,
  });

  factory Showtime.fromJson(Map<String, dynamic> json) {
    return Showtime(
      showtimeId: json['showtimeId'] ?? json['showtime_id'] ?? 0,
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      movie: json['movie'] != null ? Movie.fromJson(json['movie']) : null,
      seats: json['seats'] != null
          ? (json['seats'] as List)
          .map((seatJson) => Seat.fromJson(seatJson))
          .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'showtimeId': showtimeId,
      'startTime': startTime,
      'endTime': endTime,
      'movie': movie?.toJson(),
      'seats': seats?.map((seat) => seat.toJson()).toList(),
    };
  }
}

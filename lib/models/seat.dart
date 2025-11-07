import 'showtime.dart';
import 'movie.dart';

class Seat {
  final int seatId;
  final int seatNumber;
  final double price;
  final Showtime? showtime;

  Seat({
    required this.seatId,
    required this.seatNumber,
    required this.price,
    this.showtime,
  });

  factory Seat.fromJson(Map<String, dynamic> json) {
    return Seat(
      seatId: json['seatId'] ?? json['seat_id'] ?? 0,
      seatNumber: json['seatNumber'] ?? 0,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0).toDouble(),
      showtime: json['showtime'] != null
          ? Showtime.fromJson(json['showtime'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'seatId': seatId,
    'seatNumber': seatNumber,
    'price': price,
    'showtime': showtime?.toJson(),
  };
}

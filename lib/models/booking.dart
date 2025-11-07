import 'showtime.dart';
import 'seat.dart';

class Booking {
  final int bookingId;
  final double price;
  final DateTime bookingTime;
  final Showtime? showtime;
  final Seat? seat;

  Booking({
    required this.bookingId,
    required this.price,
    required this.bookingTime,
    this.showtime,
    this.seat,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'] ?? json['booking_id'] ?? 0,
      price: (json['price'] is int)
          ? (json['price'] as int).toDouble()
          : (json['price'] ?? 0.0).toDouble(),
      bookingTime: DateTime.tryParse(json['bookingTime'] ?? '') ??
          DateTime.now(),
      showtime: json['showtime'] != null
          ? Showtime.fromJson(json['showtime'])
          : null,
      seat: json['seat'] != null ? Seat.fromJson(json['seat']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bookingId': bookingId,
      'price': price,
      'bookingTime': bookingTime.toIso8601String(),
      'showtime': showtime?.toJson(),
      'seat': seat?.toJson(),
    };
  }
}

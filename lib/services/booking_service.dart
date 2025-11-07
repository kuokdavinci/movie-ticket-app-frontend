import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/showtime.dart';
import '../models/seat.dart';
import '../models/booking.dart';

class BookingService {
  final String baseUrl = "http://localhost:8080/api";

  // --------------------- Lấy danh sách suất chiếu ---------------------
  Future<List<Showtime>> fetchShowtimes(int movieId, String token) async {
    final url = Uri.parse("$baseUrl/movies/$movieId/bookings/show-times");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Showtime.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi khi lấy danh sách showtime: ${response.statusCode}");
    }
  }

  // --------------------- Lấy danh sách ghế trống ---------------------
  Future<List<Seat>> fetchSeats({
    required int movieId,
    required int showtimeId,
    required String token,
  }) async {
    final url = Uri.parse(
        "$baseUrl/movies/$movieId/bookings/show-times/$showtimeId/seats");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> data = json['availableSeats'];
      return data.map((e) => Seat.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi khi lấy danh sách ghế: ${response.statusCode}");
    }
  }

  // --------------------- Đặt vé ---------------------
  Future<void> bookSeat({
    required int movieId,
    required int showtimeId,
    required int seatNumber,
    required String token,
  }) async {
    final url = Uri.parse("$baseUrl/movies/$movieId/bookings");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'showtime_id': showtimeId,
        'seat_number': seatNumber,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          "Không thể đặt ghế: ${response.statusCode} - ${response.body}");
    }
  }

  Future<List<Booking>> fetchMyBookings(String token) async {
    final url = Uri.parse("$baseUrl/my-bookings");

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Booking.fromJson(e)).toList();
    } else {
      throw Exception("Lỗi khi lấy danh sách vé: ${response.statusCode}");
    }
  }

  Future<void> cancelBooking(int bookingId, String token) async {
    final url = Uri.parse("$baseUrl/my-bookings/$bookingId");

    final response = await http.delete(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Không thể hủy vé: ${response.statusCode}");
    }
  }
}

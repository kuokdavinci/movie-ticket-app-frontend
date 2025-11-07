import 'package:flutter/material.dart';
import '../models/showtime.dart';
import '../models/seat.dart';
import '../services/booking_service.dart';

class BookingViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Showtime> showtimes = [];
  List<Seat> seats = [];

  int? selectedShowtimeId;
  int? selectedSeatId;

  bool isLoadingShowtimes = false;
  bool isLoadingSeats = false;
  bool isBooking = false; // ✅ Thêm biến này

  String? _token;

  void setToken(String token) {
    _token = token;
  }

  /// Lấy danh sách showtime theo movie
  Future<void> fetchShowtimes(int movieId) async {
    if (_token == null) throw Exception("No token set");
    isLoadingShowtimes = true;
    notifyListeners();

    try {
      showtimes = await _bookingService.fetchShowtimes(movieId, _token!);
    } catch (e) {
      print("Error fetching showtimes: $e");
      showtimes = [];
    } finally {
      isLoadingShowtimes = false;
      notifyListeners();
    }
  }

  Future<void> fetchSeats(int movieId, int showtimeId) async {
    if (_token == null) throw Exception("No token set");
    isLoadingSeats = true;
    notifyListeners();

    try {
      seats = await _bookingService.fetchSeats(
        movieId: movieId,
        showtimeId: showtimeId,
        token: _token!,
      );
    } catch (e) {
      print("Error fetching seats: $e");
      seats = [];
    } finally {
      isLoadingSeats = false;
      notifyListeners();
    }
  }

  /// Đặt ghế
  Future<void> bookSeat(int movieId, int showtimeId, int seatNumber) async {
    if (_token == null) throw Exception("No token set");

    isBooking = true;
    notifyListeners();

    try {
      await _bookingService.bookSeat(
        movieId: movieId,
        showtimeId: showtimeId,
        seatNumber: seatNumber,
        token: _token!,
      );

      await fetchSeats(movieId, showtimeId);
    } catch (e) {
      print("Error booking seat: $e");
      rethrow;
    } finally {
      isBooking = false;
      notifyListeners();
    }
  }

  void selectShowtime(int id) {
    selectedShowtimeId = id;
    selectedSeatId = null;
    seats.clear();
    notifyListeners();
  }

  void selectSeat(int seatId) {
    selectedSeatId = seatId;
    notifyListeners();
  }

  bool get hasSelectedSeat => selectedSeatId != null;

}

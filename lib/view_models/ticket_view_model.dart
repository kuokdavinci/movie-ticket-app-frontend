import 'package:flutter/material.dart';
import '../models/booking.dart';
import '../services/booking_service.dart';

class TicketViewModel extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  List<Booking> tickets = [];
  bool isLoading = false;
  bool isCancelling = false;

  /// Lấy danh sách vé của user hiện tại
  Future<void> fetchTickets(String token) async {
    isLoading = true;
    notifyListeners();
    try {
      tickets = await _bookingService.fetchMyBookings(token);
    } catch (e) {
      tickets = [];
      print("Lỗi fetch tickets: $e");
    }
    isLoading = false;
    notifyListeners();
  }

  /// Hủy vé theo bookingId
  Future<void> cancelTicket(int bookingId, String token) async {
    isCancelling = true;
    notifyListeners();
    try {
      await _bookingService.cancelBooking(bookingId, token);
      tickets.removeWhere((t) => t.bookingId == bookingId);
    } catch (e) {
      print("Lỗi hủy vé: $e");
    }
    isCancelling = false;
    notifyListeners();
  }
}

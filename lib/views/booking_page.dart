import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/booking_view_model.dart';
import '../models/showtime.dart';
import '../models/seat.dart';

class BookingPage extends StatefulWidget {
  final int movieId;
  const BookingPage({Key? key, required this.movieId}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<BookingViewModel>(context, listen: false);
      vm.fetchShowtimes(widget.movieId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BookingViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Đặt vé")),
      body: Column(
        children: [
          // --- Showtimes ---
          if (vm.isLoadingShowtimes)
            const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            )
          else
            SizedBox(
              height: 70,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: vm.showtimes.length,
                itemBuilder: (context, index) {
                  final Showtime showtime = vm.showtimes[index];
                  final bool isSelected =
                      showtime.showtimeId == vm.selectedShowtimeId;

                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: ChoiceChip(
                      label: Text(_formatTime(showtime.startTime)),
                      selected: isSelected,
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                      onSelected: (_) {
                        vm.selectShowtime(showtime.showtimeId);
                        vm.fetchSeats(widget.movieId, showtime.showtimeId);
                      },
                    ),
                  );
                },
              ),
            ),

          const Divider(),

          // --- Seats ---
          Expanded(
            child: vm.isLoadingSeats
                ? const Center(child: CircularProgressIndicator())
                : vm.seats.isEmpty
                ? const Center(child: Text("Không có ghế khả dụng"))
                : GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5, // giảm kích thước ghế
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1, // vuông
              ),
              itemCount: vm.seats.length,
              itemBuilder: (context, index) {
                final Seat seat = vm.seats[index];
                final bool isSelected =
                    vm.selectedSeatId == seat.seatId;

                return GestureDetector(
                  onTap: () => vm.selectSeat(seat.seatId),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color:
                      isSelected ? Colors.green : Colors.grey[800],
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: isSelected
                          ? [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.5),
                          blurRadius: 5,
                          spreadRadius: 2,
                        )
                      ]
                          : [],
                    ),
                    child: Center(
                      child: Text(
                        seat.seatNumber.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // --- Book button ---
          if (vm.hasSelectedSeat)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: vm.isBooking
                      ? null
                      : () async {
                    try {
                      await vm.bookSeat(
                        widget.movieId,
                        vm.selectedShowtimeId!,
                        vm.selectedSeatId!,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Đặt vé thành công ✅")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đặt vé lỗi: $e")),
                      );
                    }
                  },
                  child: vm.isBooking
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Xác nhận đặt vé",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(String? t) {
    if (t == null || t.isEmpty) return "---";
    try {
      final dt = DateTime.parse(t);
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {
      return t;
    }
  }
}

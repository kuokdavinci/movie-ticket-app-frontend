import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../view_models/ticket_view_model.dart';
import '../models/booking.dart';

class TicketPage extends StatefulWidget {
  final String token;
  const TicketPage({super.key, required this.token});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TicketViewModel>(context, listen: false)
          .fetchTickets(widget.token);
    });
  }

  @override
  Widget build(BuildContext context) {
    final ticketVM = Provider.of<TicketViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Ticket'),
        centerTitle: true,
      ),
      body: ticketVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ticketVM.tickets.isEmpty
          ? const Center(child: Text('Ticket not found.'))
          : ListView.builder(
        itemCount: ticketVM.tickets.length,
        itemBuilder: (context, index) {
          final booking = ticketVM.tickets[index];
          return _buildTicketCard(context, booking, ticketVM);
        },
      ),
    );
  }

  Widget _buildTicketCard(
      BuildContext context, Booking booking, TicketViewModel ticketVM) {
    final movie = booking.showtime?.movie;
    final showtime = booking.showtime;
    final seat = booking.seat;

    final formattedDate =
    DateFormat('HH:mm dd/MM/yyyy').format(booking.bookingTime);
    final formattedPrice =
    NumberFormat("#,###", "vi_VN").format(booking.price);

    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: movie != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            movie.imageURL,
            width: 60,
            height: 90,
            fit: BoxFit.cover,
          ),
        )
            : const Icon(Icons.movie, size: 50),
        title: Text(
          movie?.name ?? 'Not found',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
                "Showtime: ${showtime?.startTime ?? '--:--'} - ${showtime?.endTime ?? '--:--'}"),
            Text("Seat: ${seat?.seatNumber ?? '-'}"),
            Text("Price: $formattedPrice VNĐ"),
            Text("Booked at: $formattedDate"),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.cancel, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Confirm ticket cancellation'),
                content: const Text('Are you sure to cancel this ticket?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: TextButton.styleFrom(foregroundColor: Colors.black),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(foregroundColor: Colors.black),
                      child: const Text('Yes')),
                ],
              ),
            );

            if (confirm == true) {
              await ticketVM.cancelTicket(booking.bookingId, widget.token);
            }
          },
        ),
      ),
    );
  }
}

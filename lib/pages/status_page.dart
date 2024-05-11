import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery_app/cubit/cart_cubit.dart';
import 'package:food_delivery_app/cubit/status_cubit.dart';
import 'package:food_delivery_app/model/status_state.dart'; // Ensure correct import

class StatusPage extends StatelessWidget {
  StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context
        .read<StatusCubit>()
        .fetchStatus(); // Trigger fetching status on build
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: BlocBuilder<StatusCubit, StatusState>(
              builder: (context, state) {
                if (state is StatusLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is StatusLoaded) {
                  var status = state.status['status'];
                  var timestamp = state.status['timestamp'];

                  if (timestamp != null) {
                    // Format timestamp
                    var formattedTimestamp =
                        DateTime.parse(timestamp).toLocal().toString();

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Current Status: $status at $formattedTimestamp',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (status == 'belum_bayar')
                          // Show payment button if status is 'belum_bayar'
                          ElevatedButton(
                            onPressed: () {
                              context.read<StatusCubit>().setPaymentStatus();
                            },
                            child: Text('Bayar Sekarang'),
                          ),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            'Current Status: $status',
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        if (status == 'belum_bayar')
                          // Show payment button if status is 'belum_bayar'
                          ElevatedButton(
                            onPressed: () {
                              context.read<StatusCubit>().setPaymentStatus();
                            },
                            child: Text('Bayar Sekarang'),
                          ),
                      ],
                    );
                  }
                } else if (state is StatusError) {
                  return Center(
                    child: Text(state.message),
                  );
                }
                return Text(
                    "No status available"); // Fallback text for uninitialized state
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 8.0, // Space between buttons
              runSpacing: 4.0, // Space between rows
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<StatusCubit>()
                        .setStatus("set_status_penjual_terima");
                  },
                  child: Text('Penjual Terima'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await context
                        .read<StatusCubit>()
                        .setStatus("set_status_penjual_tolak");
                    BlocProvider.of<CartCubit>(context)
                        .clearWholeCartByUserId();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("pesanan ditolak, cart dikosongkan")));
                  },
                  child: Text('Penjual Tolak'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<StatusCubit>().setStatus("set_status_diantar");
                  },
                  child: Text('Diantar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<StatusCubit>()
                        .setStatus("set_status_diterima");
                    BlocProvider.of<CartCubit>(context)
                        .clearWholeCartByUserId();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Pesanan selesai, cart dikosongkan")));
                  },
                  child: Text('Diterima'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final auth = Provider.of<AppAuthProvider>(context);
    final userOrders = store.listenToOrders().where((o) => o.userId == auth.currentUser?.id).toList();

    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Historial'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: DataTable(
          columns: const [
            DataColumn(label: Text('ID')),
            DataColumn(label: Text('Total')),
            DataColumn(label: Text('Estado')),
          ],
          rows: userOrders.map((o) {
            return DataRow(cells: [
              DataCell(Text(o.id.substring(0, 4))),
              DataCell(Text('\$${o.total}')),
              DataCell(Text(o.status)),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
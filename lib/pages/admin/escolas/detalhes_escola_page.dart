import 'package:flutter/material.dart';
import 'package:tea_agenda/data/local/database.dart';

class DetalhesEscolaPage extends StatelessWidget {
  final Escola escola;
  
  const DetalhesEscolaPage({super.key, required this.escola});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Escola'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue,
              child: Icon(Icons.school, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              escola.escNome,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Divider(height: 32),
            _buildDetailItem(Icons.description, "CNPJ", escola.escCNPJ),
            _buildDetailItem(Icons.location_on, "Endereço", escola.escEndereco),
            _buildDetailItem(Icons.map, "Bairro", escola.escBairro),
            _buildDetailItem(Icons.location_city, "Cidade", escola.escCidade),
            _buildDetailItem(Icons.local_post_office, "CEP", escola.escCEP),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, color: Colors.black87)),
    );
  }
}
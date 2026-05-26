import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tea_agenda/pages/professores/student_selection.dart';
import 'package:tea_agenda/pages/login_page.dart';

class ClassSelection extends StatefulWidget {
  const ClassSelection({super.key});

  @override
  State<ClassSelection> createState() => _ClassSelectionPageState();
}

class _ClassSelectionPageState extends State<ClassSelection> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Minhas Turmas"),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: supabase.from('turmas_do_professor').stream(primaryKey: ['tur_id']).eq('tur_professor', user!.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar turmas: ${snapshot.error}"));
          }

          final turmas = snapshot.data ?? [];

          if (turmas.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Você não possui turmas vinculadas."),
                  const SizedBox(height: 16),
                  _buildBotaoDeslogar(),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: turmas.length,
                  itemBuilder: (context, index) {
                    final turma = turmas[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFF2196F3),
                          child: Icon(Icons.groups, color: Colors.white),
                        ),
                        title: Text(
                          "Turma ${turma['tur_numero']}",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("${turma['ano_numero']}º Ano - ${turma['esc_nome']}"),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudentSelection(
                                turmaId: turma['tur_id'],
                                turmaNome: turma['tur_numero'].toString(),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8), 
                _buildBotaoDeslogar(),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBotaoDeslogar() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () async {
          try {
            await supabase.auth.signOut();
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            }
          } catch (e) {
            debugPrint("Erro ao deslogar: $e");
          }
        },
        icon: const Icon(Icons.logout),
        label: const Text('Sair do Sistema'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red[50],
          foregroundColor: Colors.red,
        ),
      ),
    );
  }
}
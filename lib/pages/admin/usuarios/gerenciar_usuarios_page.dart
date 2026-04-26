import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tea_agenda/data/local/database.dart';
import 'package:tea_agenda/pages/admin/usuarios/adicionar_usuarios_page.dart';
import 'package:tea_agenda/pages/admin/usuarios/detalhes_usuarios_page.dart';

class GerenciarUsuariosPage extends StatefulWidget {
    const GerenciarUsuariosPage({super.key});

    @override
    State<GerenciarUsuariosPage> createState() => _GerenciarUsuariosPageState();
}

class _GerenciarUsuariosPageState extends State<GerenciarUsuariosPage> {
    final TextEditingController _searchController = TextEditingController();
    String _filtro = '';

    @override
    Widget build(BuildContext context) {
        
        final database = Provider.of<AppDatabase>(context);

        return Scaffold(
            appBar: AppBar(
                title: const Text("Gerenciar Usuários"),
            ),
            body: Column(
                children: [
                    //Filtro
                    Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                                setState(() {
                                    _filtro = value;
                                });
                            },
                            decoration: InputDecoration(
                                labelText: 'Pesquisar usuário',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.grey[100],
                            ),
                        ),
                    ),
                    // Lista de Escolas
                    Expanded(
                        child: StreamBuilder<List<Usuario>>(
                            stream: database.watchUsuarios(),
                            builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                    return const Center(child: CircularProgressIndicator());
                                }

                                if (snapshot.hasError) {
                                    return Center(child: Text("Erro: ${snapshot.error}"));
                                }

                                final listaUsuarios = snapshot.data ?? [];

                                final usuariosFiltrados = listaUsuarios.where((usuario) {
                                    return usuario.usuNome
                                        .toLowerCase()
                                        .contains(_filtro.toLowerCase());
                                }).toList();

                                if (usuariosFiltrados.isEmpty) {
                                    return const Center(
                                        child: Text("Nenhum usuário encontrado."),
                                    );
                                }

                                return ListView.builder(
                                    itemCount: usuariosFiltrados.length,
                                    itemBuilder: (context, index) {
                                        final usuario = usuariosFiltrados[index];
                                        return Card(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 16,
                                                vertical: 4,
                                            ),
                                            child: ListTile(
                                                leading: const Icon(Icons.person, color: Colors.blue),
                                                title: Text(usuario.usuNome),
                                                subtitle: Text("${usuario.usuCargo}"),
                                                trailing: IconButton(
                                                    icon: const Icon(Icons.edit, size: 20),
                                                    onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => AdicionarUsuarioPage(usuarioEdicao: usuario),
                                                            ),
                                                        );
                                                    },
                                                ),
                                                onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => DetalhesUsuarioPage(usuario: usuario),
                                                        )
                                                    );
                                                },
                                            ),
                                        );
                                    },
                                );
                            },
                        ),
                    ),
                ],
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AdicionarUsuarioPage(),
                        ),
                    );
                },
                child: const Icon(Icons.add),
            ),
        );
    }
}
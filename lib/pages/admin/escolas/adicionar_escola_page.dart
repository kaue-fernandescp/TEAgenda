import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as d;   // Não ter conflito com o Material
import 'package:tea_agenda/data/local/database.dart';
import 'package:provider/provider.dart';

class AdicionarEscolaPage extends StatefulWidget {
  final Escola? escolaEdicao;
  const AdicionarEscolaPage({super.key, this.escolaEdicao});

  @override
  State<AdicionarEscolaPage> createState() => _AdicionarEscolaPageState();
}

class _AdicionarEscolaPageState extends State<AdicionarEscolaPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _cepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.escolaEdicao != null) {
      _nomeController.text = widget.escolaEdicao!.escNome;
      _cnpjController.text = widget.escolaEdicao!.escCNPJ;
      _enderecoController.text = widget.escolaEdicao!.escEndereco;
      _bairroController.text = widget.escolaEdicao!.escBairro;
      _cidadeController.text = widget.escolaEdicao!.escCidade;
      _cepController.text = widget.escolaEdicao!.escCEP;
    }
  }

  void _salvarEscola() async {
    if (_formKey.currentState!.validate()) {
      final database = Provider.of<AppDatabase>(context, listen: false);

      final novaEscola = EscolasCompanion(
        escNome: d.Value(_nomeController.text),
        escCNPJ: d.Value(_cnpjController.text),
        escEndereco: d.Value(_enderecoController.text),
        escBairro: d.Value(_bairroController.text),
        escCidade: d.Value(_cidadeController.text),
        escCEP: d.Value(_cepController.text),
      );

      if (widget.escolaEdicao != null) {
        final escolaId = novaEscola.copyWith(
          escId: d.Value(widget.escolaEdicao!.escId),
        );
        await database.update(database.escolas).replace(escolaId);
      } else {
        await database.insertEscola(novaEscola);
      }

      String mensagem = widget.escolaEdicao != null
        ? 'Escola alterada com sucesso!'
        : 'Escola cadastrada com sucesso!';

      if (!mounted) return;
      Navigator.pop(context); // Voltar para a lista
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.escolaEdicao != null ? 'Editar Escola' : 'Nova Escola')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome da Escola'),
                validator: (v) => v!.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cnpjController,
                decoration: const InputDecoration(labelText: 'CNPJ'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _enderecoController,
                decoration: const InputDecoration(labelText: 'Endereço'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _bairroController,
                decoration: const InputDecoration(labelText: 'Bairro'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cidadeController,
                decoration: const InputDecoration(labelText: 'Cidade'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _cepController,
                decoration: const InputDecoration(labelText: 'CEP'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _salvarEscola,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                child: Text(widget.escolaEdicao != null ? 'Salvar Alterações' : 'Cadastrar Escola'),
              ),
            ],
          ),
        ),
      )
    );
  }
}
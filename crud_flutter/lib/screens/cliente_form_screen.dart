// lib/screens/cliente_form_screen.dart
import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';

class ClienteFormScreen extends StatefulWidget {
 const ClienteFormScreen({Key? key}) : super(key: key);

 @override
 State<ClienteFormScreen> createState() => _ClienteFormScreenState();
}

class _ClienteFormScreenState extends State<ClienteFormScreen> {
 final _formKey = GlobalKey<FormState>();
 final _clienteService = ClienteService();
 final _nomeController = TextEditingController();
 final _sobrenomeController = TextEditingController();
 final _emailController = TextEditingController();
 final _idadeController = TextEditingController();
 final _fotoController = TextEditingController();
 Cliente? _clienteParaEditar;

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   _clienteParaEditar = ModalRoute.of(context)?.settings.arguments as Cliente?;
   if (_clienteParaEditar != null) {
     _nomeController.text = _clienteParaEditar!.nome;
     _sobrenomeController.text = _clienteParaEditar!.sobrenome;
     _emailController.text = _clienteParaEditar!.email;
     _idadeController.text = _clienteParaEditar!.idade.toString();
     _fotoController.text = _clienteParaEditar!.foto ?? '';
   }
 }

 String? _validarNome(String? value) {
   if (value == null || value.isEmpty) {
     return 'Campo obrigatório';
   }
   if (value.length < 3) {
     return 'Mínimo de 3 caracteres';
   }
   if (value.length > 25) {
     return 'Máximo de 25 caracteres';
   }
   return null;
 }

 String? _validarEmail(String? value) {
   if (value == null || value.isEmpty) {
     return 'Campo obrigatório';
   }
   final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
   if (!emailRegex.hasMatch(value)) {
     return 'Email inválido';
   }
   return null;
 }

 String? _validarIdade(String? value) {
   if (value == null || value.isEmpty) {
     return 'Campo obrigatório';
   }
   final idade = int.tryParse(value);
   if (idade == null) {
     return 'Digite um número válido';
   }
   if (idade <= 0 || idade >= 120) {
     return 'Idade deve ser entre 1 e 120';
   }
   return null;
 }

 Future<void> _salvarCliente() async {
   if (_formKey.currentState!.validate()) {
     try {
       final cliente = Cliente(
         id: _clienteParaEditar?.id,
         nome: _nomeController.text,
         sobrenome: _sobrenomeController.text,
         email: _emailController.text,
         idade: int.parse(_idadeController.text),
         foto: _fotoController.text.isEmpty ? null : _fotoController.text,
       );

       if (_clienteParaEditar == null) {
         await _clienteService.addCliente(cliente);
       } else {
         await _clienteService.updateCliente(cliente);
       }

       if (mounted) {
         Navigator.pop(context);
       }
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Erro ao salvar cliente: $e')),
       );
     }
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(_clienteParaEditar == null ? 'Novo Cliente' : 'Editar Cliente'),
     ),
     body: Padding(
       padding: const EdgeInsets.all(16.0),
       child: Form(
         key: _formKey,
         child: ListView(
           children: [
             TextFormField(
               controller: _nomeController,
               decoration: const InputDecoration(labelText: 'Nome'),
               validator: _validarNome,
             ),
             TextFormField(
               controller: _sobrenomeController,
               decoration: const InputDecoration(labelText: 'Sobrenome'),
               validator: _validarNome,
             ),
             TextFormField(
               controller: _emailController,
               decoration: const InputDecoration(labelText: 'Email'),
               validator: _validarEmail,
               keyboardType: TextInputType.emailAddress,
             ),
             TextFormField(
               controller: _idadeController,
               decoration: const InputDecoration(labelText: 'Idade'),
               validator: _validarIdade,
               keyboardType: TextInputType.number,
             ),
             TextFormField(
               controller: _fotoController,
               decoration: const InputDecoration(
                 labelText: 'URL da Foto (opcional)',
                 hintText: 'http://exemplo.com/foto.jpg',
               ),
             ),
             const SizedBox(height: 20),
             ElevatedButton(
               onPressed: _salvarCliente,
               child: const Text('Salvar'),
             ),
           ],
         ),
       ),
     ),
   );
 }
}
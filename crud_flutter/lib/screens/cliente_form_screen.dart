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
 List<Cliente> _clientes = [];
 bool _isLoading = true;

 @override
 void initState() {
   super.initState();
   _carregarClientes();
 }

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   final clienteArgs = ModalRoute.of(context)?.settings.arguments as Cliente?;
   if (clienteArgs != null) {
     _preencherFormulario(clienteArgs);
   }
 }

 void _preencherFormulario(Cliente cliente) {
   setState(() {
     _clienteParaEditar = cliente;
     _nomeController.text = cliente.nome;
     _sobrenomeController.text = cliente.sobrenome;
     _emailController.text = cliente.email;
     _idadeController.text = cliente.idade.toString();
     _fotoController.text = cliente.foto ?? '';
   });
 }

 void _limparFormulario() {
   setState(() {
     _clienteParaEditar = null;
     _nomeController.clear();
     _sobrenomeController.clear();
     _emailController.clear();
     _idadeController.clear();
     _fotoController.clear();
   });
 }

 Future<void> _carregarClientes() async {
   try {
     final clientes = await _clienteService.getClientes();
     setState(() {
       _clientes = clientes;
       _isLoading = false;
     });
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Erro ao carregar clientes: $e')),
     );
     setState(() => _isLoading = false);
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
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Cliente adicionado com sucesso!'),
             backgroundColor: Colors.green,
           ),
         );
       } else {
         await _clienteService.updateCliente(cliente);
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Cliente atualizado com sucesso!'),
             backgroundColor: Colors.green,
           ),
         );
       }

       _limparFormulario();
       await _carregarClientes();
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('Erro ao salvar cliente: $e'),
           backgroundColor: Colors.red,
         ),
       );
     }
   }
 }

 Future<void> _deletarCliente(int id) async {
   try {
     await _clienteService.deleteCliente(id);
     await _carregarClientes();
     _limparFormulario();
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text('Cliente excluído com sucesso!'),
         backgroundColor: Colors.green,
       ),
     );
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Erro ao deletar cliente: $e'),
         backgroundColor: Colors.red,
       ),
     );
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(_clienteParaEditar == null ? 'Novo Cliente' : 'Editar Cliente'),
     ),
     body: SingleChildScrollView(
       padding: const EdgeInsets.all(16.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.stretch,
         children: [
           Card(
             elevation: 4,
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Form(
                 key: _formKey,
                 child: Column(
                   children: [
                     TextFormField(
                       controller: _nomeController,
                       decoration: const InputDecoration(
                         labelText: 'Nome',
                         prefixIcon: Icon(Icons.person),
                       ),
                       validator: _validarNome,
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _sobrenomeController,
                       decoration: const InputDecoration(
                         labelText: 'Sobrenome',
                         prefixIcon: Icon(Icons.person_outline),
                       ),
                       validator: _validarNome,
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _emailController,
                       decoration: const InputDecoration(
                         labelText: 'Email',
                         prefixIcon: Icon(Icons.email),
                       ),
                       validator: _validarEmail,
                       keyboardType: TextInputType.emailAddress,
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _idadeController,
                       decoration: const InputDecoration(
                         labelText: 'Idade',
                         prefixIcon: Icon(Icons.calendar_today),
                       ),
                       validator: _validarIdade,
                       keyboardType: TextInputType.number,
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _fotoController,
                       decoration: const InputDecoration(
                         labelText: 'URL da Foto (opcional)',
                         prefixIcon: Icon(Icons.photo),
                         hintText: 'http://exemplo.com/foto.jpg',
                       ),
                     ),
                     const SizedBox(height: 24),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       children: [
                         ElevatedButton.icon(
                           onPressed: _limparFormulario,
                           icon: const Icon(Icons.clear),
                           label: const Text('Limpar'),
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.grey,
                           ),
                         ),
                         ElevatedButton.icon(
                           onPressed: _salvarCliente,
                           icon: const Icon(Icons.save),
                           label: const Text('Salvar'),
                           style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.blue,
                           ),
                         ),
                       ],
                     ),
                   ],
                 ),
               ),
             ),
           ),
           const SizedBox(height: 24),
           const Text(
             'Clientes Cadastrados',
             style: TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.bold,
             ),
             textAlign: TextAlign.center,
           ),
           const SizedBox(height: 16),
           _isLoading
               ? const Center(child: CircularProgressIndicator())
               : _clientes.isEmpty
                   ? const Center(
                       child: Text(
                         'Nenhum cliente cadastrado',
                         style: TextStyle(fontSize: 16, color: Colors.grey),
                       ),
                     )
                   : ListView.builder(
                       shrinkWrap: true,
                       physics: const NeverScrollableScrollPhysics(),
                       itemCount: _clientes.length,
                       itemBuilder: (context, index) {
                         final cliente = _clientes[index];
                         return Card(
                           margin: const EdgeInsets.only(bottom: 8),
                           child: ListTile(
                             leading: CircleAvatar(
                               backgroundImage: cliente.foto != null
                                   ? NetworkImage(cliente.foto!)
                                   : null,
                               child: cliente.foto == null
                                   ? const Icon(Icons.person)
                                   : null,
                             ),
                             title: Text(
                               '${cliente.nome} ${cliente.sobrenome}',
                               style: const TextStyle(fontWeight: FontWeight.bold),
                             ),
                             subtitle: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(cliente.email),
                                 Text('Idade: ${cliente.idade} anos'),
                               ],
                             ),
                             trailing: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 IconButton(
                                   icon: const Icon(Icons.edit),
                                   onPressed: () => _preencherFormulario(cliente),
                                 ),
                                 IconButton(
                                   icon: const Icon(Icons.delete, color: Colors.red),
                                   onPressed: () => showDialog(
                                     context: context,
                                     builder: (context) => AlertDialog(
                                       title: const Text('Confirmar exclusão'),
                                       content: Text(
                                           'Deseja realmente excluir ${cliente.nome}?'),
                                       actions: [
                                         TextButton(
                                           onPressed: () => Navigator.pop(context),
                                           child: const Text('Cancelar'),
                                         ),
                                         TextButton(
                                           onPressed: () {
                                             Navigator.pop(context);
                                             _deletarCliente(cliente.id!);
                                           },
                                           child: const Text(
                                             'Excluir',
                                             style: TextStyle(color: Colors.red),
                                           ),
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
                               ],
                             ),
                           ),
                         );
                       },
                     ),
         ],
       ),
     ),
   );
 }
}
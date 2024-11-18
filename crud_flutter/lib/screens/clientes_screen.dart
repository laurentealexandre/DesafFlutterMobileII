import 'package:flutter/material.dart';
import '../models/cliente.dart';
import '../services/cliente_service.dart';

class ClientesScreen extends StatefulWidget {
 const ClientesScreen({Key? key}) : super(key: key);

 @override
 State<ClientesScreen> createState() => _ClientesScreenState();
}

class _ClientesScreenState extends State<ClientesScreen> {
 final ClienteService _clienteService = ClienteService();
 List<Cliente> _clientes = [];
 bool _isLoading = true;

 @override
 void initState() {
   super.initState();
   _carregarClientes();
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

 Future<void> _deletarCliente(int id) async {
   try {
     await _clienteService.deleteCliente(id);
     await _carregarClientes();
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Erro ao deletar cliente: $e')),
     );
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: const Text('Clientes'),
       actions: [
         IconButton(
           icon: const Icon(Icons.add),
           onPressed: () => Navigator.pushNamed(context, '/cliente-form')
               .then((_) => _carregarClientes()),
         ),
       ],
     ),
     body: _isLoading
         ? const Center(child: CircularProgressIndicator())
         : ListView.builder(
             itemCount: _clientes.length,
             itemBuilder: (context, index) {
               final cliente = _clientes[index];
               return Card(
                 margin: const EdgeInsets.all(8),
                 child: Padding(
                   padding: const EdgeInsets.all(12.0),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           CircleAvatar(
                             radius: 30,
                             backgroundImage: cliente.foto != null
                                 ? NetworkImage(cliente.foto!)
                                 : null,
                             child: cliente.foto == null
                                 ? const Icon(Icons.person, size: 30)
                                 : null,
                           ),
                           const SizedBox(width: 16),
                           Expanded(
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   '${cliente.nome} ${cliente.sobrenome}',
                                   style: const TextStyle(
                                     fontSize: 18,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 const SizedBox(height: 4),
                                 Text(
                                   cliente.email,
                                   style: const TextStyle(
                                     fontSize: 16,
                                     color: Colors.blue,
                                   ),
                                 ),
                                 const SizedBox(height: 4),
                                 Text(
                                   'Idade: ${cliente.idade} anos',
                                   style: const TextStyle(
                                     fontSize: 14,
                                     color: Colors.grey,
                                   ),
                                 ),
                               ],
                             ),
                           ),
                           Column(
                             children: [
                               IconButton(
                                 icon: const Icon(Icons.edit),
                                 onPressed: () => Navigator.pushNamed(
                                   context,
                                   '/cliente-form',
                                   arguments: cliente,
                                 ).then((_) => _carregarClientes()),
                               ),
                               IconButton(
                                 icon: const Icon(Icons.delete),
                                 onPressed: () => showDialog(
                                   context: context,
                                   builder: (context) => AlertDialog(
                                     title: const Text('Confirmar exclusão'),
                                     content: const Text(
                                         'Deseja realmente excluir este cliente?'),
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
                                         child: const Text('Excluir'),
                                         style: TextButton.styleFrom(
                                           foregroundColor: Colors.red,
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               ),
                             ],
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
               );
             },
           ),
   );
 }
}
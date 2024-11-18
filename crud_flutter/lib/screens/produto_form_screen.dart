// lib/screens/produto_form_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/produto.dart';
import '../services/produto_service.dart';

class ProdutoFormScreen extends StatefulWidget {
 const ProdutoFormScreen({Key? key}) : super(key: key);

 @override
 State<ProdutoFormScreen> createState() => _ProdutoFormScreenState();
}

class _ProdutoFormScreenState extends State<ProdutoFormScreen> {
 final _formKey = GlobalKey<FormState>();
 final _produtoService = ProdutoService();
 final _nomeController = TextEditingController();
 final _descricaoController = TextEditingController();
 final _precoController = TextEditingController();
 Produto? _produtoParaEditar;
 List<Produto> _produtos = [];
 bool _isLoading = true;
 DateTime _dataAtualizado = DateTime.now();
 final _formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

 @override
 void initState() {
   super.initState();
   _carregarProdutos();
 }

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   final produtoArgs = ModalRoute.of(context)?.settings.arguments as Produto?;
   if (produtoArgs != null) {
     _preencherFormulario(produtoArgs);
   }
 }

 void _preencherFormulario(Produto produto) {
   setState(() {
     _produtoParaEditar = produto;
     _nomeController.text = produto.nome;
     _descricaoController.text = produto.descricao;
     _precoController.text = produto.preco.toString();
     _dataAtualizado = DateTime.parse(produto.dataAtualizado);
   });
 }

 void _limparFormulario() {
   setState(() {
     _produtoParaEditar = null;
     _nomeController.clear();
     _descricaoController.clear();
     _precoController.clear();
     _dataAtualizado = DateTime.now();
   });
 }

 Future<void> _carregarProdutos() async {
   try {
     final produtos = await _produtoService.getProdutos();
     setState(() {
       _produtos = produtos;
       _isLoading = false;
     });
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(content: Text('Erro ao carregar produtos: $e')),
     );
     setState(() => _isLoading = false);
   }
 }

 Future<void> _selecionarData() async {
   final data = await showDatePicker(
     context: context,
     initialDate: _dataAtualizado,
     firstDate: DateTime(2000),
     lastDate: DateTime(2100),
     locale: const Locale('pt', 'BR'),
   );
   if (data != null) {
     setState(() => _dataAtualizado = data);
   }
 }

 String? _validarCampo(String? value) {
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

 String? _validarPreco(String? value) {
   if (value == null || value.isEmpty) {
     return 'Campo obrigatório';
   }
   final preco = double.tryParse(value.replaceAll(',', '.'));
   if (preco == null) {
     return 'Digite um valor válido';
   }
   if (preco <= 0 || preco >= 120) {
     return 'Preço deve ser entre 0 e 120';
   }
   return null;
 }

 Future<void> _salvarProduto() async {
   if (_formKey.currentState!.validate()) {
     try {
       final produto = Produto(
         id: _produtoParaEditar?.id,
         nome: _nomeController.text,
         descricao: _descricaoController.text,
         preco: double.parse(_precoController.text.replaceAll(',', '.')),
         dataAtualizado: _dataAtualizado.toIso8601String(),
       );

       if (_produtoParaEditar == null) {
         await _produtoService.addProduto(produto);
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Produto adicionado com sucesso!'),
             backgroundColor: Colors.green,
           ),
         );
       } else {
         await _produtoService.updateProduto(produto);
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Produto atualizado com sucesso!'),
             backgroundColor: Colors.green,
           ),
         );
       }

       _limparFormulario();
       await _carregarProdutos();
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text('Erro ao salvar produto: $e'),
           backgroundColor: Colors.red,
         ),
       );
     }
   }
 }

 Future<void> _deletarProduto(int id) async {
   try {
     await _produtoService.deleteProduto(id);
     await _carregarProdutos();
     _limparFormulario();
     ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
         content: Text('Produto excluído com sucesso!'),
         backgroundColor: Colors.green,
       ),
     );
   } catch (e) {
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Erro ao deletar produto: $e'),
         backgroundColor: Colors.red,
       ),
     );
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(_produtoParaEditar == null ? 'Novo Produto' : 'Editar Produto'),
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
                         prefixIcon: Icon(Icons.inventory),
                       ),
                       validator: _validarCampo,
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _descricaoController,
                       decoration: const InputDecoration(
                         labelText: 'Descrição',
                         prefixIcon: Icon(Icons.description),
                       ),
                       validator: _validarCampo,
                       maxLines: 3,
                     ),
                     const SizedBox(height: 16),
                     TextFormField(
                       controller: _precoController,
                       decoration: const InputDecoration(
                         labelText: 'Preço',
                         prefixIcon: Icon(Icons.attach_money),
                         prefixText: 'R\$ ',
                       ),
                       validator: _validarPreco,
                       keyboardType: TextInputType.numberWithOptions(decimal: true),
                     ),
                     const SizedBox(height: 16),
                     ListTile(
                       title: const Text('Data de Atualização'),
                       subtitle: Text(
                         DateFormat('dd/MM/yyyy').format(_dataAtualizado),
                       ),
                       leading: const Icon(Icons.calendar_today),
                       onTap: _selecionarData,
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
                           onPressed: _salvarProduto,
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
             'Produtos Cadastrados',
             style: TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.bold,
             ),
             textAlign: TextAlign.center,
           ),
           const SizedBox(height: 16),
           _isLoading
               ? const Center(child: CircularProgressIndicator())
               : _produtos.isEmpty
                   ? const Center(
                       child: Text(
                         'Nenhum produto cadastrado',
                         style: TextStyle(fontSize: 16, color: Colors.grey),
                       ),
                     )
                   : ListView.builder(
                       shrinkWrap: true,
                       physics: const NeverScrollableScrollPhysics(),
                       itemCount: _produtos.length,
                       itemBuilder: (context, index) {
                         final produto = _produtos[index];
                         return Card(
                           margin: const EdgeInsets.only(bottom: 8),
                           child: ListTile(
                             title: Text(
                               produto.nome,
                               style: const TextStyle(fontWeight: FontWeight.bold),
                             ),
                             subtitle: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(produto.descricao),
                                 Text(
                                   _formatoMoeda.format(produto.preco),
                                   style: const TextStyle(
                                     color: Colors.green,
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                                 Text(
                                   'Atualizado: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(produto.dataAtualizado))}',
                                   style: const TextStyle(fontSize: 12),
                                 ),
                               ],
                             ),
                             trailing: Row(
                               mainAxisSize: MainAxisSize.min,
                               children: [
                                 IconButton(
                                   icon: const Icon(Icons.edit),
                                   onPressed: () => _preencherFormulario(produto),
                                 ),
                                 IconButton(
                                   icon: const Icon(Icons.delete, color: Colors.red),
                                   onPressed: () => showDialog(
                                     context: context,
                                     builder: (context) => AlertDialog(
                                       title: const Text('Confirmar exclusão'),
                                       content: Text(
                                           'Deseja realmente excluir ${produto.nome}?'),
                                       actions: [
                                         TextButton(
                                           onPressed: () => Navigator.pop(context),
                                           child: const Text('Cancelar'),
                                         ),
                                         TextButton(
                                           onPressed: () {
                                             Navigator.pop(context);
                                             _deletarProduto(produto.id!);
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
import 'package:flutter/material.dart';
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

 @override
 void didChangeDependencies() {
   super.didChangeDependencies();
   _produtoParaEditar = ModalRoute.of(context)?.settings.arguments as Produto?;
   if (_produtoParaEditar != null) {
     _nomeController.text = _produtoParaEditar!.nome;
     _descricaoController.text = _produtoParaEditar!.descricao;
     _precoController.text = _produtoParaEditar!.preco.toString();
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
         dataAtualizado: DateTime.now(),
       );

       if (_produtoParaEditar == null) {
         await _produtoService.addProduto(produto);
       } else {
         await _produtoService.updateProduto(produto);
       }

       if (mounted) {
         Navigator.pop(context);
       }
     } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(content: Text('Erro ao salvar produto: $e')),
       );
     }
   }
 }

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text(_produtoParaEditar == null ? 'Novo Produto' : 'Editar Produto'),
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
               validator: _validarCampo,
             ),
             TextFormField(
               controller: _descricaoController,
               decoration: const InputDecoration(labelText: 'Descrição'),
               validator: _validarCampo,
               maxLines: 3,
             ),
             TextFormField(
               controller: _precoController,
               decoration: const InputDecoration(
                 labelText: 'Preço',
                 prefixText: 'R\$ ',
               ),
               validator: _validarPreco,
               keyboardType: TextInputType.numberWithOptions(decimal: true),
             ),
             const SizedBox(height: 20),
             ElevatedButton(
               onPressed: _salvarProduto,
               child: const Text('Salvar'),
             ),
           ],
         ),
       ),
     ),
   );
 }
}
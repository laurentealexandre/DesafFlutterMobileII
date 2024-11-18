const express = require('express');
const mysql = require('mysql');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const db = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'crud_flutter'
});

db.connect((err) => {
  if (err) throw err;
  console.log('MySQL Connected');
});

// Rotas Clientes
app.get('/api/clientes', (req, res) => {
  db.query('SELECT * FROM clientes', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.post('/api/clientes', (req, res) => {
  const { nome, sobrenome, email, idade, foto } = req.body;
  db.query(
    'INSERT INTO clientes (nome, sobrenome, email, idade, foto) VALUES (?, ?, ?, ?, ?)',
    [nome, sobrenome, email, idade, foto],
    (err, result) => {
      if (err) throw err;
      res.json({ id: result.insertId });
    }
  );
});

app.put('/api/clientes/:id', (req, res) => {
  const { nome, sobrenome, email, idade, foto } = req.body;
  db.query(
    'UPDATE clientes SET nome=?, sobrenome=?, email=?, idade=?, foto=? WHERE id=?',
    [nome, sobrenome, email, idade, foto, req.params.id],
    (err) => {
      if (err) throw err;
      res.json({ success: true });
    }
  );
});

app.delete('/api/clientes/:id', (req, res) => {
  db.query('DELETE FROM clientes WHERE id=?', [req.params.id], (err) => {
    if (err) throw err;
    res.json({ success: true });
  });
});

// Rotas Produtos
app.get('/api/produtos', (req, res) => {
  db.query('SELECT * FROM produtos', (err, result) => {
    if (err) throw err;
    res.json(result);
  });
});

app.post('/api/produtos', (req, res) => {
  const { nome, descricao, preco, data_atualizado } = req.body;
  db.query(
    'INSERT INTO produtos (nome, descricao, preco, data_atualizado) VALUES (?, ?, ?, ?)',
    [nome, descricao, preco, data_atualizado],
    (err, result) => {
      if (err) throw err;
      res.json({ id: result.insertId });
    }
  );
});

app.put('/api/produtos/:id', (req, res) => {
  const { nome, descricao, preco, data_atualizado } = req.body;
  db.query(
    'UPDATE produtos SET nome=?, descricao=?, preco=?, data_atualizado=? WHERE id=?',
    [nome, descricao, preco, data_atualizado, req.params.id],
    (err) => {
      if (err) throw err;
      res.json({ success: true });
    }
  );
});

app.delete('/api/produtos/:id', (req, res) => {
  db.query('DELETE FROM produtos WHERE id=?', [req.params.id], (err) => {
    if (err) throw err;
    res.json({ success: true });
  });
});

const PORT = 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
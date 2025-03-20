import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(BankingApp());
}  

class BankingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Banking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text('Welcome to PNB BANK', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text('Today: $todayDate', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountListScreen()),
              ),
              child: Text('View Accounts'),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountListScreen extends StatelessWidget {
  final String accountsJson = '{ "accounts": [ { "type": "Chequing", "account_number": "CHQ123456789", "balance": 2500.00 }, { "type": "Savings", "account_number": "SAV987654321", "balance": 5000.00 } ] }';

  @override
  Widget build(BuildContext context) {
    List accounts = json.decode(accountsJson)['accounts'];
    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      body: ListView.builder(
        itemCount: accounts.length,
        itemBuilder: (context, index) {
          var account = accounts[index];
          return Card(
            child: ListTile(
              title: Text('${account['type']} Account'),
              subtitle: Text('Account No: ${account['account_number']}\nBalance: \$${account['balance']}'),
              trailing: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionScreen(accountType: account['type']),
                  ),
                ),
                child: Text('View Transactions'),
              ),
            ),
          );
        },
      ),
    );
  }
}

class TransactionScreen extends StatelessWidget {
  final String accountType;
  final String transactionsJson = '{ "transactions": { "Chequing": [ { "date": "2024-04-14", "description": "Utility Bill Payment", "amount": -120.00 }, { "date": "2024-04-16", "description": "ATM Withdrawal", "amount": -75.00 }, { "date": "2024-04-17", "description": "Deposit", "amount": 100.00 }, { "date": "2024-04-18", "description": "Withdrawal", "amount": -50.00 } ], "Savings": [ { "date": "2024-04-12", "description": "Withdrawal", "amount": -300.00 }, { "date": "2024-04-15", "description": "Interest", "amount": 10.00 }, { "date": "2024-04-16", "description": "Deposit", "amount": 200.00 }, { "date": "2024-04-18", "description": "Transfer to Chequing", "amount": -500.00 } ] } }';

  TransactionScreen({required this.accountType});

  @override
  Widget build(BuildContext context) {
    Map transactions = json.decode(transactionsJson)['transactions'];
    List transactionList = transactions[accountType] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text('$accountType Transactions')),
      body: ListView.builder(
        itemCount: transactionList.length,
        itemBuilder: (context, index) {
          var transaction = transactionList[index];
          return Card(
            child: ListTile(
              title: Text(transaction['description']),
              subtitle: Text(transaction['date']),
              trailing: Text('\$${transaction['amount']}',
                style: TextStyle(
                  color: transaction['amount'] < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}
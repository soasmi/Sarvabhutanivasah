import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/expense_service.dart';
import '../../../shared/widgets/app_drawer.dart';
import '../../../core/constants/app_colors.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ExpenseService _expenseService = ExpenseService();
  List<Map<String, dynamic>> _expenses = [];
  double _totalExpenses = 0.0;
  bool _isLoading = true;

  final _formKey = GlobalKey<FormState>();
  final _payeeController = TextEditingController();
  final _purposeController = TextEditingController();
  final _amountController = TextEditingController();
  String _paymentMode = 'Cash';
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() => _isLoading = true);
    try {
      final data = await _expenseService.fetchExpenses();
      double total = 0;
      for (var e in data) {
        total += double.parse(e['amount'].toString());
      }
      setState(() {
        _expenses = data;
        _totalExpenses = total;
      });
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addExpense() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isAdding = true);
    try {
      await _expenseService.addExpense(
        payee: _payeeController.text,
        purpose: _purposeController.text,
        amount: double.parse(_amountController.text),
        paymentMode: _paymentMode,
      );
      _payeeController.clear();
      _purposeController.clear();
      _amountController.clear();
      _paymentMode = 'Cash';
      await _loadExpenses();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isAdding = false);
    }
  }

  @override
  void dispose() {
    _payeeController.dispose();
    _purposeController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Expenses')),
      backgroundColor: AppColors.background,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildAddExpenseForm(),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Recent Expenses', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.primaryButton, fontWeight: FontWeight.bold)),
                      Text('Total: ₹${_totalExpenses.toStringAsFixed(0)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.red, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.divider)),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          child: DataTable(
                            headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryButton),
                            columns: const [
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Payee')),
                              DataColumn(label: Text('Purpose')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('Mode')),
                            ],
                            rows: _expenses.map((e) {
                              final date = DateTime.parse(e['created_at']).toLocal();
                              return DataRow(
                                cells: [
                                  DataCell(Text(DateFormat('MMM dd, yyyy').format(date))),
                                  DataCell(Text(e['payee'])),
                                  DataCell(Text(e['purpose'] ?? '')),
                                  DataCell(Text('₹${e['amount']}')),
                                  DataCell(Text(e['payment_mode'])),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildAddExpenseForm() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.divider)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            crossAxisAlignment: WrapCrossAlignment.end,
            children: [
              SizedBox(
                width: 250,
                child: TextFormField(
                  controller: _payeeController,
                  decoration: const InputDecoration(labelText: 'Payee', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              ),
              SizedBox(
                width: 200,
                child: TextFormField(
                  controller: _purposeController,
                  decoration: const InputDecoration(labelText: 'Purpose', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              ),
              SizedBox(
                width: 150,
                child: TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
              ),
              SizedBox(
                width: 150,
                child: DropdownButtonFormField<String>(
                  value: _paymentMode,
                  decoration: const InputDecoration(labelText: 'Mode', border: OutlineInputBorder()),
                  items: ['Cash', 'Online'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => _paymentMode = v!),
                ),
              ),
              SizedBox(
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isAdding ? null : _addExpense,
                  icon: _isAdding ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Icon(Icons.add),
                  label: const Text('Add Expense'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

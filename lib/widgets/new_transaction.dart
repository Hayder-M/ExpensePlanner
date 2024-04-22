import 'dart:io';
import 'package:expense_planner/widgets/adaptive_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  /*String titleInput;
    String amountInput;*/
  final _titleInputController = TextEditingController();

  final _amountInputController = TextEditingController();

  late DateTime _selectedDate = DateTime.now();

  void submitData() {
    if (_amountInputController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleInputController.text;
    final enteredAmount = double.parse(_amountInputController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    } // lehna golna ken enteredTitle feregh wala enteredAmount <=0 il ne vas pas executer le code apres
    // ma3neha l addTx mch bch yaamlelha execution
    widget.addTx(enteredTitle, enteredAmount, _selectedDate);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2024),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10), //hne gotlo tekho l bottom w tzido 10
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [   
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                /*onChanged: (val) {
                        titleInput = val;
                      },*/
                controller: _titleInputController,
                onSubmitted: (_) => submitData,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                /*onChanged: (val) {
                        amountInput = val;
                      },*/
                controller: _amountInputController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen !'
                          : 'Picked Date : ${DateFormat.yMd().format(_selectedDate)}'),
                    ),
                    AdaptiveFlatButton(text:'Choose Date',handler:_presentDatePicker)
                  ],
                ),
              ),
              ElevatedButton(
                child: Text(
                  'Add Transaction',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/models/walet.dart';
import 'package:expenditure_management/page/add_spending/widget/input_money.dart';
import 'package:expenditure_management/page/login/widget/input_text.dart';
import 'package:expenditure_management/repository/wallet_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AddEditWalletPage extends StatefulWidget {
  final Wallet? wallet;

  const AddEditWalletPage({
    super.key,
    this.wallet,
  });

  @override
  State<AddEditWalletPage> createState() => _AddEditWalletPageState();
}

class _AddEditWalletPageState extends State<AddEditWalletPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController moneyController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    moneyController.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.wallet != null) {
      nameController.text = widget.wallet!.name;
      moneyController.text = NumberFormat.currency(locale: "vi_VI")
          .format(widget.wallet!.money.abs());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(widget.wallet == null ? 'Add Wallet' : 'Edit Wallet'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              if (widget.wallet == null) {
                String name = nameController.text.trim();
                String moneyString =
                    moneyController.text.replaceAll(RegExp(r'[^0-9]'), '');

                int money = int.parse(moneyString);
                Wallet? wallet =
                    await WalletRepository().createNewWallet(name, money);
                Navigator.of(context).pop(wallet);
              } else {
                // String name = nameController.text.trim();
                // String moneyString =
                //     moneyController.text.replaceAll(RegExp(r'[^0-9]'), '');

                // int money = int.parse(moneyString);
                // Wallet? wallet =
                //     await WalletRepository().(name, money);
                // Navigator.of(context).pop(wallet);
              }
            },
            child: Text(
              widget.wallet == null ? 'Add' : 'Save',
              style: AppStyles.p,
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.close_outlined, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                  child: InputText(
                    hint: 'Name of Wallet',
                    validator: 1,
                    controller: nameController,
                    inputType: TextInputType.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  height: 100,
                  // color: Colors.white,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.black38,
                          ),
                        ),
                        child: const Text(
                          'VND',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: moneyController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[\\s0-9a-zA-Z]")),
                            CurrencyTextInputFormatter(locale: "vi", symbol: '')
                          ],
                          textAlign: TextAlign.right,
                          style: const TextStyle(fontSize: 20),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintText: "100.000 VND",
                            hintStyle: const TextStyle(fontSize: 20),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

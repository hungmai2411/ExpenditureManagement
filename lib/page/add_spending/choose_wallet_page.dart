import 'package:expenditure_management/constants/app_styles.dart';
import 'package:expenditure_management/models/walet.dart';
import 'package:expenditure_management/page/main/profile/add_edit_wallet_page.dart';
import 'package:expenditure_management/repository/wallet_repository.dart';
import 'package:expenditure_management/setting/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChooseWalletPage extends StatefulWidget {
  final Function(int idWallet, String nameWallet) action;

  const ChooseWalletPage({
    super.key,
    required this.action,
  });

  @override
  State<ChooseWalletPage> createState() => _ChooseWalletPageState();
}

class _ChooseWalletPageState extends State<ChooseWalletPage> {
  List<Wallet>? wallets;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWallets();
  }

  void getWallets() async {
    wallets = await WalletRepository().getAllWalletByUser();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: const Text('Ví của tôi'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () async {
              var result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const AddEditWalletPage(),
                ),
              );
              if (result != null) {
                wallets!.add(result);
                setState(() {});
              }
              //await addingSpending();
            },
            child: Text(
              'Thêm',
              style: AppStyles.p,
            ),
          )
        ],
        leading: IconButton(
          icon: const Icon(Icons.close_outlined, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
        // bottom: PreferredSize(
        //   preferredSize: const Size.fromHeight(100),
        //   child: InputMoney(controller: _money),
        // ),
      ),
      body: wallets == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemBuilder: (context, index) {
                return itemWallet(wallets![index]);
              },
              itemCount: wallets!.length,
            ),
    );
  }

  Widget itemWallet(Wallet wallet) {
    return InkWell(
      onTap: () {
        widget.action(
          wallet.id,
          wallet.name,
        );
        Navigator.pop(context);
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20,
          top: 10,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 43, 8, 123),
                borderRadius: BorderRadius.circular(90),
              ),
              padding: const EdgeInsets.all(10),
              child: const Icon(Icons.wallet_outlined, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  NumberFormat.currency(locale: "vi_VI").format(wallet.money),
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios_outlined)
          ],
        ),
      ),
    );
  }
}

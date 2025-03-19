import 'package:flutter/material.dart';

import '../../../common/widgets/sign_out_button.dart';

class VendorProfilePage extends StatelessWidget {
  const VendorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Vendor Page'),
        actions: [
          const SignOutButton(), // Thêm nút đăng xuất vào AppBar
        ],
      ),
      body: const Center(
        child: Text('Welcome, Vendor!'),
      ),
    );
  }
}

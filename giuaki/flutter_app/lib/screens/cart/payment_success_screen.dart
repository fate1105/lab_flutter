import 'package:flutter/material.dart';

class PaymentSuccessScreen extends StatelessWidget {
  const PaymentSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Hoạt họa vòng tròn check xanh lá cây đẹp mắt
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/images/check.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Tiêu đề lớn
              const Text(
                'Thanh Toán Thành Công!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              // Nội dung cảm ơn
              const Text(
                'Cảm ơn quý khách đã tin tưởng và ủng hộ chúng tôi. Đơn hàng của bạn đang được chế biến nóng hổi và sẽ sớm được giao tới địa chỉ của bạn.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // Thẻ thông tin đơn hàng giả lập rất sinh động
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildOrderRow('Mã đơn hàng:', '#CG-829471', isBold: true),
                    const Divider(height: 24),
                    _buildOrderRow('Phương thức:', 'Thẻ tín dụng / Ví điện tử'),
                    const SizedBox(height: 8),
                    _buildOrderRow('Trạng thái:', 'Đang chuẩn bị món ăn', valueColor: Colors.deepOrange),
                    const SizedBox(height: 8),
                    _buildOrderRow('Thời gian giao dự kiến:', '25 - 35 phút', valueColor: Colors.green),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Nút quay lại trang chủ
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Trở lại màn hình chính của ứng dụng
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                  ),
                  icon: const Icon(Icons.home_rounded),
                  label: const Text(
                    'QUAY LẠI TRANG CHỦ',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black87,
            fontWeight: isBold || valueColor != null ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

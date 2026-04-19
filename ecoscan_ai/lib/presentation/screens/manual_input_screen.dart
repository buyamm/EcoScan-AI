import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/scan/scan_bloc.dart';

class ManualInputScreen extends StatefulWidget {
  const ManualInputScreen({super.key});

  @override
  State<ManualInputScreen> createState() => _ManualInputScreenState();
}

class _ManualInputScreenState extends State<ManualInputScreen> {
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final barcode = _controller.text.trim();
      context.read<ScanBloc>().add(ManualBarcodeEntered(barcode));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScanBloc, ScanState>(
      listener: (context, state) {
        if (state is ScanLoading) {
          context.push('/scan/loading', extra: state.barcode);
        } else if (state is ScanSuccess) {
          context.push('/product/found', extra: state.product);
        } else if (state is ScanError &&
            state.type == ScanErrorType.productNotFound) {
          context.push('/product/not-found', extra: state.barcode);
        } else if (state is ScanError &&
            state.type == ScanErrorType.networkError) {
          context.push('/error/network');
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Nhập mã vạch thủ công')),
        body: Padding(
          padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + MediaQuery.of(context).viewPadding.bottom),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nhập mã vạch sản phẩm',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Nhập 8–14 ký tự số từ mã vạch hoặc QR code trên sản phẩm.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(14),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'Mã vạch',
                    hintText: 'VD: 8934673669006',
                    prefixIcon: Icon(Icons.qr_code),
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.search,
                  onFieldSubmitted: (_) => _submit(),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Vui lòng nhập mã vạch';
                    }
                    final len = v.trim().length;
                    if (len < 8 || len > 14) {
                      return 'Mã vạch phải từ 8 đến 14 ký tự';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.search),
                    label: const Text('Tra cứu sản phẩm'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.push('/scan/ocr'),
                    icon: const Icon(Icons.text_fields),
                    label: const Text('Quét nhãn OCR thay thế'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

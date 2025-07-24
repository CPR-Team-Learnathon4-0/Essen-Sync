import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class DisclaimerModal extends StatefulWidget {
  final VoidCallback onAccepted;

  const DisclaimerModal({super.key, required this.onAccepted});

  @override
  State<DisclaimerModal> createState() => _DisclaimerModalState();
}

class _DisclaimerModalState extends State<DisclaimerModal> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // Prevent dismissal
      child: AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red.shade600, size: 28),
            const SizedBox(width: 8),
            const Text(
              'Important Disclaimer',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'This application is for training purposes only on a CPR manikin. It must NEVER be used on a real person during a medical emergency. It is not a medical device and does not provide medical advice.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Key Points:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              _buildBulletPoint('Use only with CPR training manikins'),
              _buildBulletPoint('Not for use on real people'),
              _buildBulletPoint('Not a medical device'),
              _buildBulletPoint('Call emergency services (112) in real emergencies'),
              _buildBulletPoint('Seek proper CPR certification from qualified instructors'),
              const SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: (value) {
                      setState(() {
                        _isChecked = value ?? false;
                      });
                    },
                    activeColor: Colors.red.shade600,
                  ),
                  const Expanded(
                    child: Text(
                      'I understand and agree to these terms',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: _isChecked ? () async {
              await StorageService.setDisclaimerAccepted(true);
              Navigator.of(context).pop();
              widget.onAccepted();
            } : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
            ),
            child: const Text('I Agree'),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: TextStyle(color: Colors.red.shade600, fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
} 
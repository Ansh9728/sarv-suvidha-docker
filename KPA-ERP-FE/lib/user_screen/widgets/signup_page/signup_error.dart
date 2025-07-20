import 'package:flutter/material.dart';

// For the dialog display
void showErrorDialog(BuildContext context, Map<String, dynamic> errorDetails) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SignupStatusWidget(errorDetails: errorDetails),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'OK',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class SignupStatusWidget extends StatelessWidget {
  final Map<String, dynamic> errorDetails;

  const SignupStatusWidget({Key? key, required this.errorDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                const SizedBox(width: 6),
                Text(
                  'Request Error',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Phone status
            if (errorDetails.containsKey('phone'))
              _buildStatusItem(
                title: 'Phone Number',
                status: errorDetails['phone']['status'],
                message: errorDetails['phone']['message'],
              ),
            if (errorDetails.containsKey('phone')) const SizedBox(height: 6),

            // WhatsApp status
            if (errorDetails.containsKey('whatsapp'))
              _buildStatusItem(
                title: 'WhatsApp Number',
                status: errorDetails['whatsapp']['status'],
                message: errorDetails['whatsapp']['message'],
              ),
            if (errorDetails.containsKey('whatsapp')) const SizedBox(height: 6),

            // Email status
            if (errorDetails.containsKey('email'))
              _buildStatusItem(
                title: 'Email ID',
                status: errorDetails['email']['status'],
                message: errorDetails['email']['message'],
              ),
            if (errorDetails.containsKey('email')) const SizedBox(height: 6),

            // EmpNumber status
            if (errorDetails.containsKey('emp_number'))
              _buildStatusItem(
                title: 'Emp Number',
                status: errorDetails['emp_number']['status'],
                message: errorDetails['emp_number']['message'],
              ),
            if (errorDetails.containsKey('emp_number'))
              const SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Text(
                'Please update the information marked with a red cross and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required String title,
    required String status,
    required String message,
  }) {
    final isNew = status == 'new';
    final backgroundColor = isNew 
        ? const Color(0xFFECF8EC) // Light green background
        : const Color(0xFFFCEAEA); // Light red background
    final statusColor = isNew ? Colors.green : Colors.red;
    final statusText = _getStatusText(status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isNew 
                  ? Colors.green.withOpacity(0.2)
                  : Colors.red.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                isNew ? Icons.check : Icons.close,
                color: statusColor,
                size: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isNew 
                        ? Colors.green.withOpacity(0.2)
                        : Colors.red.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'new':
        return 'New';
      case 'taken':
        return 'Already Taken';
      case 'requested':
        return 'Already Requested';
      default:
        return 'Unknown';
    }
  }
}
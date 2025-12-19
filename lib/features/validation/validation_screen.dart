import 'package:picroper/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:io'; // Import for File class
import 'package:picroper/config/app_colors.dart';
import 'package:picroper/config/app_text_styles.dart';

class ValidationScreen extends StatefulWidget {
  final String imagePath;
  final double widthCm;
  final double heightCm;

  const ValidationScreen({
    super.key,
    required this.imagePath,
    required this.widthCm,
    required this.heightCm,
  });

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  int _quantity = 1;
  bool _isXpressDelivery = false;
  String _support = 'Papier Premium'; // Default support
  String _frame = 'Bords Blanche Élité'; // Default frame

  // Placeholder for price calculation
  double get _unitPrice {
    // This would be dynamic based on size, support, frame, etc.
    return 1500.0; // Example price in Fcfa
  }

  double get _totalAmount {
    double total = _unitPrice * _quantity;
    if (_isXpressDelivery) {
      total += 500; // Example Xpress delivery fee
    }
    return total;
  }

  Future<bool?> _showDeliveryDetailsPopup() async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController cityController = TextEditingController();
        final TextEditingController neighborhoodController = TextEditingController();
        final TextEditingController descriptionController = TextEditingController();
        final TextEditingController phone1Controller = TextEditingController();
        final TextEditingController phone2Controller = TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.zero),
          ),
          title: Text(
            'Détails de livraison',
            style: AppTextStyles.headline2.copyWith(color: AppColors.primary),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(labelText: 'Ville'),
                ),
                TextField(
                  controller: neighborhoodController,
                  decoration: InputDecoration(labelText: 'Quartier'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Description (Précisions)'),
                  maxLines: 3,
                ),
                TextField(
                  controller: phone1Controller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Numéro de téléphone (WhatsApp préféré)'),
                ),
                TextField(
                  controller: phone2Controller,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Autre numéro à contacter'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false on cancel
              },
            ),
            ElevatedButton(
              child: Text('Confirmer'),
              onPressed: () {
                // Here you would typically save these details
                print('Delivery details: ${cityController.text}, ${neighborhoodController.text}, ${phone1Controller.text}');
                Navigator.of(context).pop(true); // Return true on confirm
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Validation de commande',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Preview and Filename
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: ExtendedImage.file(File(widget.imagePath)).image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.imagePath.split('/').last, // Display filename
                    style: AppTextStyles.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Caractéristiques Block
            Text(
              'Caractéristiques',
              style: AppTextStyles.headline2,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCharacteristicRow('Format:', '${widget.widthCm.toStringAsFixed(1)} x ${widget.heightCm.toStringAsFixed(1)} cm'),
                    _buildCharacteristicRow('Support:', _support),
                    _buildCharacteristicRow('Cadre:', _frame),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Option to modify characteristics
                          // This could navigate to a settings screen or show a dialog
                        },
                        child: const Text('Modifier'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Détails du prix Block
            Text(
              'Détails du prix',
              style: AppTextStyles.headline2,
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPriceRow('Prix unitaire:', '${_unitPrice.toStringAsFixed(0)} Fcfa'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Quantité:', style: AppTextStyles.bodyText1),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () {
                                setState(() {
                                  if (_quantity > 1) _quantity--;
                                });
                              },
                            ),
                            Text('$_quantity', style: AppTextStyles.bodyText1),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Option Xpress:', style: AppTextStyles.bodyText1),
                        Switch(
                          value: _isXpressDelivery,
                          onChanged: (bool value) {
                            setState(() {
                              _isXpressDelivery = value;
                              // Removed _showDeliveryDetailsPopup() here
                            });
                          },
                        ),
                      ],
                    ),
                    const Divider(),
                    _buildPriceRow('Total:', '${_totalAmount.toStringAsFixed(0)} Fcfa', isTotal: true),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Confirm and Pay Button
            ElevatedButton(
              onPressed: () async {
                final bool? confirmed = await _showDeliveryDetailsPopup();
                if (confirmed == true) {
                  context.pushNamed(
                    'confirmation',
                    extra: {
                      'orderNumber': 'CMD-${DateTime.now().millisecondsSinceEpoch}', // Placeholder order number
                      'imagePath': widget.imagePath,
                      'format': '${widget.widthCm.toStringAsFixed(1)} x ${widget.heightCm.toStringAsFixed(1)} cm',
                      'support': _support,
                      'frame': _frame,
                      'quantity': _quantity,
                      'totalAmount': _totalAmount,
                    },
                  );
                }
              },
              child: const Text('Confirmer et Payer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharacteristicRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodyText2.copyWith(fontWeight: FontWeight.bold)),
          Text(value, style: AppTextStyles.bodyText2),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? AppTextStyles.headline2.copyWith(color: AppColors.primary)
                : AppTextStyles.bodyText1,
          ),
          Text(
            value,
            style: isTotal
                ? AppTextStyles.headline2.copyWith(color: AppColors.primary)
                : AppTextStyles.bodyText1,
          ),
        ],
      ),
    );
  }
}

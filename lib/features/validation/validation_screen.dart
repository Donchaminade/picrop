import 'dart:ui'; // Required for ImageFilter
import 'package:picroper/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:io';
import 'package:picroper/config/app_colors.dart';
import 'package:picroper/config/app_text_styles.dart';

class ValidationScreen extends StatefulWidget {
  final String imagePath;
  final double widthCm;
  final double heightCm;
  final String? imageQuality;

  const ValidationScreen({
    super.key,
    required this.imagePath,
    required this.widthCm,
    required this.heightCm,
    this.imageQuality,
  });

  @override
  State<ValidationScreen> createState() => _ValidationScreenState();
}

class _ValidationScreenState extends State<ValidationScreen> {
  int _quantity = 1;
  bool _isXpressDelivery = false;
  String _support = 'Papier Premium';
  String _frame = 'Bords Blanche Élité';

  double get _unitPrice {
    return 1500.0;
  }

  double get _totalAmount {
    double total = _unitPrice * _quantity;
    if (_isXpressDelivery) {
      total += 1500;
    }
    return total;
  }

  Future<Map<String, String>?> _showDeliveryDetailsPopup() async {
    final List<String> _togoCities = [
      'Lomé',
      'Kara',
      'Sokodé',
      'Kpalimé',
      'Atakpamé',
      'Dapaong',
      'Tsévié',
      'Aného',
      'Mango',
      'Bafilo',
      'Niamtougou',
      'Badou',
    ];

    TextEditingController _cityInputController = TextEditingController(text: 'Lomé'); // Default city
    TextEditingController neighborhoodController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController phone1Controller = TextEditingController();
    TextEditingController phone2Controller = TextEditingController();

    final result = await showModalBottomSheet<Map<String, String>?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: AppColors.surface.withOpacity(0.8),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              border: Border.all(color: AppColors.primary.withOpacity(0.5), width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Détails de livraison',
                        style: AppTextStyles.headline2.copyWith(color: AppColors.primary),
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              RawAutocomplete<String>(
                                optionsBuilder: (TextEditingValue textEditingValue) {
                                  if (textEditingValue.text == '') {
                                    return const Iterable<String>.empty();
                                  }
                                  return _togoCities.where((String option) {
                                    return option.toLowerCase().contains(textEditingValue.text.toLowerCase());
                                  });
                                },
                                fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                                  _cityInputController = textEditingController; // Keep controller in sync
                                  return TextField(
                                    controller: textEditingController,
                                    focusNode: focusNode,
                                    decoration: InputDecoration(
                                      labelText: 'Ville',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppColors.primary),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                      ),
                                    ),
                                  );
                                },
                                optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                                  return Align(
                                    alignment: Alignment.topLeft,
                                    child: Material(
                                      elevation: 4.0,
                                      child: SizedBox(
                                        height: 200.0,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          itemCount: options.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            final String option = options.elementAt(index);
                                            return GestureDetector(
                                              onTap: () {
                                                onSelected(option);
                                              },
                                              child: ListTile(
                                                title: Text(option),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                onSelected: (String selection) {
                                  _cityInputController.text = selection; // Update text field on selection
                                },
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: neighborhoodController,
                                decoration: InputDecoration(
                                  labelText: 'Quartier',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: descriptionController,
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Description (Précisions)',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: phone1Controller,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Numéro WhatsApp',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: phone2Controller,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  labelText: 'Autre numéro',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: AppColors.primary, width: 2),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            child: const Text('Annuler'),
                            onPressed: () {
                              Navigator.of(context).pop(null);
                            },
                          ),
                          ElevatedButton(
                            child: const Text('Confirmer'),
                            onPressed: () {
                              Navigator.of(context).pop({
                                'city': _cityInputController.text,
                                'neighborhood': neighborhoodController.text,
                                'description': descriptionController.text,
                                'phone1': phone1Controller.text,
                                'phone2': phone2Controller.text,
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
    _cityInputController.dispose();
    neighborhoodController.dispose();
    descriptionController.dispose();
    phone1Controller.dispose();
    phone2Controller.dispose();
    return result;
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
                    widget.imagePath.split('/').last,
                    style: AppTextStyles.bodyText1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Text(
              'Caractéristiques',
              style: AppTextStyles.headline2,
            ),
            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Card(
                  color: const Color.fromARGB(211, 255, 255, 255), // Make card transparent to show blurred background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildCharacteristicRow('Format:', '${widget.widthCm.toStringAsFixed(1)} x ${widget.heightCm.toStringAsFixed(1)} cm'),
                        if (widget.imageQuality != null)
                          _buildCharacteristicRow('Qualité:', widget.imageQuality!),
                        _buildCharacteristicRow('Support:', _support),
                        _buildCharacteristicRow('Cadre:', _frame),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Modifier'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Détails du prix',
              style: AppTextStyles.headline2,
            ),
            const SizedBox(height: 8),

            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Card(
                  color: const Color.fromARGB(216, 255, 255, 255), // Make card transparent to show blurred background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
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
                                setState(() => _isXpressDelivery = value);
                              },
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: Text(
                            'Livraison rapide en 24-48h pour 1500 Fcfa.',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.primaryLight,
                            ),
                          ),
                        ),
                        const Divider(),
                        _buildPriceRow(
                          'Total:',
                          '${_totalAmount.toStringAsFixed(0)} Fcfa',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: () async {
                final Map<String, String>? deliveryDetails = await _showDeliveryDetailsPopup();
                if (deliveryDetails != null) {
                  // Now use the deliveryDetails map to navigate
                  context.pushNamed(
                    'confirmation',
                    extra: {
                      'orderNumber': 'CMD-${DateTime.now().millisecondsSinceEpoch}',
                      'imagePath': widget.imagePath,
                      'format': '${widget.widthCm.toStringAsFixed(1)} x ${widget.heightCm.toStringAsFixed(1)} cm',
                      'support': _support,
                      'frame': _frame,
                      'quantity': _quantity,
                      'totalAmount': _totalAmount,
                      'deliveryCity': deliveryDetails['city'], // Pass city
                      'deliveryNeighborhood': deliveryDetails['neighborhood'], // Pass neighborhood
                      'deliveryDescription': deliveryDetails['description'], // Pass description
                      'deliveryPhone1': deliveryDetails['phone1'], // Pass phone1
                      'deliveryPhone2': deliveryDetails['phone2'], // Pass phone2
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

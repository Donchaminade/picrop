// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:extended_image/extended_image.dart';
// import 'dart:io'; // Import for File class
// import 'package:picroper/config/app_colors.dart';
// import 'package:picroper/config/app_text_styles.dart';

// class ConfirmationScreen extends StatelessWidget {
//   final String orderNumber;
//   final String? imagePath;
//   final String format;
//   final String support;
//   final String frame;
//   final int quantity;
//   final double totalAmount;

//   const ConfirmationScreen({
//     super.key,
//     required this.orderNumber,
//     this.imagePath,
//     required this.format,
//     required this.support,
//     required this.frame,
//     required this.quantity,
//     required this.totalAmount,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Confirmation de commande'),
//         backgroundColor: AppColors.background,
//         automaticallyImplyLeading: false, // Hide back button
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Success Icon
//               const Icon(
//                 Icons.check_circle_rounded,
//                 color: AppColors.success, // Assuming a success color
//                 size: 100,
//               ),
//               const SizedBox(height: 24),

//               // Confirmation Message
//               Text(
//                 'Merci pour votre commande !',
//                 style: AppTextStyles.headline1.copyWith(color: AppColors.primary),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32),

//               // Order Details
//               Card(
//                 margin: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Order Number
//                       Text(
//                         'Numéro de commande: $orderNumber',
//                         style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 16), // Add spacing between order number and badge

//                       // "Confirmée" Badge
//                       Align(
//                         alignment: Alignment.centerLeft, // Align badge to the left
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: AppColors.success.withOpacity(0.2), // Fond vert air
//                             borderRadius: BorderRadius.circular(20),
//                           ),
                         
//                         ),
//                       ),
//                       const Divider(height: 24),
//                       Text(
//                         'Informations sur le produit:',
//                         style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (imagePath != null)
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 image: DecorationImage(
//                                   image: ExtendedImage.file(File(imagePath!)).image,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                             ),
//                           if (imagePath != null) const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text('Format: $format', style: AppTextStyles.bodyText2),
//                                 Text('Support: $support', style: AppTextStyles.bodyText2),
//                                 Text('Cadre: $frame', style: AppTextStyles.bodyText2),
//                                 Text('Quantité: $quantity', style: AppTextStyles.bodyText2),
//                                 Text('Total: ${totalAmount.toStringAsFixed(0)} Fcfa', style: AppTextStyles.bodyText2),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                       const Divider(height: 24),
//                       Row(
//                         children: [
//                           const Icon(Icons.delivery_dining, color: AppColors.primary), // Bus icon
//                           const SizedBox(width: 8),
//                           Text(
//                             'Date estimée de livraison: ${DateTime.now().add(const Duration(days: 3)).day}/${DateTime.now().add(const Duration(days: 3)).month}/${DateTime.now().add(const Duration(days: 3)).year}',
//                             style: AppTextStyles.bodyText1.copyWith(fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 32),

//               // Action Button
//               ElevatedButton(
//                 onPressed: () {
//                   context.go('/'); // Navigate back to home
//                 },
//                 child: const Text('Retour à l\'accueil'),
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   // Navigate to order history or display a message
//                   print('Consulter l\'historique des commandes');
//                 },
//                 child: const Text('Consulter l\'historique des commandes'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:picroper/shared/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_image/extended_image.dart';
import 'dart:io';
import 'package:picroper/config/app_colors.dart';
import 'package:picroper/config/app_text_styles.dart';

class ConfirmationScreen extends StatelessWidget {
  final String orderNumber;
  final String? imagePath;
  final String format;
  final String support;
  final String frame;
  final int quantity;
  final double totalAmount;

  const ConfirmationScreen({
    super.key,
    required this.orderNumber,
    this.imagePath,
    required this.format,
    required this.support,
    required this.frame,
    required this.quantity,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    final livraisonDate = DateTime.now().add(const Duration(days: 3));
    final livraisonLabel =
        "${livraisonDate.day}/${livraisonDate.month}/${livraisonDate.year}";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Confirmation de commande',
        // No leading widget (back button) for confirmation screen
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 90,
              ),
              const SizedBox(height: 18),
              Text(
                "Merci pour votre commande",
                style: AppTextStyles.headline1.copyWith(
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary, width: 1),
                ),
                child: Column(
                  children: [
                    Text(
                      "Ticket de commande",
                      style: AppTextStyles.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "#$orderNumber",
                      style: AppTextStyles.bodyText1.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const Divider(thickness: 1, height: 22),

                    if (imagePath != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: ExtendedImage.file(
                          File(imagePath!),
                          height: 160,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (imagePath != null) const SizedBox(height: 14),

                    _ticketRow("Format", format),
                    _ticketRow("Support", support),
                    _ticketRow("Cadre", frame),
                    _ticketRow("Quantité", "$quantity"),               
                    const Divider(thickness: 1, height: 26),

                    _ticketRow(
                      "Total TTC",
                      "${totalAmount.toStringAsFixed(0)} Fcfa",
                      highlight: true,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Commande confirmée",
                        style: AppTextStyles.bodyText2.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.delivery_dining, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    "Livraison estimée: $livraisonLabel",
                    style: AppTextStyles.bodyText1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              ElevatedButton(
                onPressed: () => context.go('/'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                ),
                child: Text(
                  "Retour à l'accueil",
                  style: AppTextStyles.button,
                ),
              ),

              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Historique
                },
                child: Text(
                  "Consulter l'historique des commandes",
                  style: AppTextStyles.bodyText2.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyText1,
          ),
          Text(
            value,
            style: AppTextStyles.bodyText1.copyWith(
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: highlight ? AppColors.primary : AppColors.text,
            ),
          ),
        ],
      ),
    );
  }
}


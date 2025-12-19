import 'package:flutter/material.dart';

class AppColors {
  // Couleur principale : bleu bouton / actions primaires
  static const Color primary = Color(0xFF2D74FF);     // Bleu principal
  static const Color primaryLight = Color(0xFF6AA3FF);
  static const Color primaryDark = Color(0xFF0049D1);

  // Vert utilisé dans la validation / états confirmés
  static const Color success = Color(0xFF2ECC71);     // Badge "Confirmée"
  static const Color successDark = Color(0xFF1A7A44); // Darker green for text

  // Rouge pour états d’erreur
  static const Color error = Color(0xFFEB5757);

  // Orange pour états d'avertissement / abordables
  static const Color warning = Color(0xFFFFC107);

  // Fond global très clair
  static const Color background = Color(0xFFFFFFFF);

  // Zones blanches (cartes, containers, slivers)
  static const Color surface = Color(0xFFFFFFFF);

  // Texte principal presque noir
  static const Color text = Color(0xFF1A1A1A);

  // Texte secondaire gris moyen
  static const Color textLight = Color(0xFF7C7C7C);

  // Gris pour arrière-plan blocs
  static const Color grey = Color(0xFFF6F6F6); // fond listes / sections
  static const Color darkGrey = Color(0xFFE0E0E0);

  // Bordures très claires
  static const Color border = Color(0xFFEDEDED);

  // Backgrounds neutres (icône upload, success check, etc.)
  static const Color softBlue = Color(0xFFEAF1FF);

  // Couleur de validation check
  static const Color infoBlue = Color(0xFF5B8CFF);
  
  // Couleurs d’accessibilité
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSecondary = Color(0xFF000000);
  static const Color onBackground = Color(0xFF000000);
  static const Color onSurface = Color(0xFF000000);
  static const Color onError = Color(0xFFFFFFFF);
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:extended_image/extended_image.dart';
import 'package:picroper/shared/widgets/custom_app_bar.dart';
import 'dart:io'; // Import for File class
import 'package:picroper/config/app_colors.dart';
import 'package:picroper/config/app_text_styles.dart';

class ResizeScreen extends StatefulWidget {
  final String imagePath;
  final double? initialWidthCm;
  final double? initialHeightCm;

  const ResizeScreen({
    super.key,
    required this.imagePath,
    this.initialWidthCm,
    this.initialHeightCm,
  });

  @override
  State<ResizeScreen> createState() => _ResizeScreenState();
}

class _ResizeScreenState extends State<ResizeScreen> {
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  double _currentWidthCm = 0.0;
  double _currentHeightCm = 0.0;
  // Placeholder for image quality/adaptability
  ImageQuality _imageQuality = ImageQuality.excellent;
  String _qualityMessage = "Excellent";

  double _minDimension = 1.0;
  double _maxDimension = 100.0; // Max 1 meter for print

  @override
  void initState() {
    super.initState();
    _currentWidthCm = widget.initialWidthCm ?? 21.0; // Default A4 width
    _currentHeightCm = widget.initialHeightCm ?? 29.7; // Default A4 height
    _widthController.text = _currentWidthCm.toStringAsFixed(1);
    _heightController.text = _currentHeightCm.toStringAsFixed(1);
    _updateQualityIndicator();

    _widthController.addListener(() {
      final newValue = double.tryParse(_widthController.text);
      if (newValue != null && newValue != _currentWidthCm) {
        setState(() {
          _currentWidthCm = newValue.clamp(_minDimension, _maxDimension);
          _updateQualityIndicator();
        });
      }
    });

    _heightController.addListener(() {
      final newValue = double.tryParse(_heightController.text);
      if (newValue != null && newValue != _currentHeightCm) {
        setState(() {
          _currentHeightCm = newValue.clamp(_minDimension, _maxDimension);
          _updateQualityIndicator();
        });
      }
    });
  }

  void _updateQualityIndicator() {
    if (_currentWidthCm < 10 || _currentHeightCm < 10) {
      _imageQuality = ImageQuality.bad;
      _qualityMessage = "Mauvais";
    } else if (_currentWidthCm < 20 || _currentHeightCm < 20) {
      _imageQuality = ImageQuality.acceptable;
      _qualityMessage = "Abordable";
    } else {
      _imageQuality = ImageQuality.excellent;
      _qualityMessage = "Excellent";
    }
    setState(() {});
  }

  Color _getQualityColor(ImageQuality quality) {
    switch (quality) {
      case ImageQuality.excellent:
        return AppColors.success;
      case ImageQuality.acceptable:
        return AppColors.warning;
      case ImageQuality.bad:
        return AppColors.error;
    }
  }

  Color _getQualityBorderColor(ImageQuality quality) {
    return _getQualityColor(quality);
  }

  void _showPreviewDialog() {
    // Calculate the aspect ratio for the image display in the preview
    final double aspectRatio = _currentWidthCm / _currentHeightCm;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Aperçu de l\'image', style: AppTextStyles.headline2),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Dimensions: ${_currentWidthCm.toStringAsFixed(1)}cm x ${_currentHeightCm.toStringAsFixed(1)}cm',
                  style: AppTextStyles.bodyText1,
                ),
                const SizedBox(height: 10),
                AspectRatio(
                  aspectRatio: aspectRatio.isFinite && aspectRatio > 0 ? aspectRatio : 1.0,
                  child: ExtendedImage.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover, // Use BoxFit.cover to show the cropped view consistently
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the aspect ratio for the image display
    final double aspectRatio = _currentWidthCm / _currentHeightCm;

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Redimensionnement de l\'image',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Quality Indicator
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getQualityColor(_imageQuality).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _qualityMessage,
                        style: AppTextStyles.bodyText2.copyWith(
                          color: _getQualityColor(_imageQuality),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image Display with Preview Button
                  Stack(
                    alignment: Alignment.topRight, // Position preview button top right
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _getQualityBorderColor(_imageQuality),
                            width: 3.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        // Use AspectRatio to enforce the desired dimensions, and BoxFit.cover for visual cropping
                        child: AspectRatio(
                          aspectRatio: aspectRatio.isFinite && aspectRatio > 0 ? aspectRatio : 1.0,
                          child: ExtendedImage.file(
                            fit: BoxFit.cover, // This will visually crop the image
                            filterQuality: FilterQuality.high,
                            File(widget.imagePath),
                            // height: MediaQuery.of(context).size.height * 0.4, // Removed fixed height due to AspectRatio
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton.icon( // Enlarged preview button
                          onPressed: _showPreviewDialog,
                          icon: const Icon(Icons.visibility, size: 28),
                          label: const Text('Aperçu', style: TextStyle(fontSize: 18)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary.withOpacity(0.8),
                            foregroundColor: AppColors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Dimensions Section
                  Text(
                    'Dimensions',
                    style: AppTextStyles.headline2,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _widthController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Largeur (cm)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _currentWidthCm = double.tryParse(value) ?? _currentWidthCm;
                              _updateQualityIndicator();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Hauteur (cm)',
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _currentHeightCm = double.tryParse(value) ?? _currentHeightCm;
                              _updateQualityIndicator();
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Sliders for width and height (replacing discrete buttons)
                  Column(
                    children: [
                      Text('Largeur: ${_currentWidthCm.toStringAsFixed(1)} cm', style: AppTextStyles.bodyText2),
                      Slider(
                        value: _currentWidthCm,
                        min: _minDimension,
                        max: _maxDimension,
                        divisions: ((_maxDimension - _minDimension) * 10).toInt(), // 1 decimal place
                        label: _currentWidthCm.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _currentWidthCm = value;
                            _widthController.text = value.toStringAsFixed(1);
                            _updateQualityIndicator();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Text('Hauteur: ${_currentHeightCm.toStringAsFixed(1)} cm', style: AppTextStyles.bodyText2),
                      Slider(
                        value: _currentHeightCm,
                        min: _minDimension,
                        max: _maxDimension,
                        divisions: ((_maxDimension - _minDimension) * 10).toInt(),
                        label: _currentHeightCm.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _currentHeightCm = value;
                            _heightController.text = value.toStringAsFixed(1);
                            _updateQualityIndicator();
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      context.pushNamed(
                        'validation',
                        extra: {
                          'imagePath': widget.imagePath,
                          'widthCm': _currentWidthCm,
                          'heightCm': _currentHeightCm,
                        },
                      );
                    },
                    child: const Text('Valider'),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Modifier'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }
}

enum ImageQuality { excellent, acceptable, bad }

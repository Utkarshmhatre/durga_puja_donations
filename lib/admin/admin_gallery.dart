import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/gallery_item.dart';
import '../services/data_service.dart';
import '../src/localization/app_localizations.dart';
import '../utils/theme.dart';

class AdminGalleryPage extends StatefulWidget {
  const AdminGalleryPage({super.key});

  @override
  State<AdminGalleryPage> createState() => _AdminGalleryPageState();
}

class _AdminGalleryPageState extends State<AdminGalleryPage>
    with TickerProviderStateMixin {
  String _selectedCategory = 'all';
  final ImagePicker _imagePicker = ImagePicker();
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeOut),
    );
    _fabController.forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<String?> _saveImageLocally(XFile image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final galleryDir = Directory('${directory.path}/gallery');
      if (!await galleryDir.exists()) {
        await galleryDir.create(recursive: true);
      }

      final fileName =
          'img_${DateTime.now().millisecondsSinceEpoch}.${image.path.split('.').last}';
      final savedPath = '${galleryDir.path}/$fileName';

      await File(image.path).copy(savedPath);
      return savedPath;
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }

  Future<void> _pickImage(
      ImageSource source, BuildContext dialogContext) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        Navigator.pop(dialogContext);
        _showImageDetailsDialog(image);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!
              .adminGalleryPickError(e.toString())),
          backgroundColor: AppTheme.accentRed,
        ),
      );
    }
  }

  void _showImageDetailsDialog(XFile image) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedCategory = 'general';
    bool isLoading = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: AppTheme.dynamicCardBg(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.accentGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.add_photo_alternate_rounded,
                  color: AppTheme.accentGreen,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                AppLocalizations.of(context)!.adminGalleryAddImageDetailsTitle,
                style: TextStyle(
                  color: AppTheme.dynamicTextPrimary(context),
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.file(
                    File(image.path),
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),

                // Title Field
                TextField(
                  controller: titleController,
                  style: TextStyle(
                      color: AppTheme.dynamicTextPrimary(context),
                      fontSize: 14),
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.adminGalleryFieldTitle,
                    labelStyle: TextStyle(
                        color: AppTheme.dynamicTextMuted(context),
                        fontSize: 13),
                    prefixIcon: Icon(Icons.title_rounded,
                        color: AppTheme.dynamicTextMuted(context), size: 20),
                    filled: true,
                    fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 14),

                // Description Field
                TextField(
                  controller: descController,
                  maxLines: 2,
                  style: TextStyle(
                      color: AppTheme.dynamicTextPrimary(context),
                      fontSize: 14),
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!
                        .adminGalleryFieldDescription,
                    labelStyle: TextStyle(
                        color: AppTheme.dynamicTextMuted(context),
                        fontSize: 13),
                    prefixIcon: Icon(Icons.description_rounded,
                        color: AppTheme.dynamicTextMuted(context), size: 20),
                    filled: true,
                    fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                ),
                const SizedBox(height: 14),

                // Category Dropdown
                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  dropdownColor: AppTheme.dynamicCardBg(context),
                  style: TextStyle(
                      color: AppTheme.dynamicTextPrimary(context),
                      fontSize: 14),
                  decoration: InputDecoration(
                    labelText:
                        AppLocalizations.of(context)!.adminGalleryFieldCategory,
                    labelStyle: TextStyle(
                        color: AppTheme.dynamicTextMuted(context),
                        fontSize: 13),
                    prefixIcon: Icon(Icons.category_rounded,
                        color: AppTheme.dynamicTextMuted(context), size: 20),
                    filled: true,
                    fillColor: AppTheme.dynamicOverlay(context, alpha: 0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  items: [
                    _buildDropdownItem('general',
                        AppLocalizations.of(context)!.categoryGeneral),
                    _buildDropdownItem(
                        'idol', AppLocalizations.of(context)!.categoryIdols),
                    _buildDropdownItem('celebration',
                        AppLocalizations.of(context)!.categoryCelebration),
                    _buildDropdownItem('cultural',
                        AppLocalizations.of(context)!.categoryCultural),
                    _buildDropdownItem('community',
                        AppLocalizations.of(context)!.categoryCommunity),
                  ],
                  onChanged: (value) {
                    setState(() => selectedCategory = value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: AppTheme.dynamicTextMuted(context)),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);

                      final savedPath = await _saveImageLocally(image);

                      if (savedPath != null) {
                        final item = GalleryItem(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          imageUrl: savedPath,
                          localPath: savedPath,
                          title: titleController.text.isNotEmpty
                              ? titleController.text
                              : null,
                          description: descController.text.isNotEmpty
                              ? descController.text
                              : null,
                          category: selectedCategory,
                          uploadedAt: DateTime.now(),
                          isLocal: true,
                        );

                        if (mounted) {
                          context.read<DataService>().addGalleryItem(item);
                          Navigator.pop(ctx);
                          HapticFeedback.mediumImpact();
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  const Icon(Icons.check_circle_rounded,
                                      color: Colors.white),
                                  const SizedBox(width: 10),
                                  Text(
                                    AppLocalizations.of(this.context)!
                                        .adminGalleryImageAddedSuccess,
                                    style: const TextStyle(),
                                  ),
                                ],
                              ),
                              backgroundColor: AppTheme.accentGreen,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                          );
                        }
                      } else {
                        setState(() => isLoading = false);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(
                            content: Text(AppLocalizations.of(this.context)!
                                .adminGalleryFailedToSave),
                            backgroundColor: AppTheme.accentRed,
                          ),
                        );
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accentGreen,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.adminGalleryAddImage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  DropdownMenuItem<String> _buildDropdownItem(String value, String label) {
    return DropdownMenuItem(
      value: value,
      child: Text(label,
          style: TextStyle(color: AppTheme.dynamicTextPrimary(context))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmall = size.width < 360;

    return Consumer<DataService>(
      builder: (context, dataService, child) {
        final items = dataService.getGalleryByCategory(_selectedCategory);

        return Stack(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.all(isSmall ? 16 : 24),
                    child: FadeInDown(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .adminGalleryTitle,
                                  style: TextStyle(
                                    fontSize: isSmall ? 24 : 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.dynamicTextPrimary(context),
                                  ),
                                ),
                              ),
                              _buildAddButton(isSmall),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: [
                                _buildCategoryChip(
                                    'all',
                                    AppLocalizations.of(context)!.categoryAll,
                                    isSmall),
                                _buildCategoryChip(
                                    'idol',
                                    AppLocalizations.of(context)!.categoryIdols,
                                    isSmall),
                                _buildCategoryChip(
                                    'celebration',
                                    AppLocalizations.of(context)!
                                        .categoryCelebration,
                                    isSmall),
                                _buildCategoryChip(
                                    'cultural',
                                    AppLocalizations.of(context)!
                                        .categoryCultural,
                                    isSmall),
                                _buildCategoryChip(
                                    'community',
                                    AppLocalizations.of(context)!
                                        .categoryCommunity,
                                    isSmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Gallery Grid
                  Expanded(
                    child: items.isEmpty
                        ? _buildEmptyState()
                        : GridView.builder(
                            padding: EdgeInsets.symmetric(
                                horizontal: isSmall ? 16 : 24),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: size.width > 800
                                  ? 4
                                  : (size.width > 500 ? 3 : 2),
                              crossAxisSpacing: isSmall ? 10 : 14,
                              mainAxisSpacing: isSmall ? 10 : 14,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return FadeInUp(
                                delay: Duration(milliseconds: (index % 6) * 50),
                                duration: const Duration(milliseconds: 400),
                                child:
                                    _buildGalleryItem(context, item, isSmall),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddButton(bool isSmall) {
    return ScaleTransition(
      scale: _fabAnimation,
      child: GestureDetector(
        onTap: () => _showImageSourceDialog(),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 12 : 16,
            vertical: isSmall ? 10 : 12,
          ),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppTheme.sacredGold.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.add_photo_alternate_rounded,
                color: Colors.white,
                size: isSmall ? 18 : 20,
              ),
              SizedBox(width: isSmall ? 6 : 8),
              Text(
                AppLocalizations.of(context)!.adminGalleryAddButton,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isSmall ? 12 : 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    HapticFeedback.lightImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.dynamicCardBg(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.dynamicDivider(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Add Image',
              style: TextStyle(
                color: AppTheme.dynamicTextPrimary(context),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose image source',
              style: TextStyle(
                color: AppTheme.dynamicTextMuted(context),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: _buildSourceOption(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    color: AppTheme.accentCyan,
                    onTap: () => _pickImage(ImageSource.camera, ctx),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSourceOption(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    color: AppTheme.primaryPurple,
                    onTap: () => _pickImage(ImageSource.gallery, ctx),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.dynamicTextPrimary(context),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String value, String label, bool isSmall) {
    final isSelected = _selectedCategory == value;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedCategory = value);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 12 : 16,
          vertical: isSmall ? 8 : 10,
        ),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.primaryGradient : null,
          color:
              isSelected ? null : AppTheme.dynamicOverlay(context, alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : AppTheme.dynamicDivider(context),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected ? Colors.white : AppTheme.dynamicTextMuted(context),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: isSmall ? 12 : 13,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.dynamicOverlay(context, alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.photo_library_outlined,
              size: 60,
              color: AppTheme.dynamicTextHint(context),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!.adminGalleryNoImagesFound,
            style: TextStyle(
              color: AppTheme.dynamicTextMuted(context),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context)!.adminGalleryTapToAdd,
            style: TextStyle(
              color: AppTheme.dynamicTextHint(context),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(
      BuildContext context, GalleryItem item, bool isSmall) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _showImagePreview(context, item);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.dynamicDivider(context)),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: item.isLocal
                      ? Image.file(
                          File(item.localPath!),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildImageError(),
                        )
                      : CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => _buildImagePlaceholder(),
                          errorWidget: (_, __, ___) => _buildImageError(),
                        ),
                ),

                // Gradient Overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(isSmall ? 8 : 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.85),
                          Colors.transparent,
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (item.title != null)
                          Text(
                            item.title!,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: isSmall ? 10 : 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.sacredGold.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item.category,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isSmall ? 8 : 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Menu Button
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'delete') {
                          _showDeleteDialog(context, item);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete_rounded,
                                  size: 18, color: AppTheme.accentRed),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: AppTheme.accentRed)),
                            ],
                          ),
                        ),
                      ],
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: Colors.white,
                          size: isSmall ? 16 : 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: AppTheme.cardBackground,
      child: const Center(
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }

  Widget _buildImageError() {
    return Container(
      color: AppTheme.cardBackground,
      child: const Icon(Icons.error_rounded, color: AppTheme.accentRed),
    );
  }

  void _showImagePreview(BuildContext context, GalleryItem item) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: InteractiveViewer(
                child: item.isLocal
                    ? Image.file(File(item.localPath!), fit: BoxFit.contain)
                    : CachedNetworkImage(
                        imageUrl: item.imageUrl, fit: BoxFit.contain),
              ),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, GalleryItem item) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.dynamicCardBg(context),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.accentRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_rounded,
                  color: AppTheme.accentRed, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              AppLocalizations.of(context)!.adminGalleryDeleteDialogTitle,
              style: TextStyle(
                  color: AppTheme.dynamicTextPrimary(context),
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Text(
          AppLocalizations.of(context)!.adminGalleryDeleteDialogMessage,
          style: TextStyle(color: AppTheme.dynamicTextSecondary(context)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: AppTheme.dynamicTextMuted(context))),
          ),
          ElevatedButton(
            onPressed: () async {
              // Delete local file if exists
              if (item.isLocal && item.localPath != null) {
                try {
                  await File(item.localPath!).delete();
                } catch (e) {
                  debugPrint('Error deleting file: $e');
                }
              }
              if (mounted) {
                context.read<DataService>().deleteGalleryItem(item.id);
                Navigator.pop(context);
                HapticFeedback.mediumImpact();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentRed,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

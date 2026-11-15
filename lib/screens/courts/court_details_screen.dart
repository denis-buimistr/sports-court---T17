import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../models/courts_model.dart';
import '../../models/slots_model.dart';
import '../../widgets/amenity_chip.dart';
import '../../widgets/app_card.dart';
import '../../widgets/bottom_action_bar.dart';
import '../../widgets/court_photo.dart';
import '../../widgets/error_view.dart';
import '../../widgets/info_row.dart';
import '../../widgets/section_title.dart';
import '../../widgets/sport_badge.dart';

class CourtDetailsScreen extends StatefulWidget {
  final String courtId;

  const CourtDetailsScreen({super.key, required this.courtId});

  @override
  State<CourtDetailsScreen> createState() => _CourtDetailsScreenState();
}

class _CourtDetailsScreenState extends State<CourtDetailsScreen> {
  static const _shadow = [Shadow(color: Colors.black54, blurRadius: 6)];

  bool _uploading = false; // ephemeral: only this button knows it

  // L5 task 7: gallery -> POST /files -> PUT /courts/{id}/image
  Future<void> _uploadPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600, // keeps the file well under the 5 MB server limit
      imageQuality: 85,
    );
    if (picked == null || !mounted) return; // the user closed the gallery

    setState(() => _uploading = true);
    final error = await context.read<CourtsModel>().uploadPhoto(widget.courtId, picked.path);
    if (!mounted) return;
    setState(() => _uploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error ?? 'Фото площадки загружено')),
    );
  }

  @override
  void initState() {
    super.initState();
    // the screen asks the model for its data, the model asks the repository
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SlotsModel>().load(widget.courtId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final courtsModel = context.watch<CourtsModel>();
    final slotsModel = context.watch<SlotsModel>();
    final court = courtsModel.byId(widget.courtId);

    if (court == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Площадка')),
        body: Center(
          child: courtsModel.isLoading
              ? const CircularProgressIndicator() // the list is still loading
              : const Text('Площадка не существует'), // loaded, no such id
        ),
      );
    }

    final price = court.pricePerHour.toStringAsFixed(0);
    final slotsForThisCourt = slotsModel.courtId == widget.courtId;

    final Widget slotsSummary;
    if (!slotsForThisCourt || slotsModel.isLoading) {
      slotsSummary = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    } else if (slotsModel.error != null) {
      slotsSummary = Text(
        'нет данных',
        style: theme.textTheme.titleMedium?.copyWith(color: scheme.error),
      );
    } else {
      slotsSummary = Text(
        '${slotsModel.freeCount} из ${slotsModel.slots.length} слотов',
        style: theme.textTheme.titleMedium,
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            // white text and icons over the photo; the collapsed bar is dark
            // green so they stay readable after scrolling too
            foregroundColor: Colors.white,
            backgroundColor: scheme.primary,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            actions: [
              IconButton(
                tooltip: 'Загрузить фото',
                onPressed: _uploading ? null : _uploadPhoto,
                icon: _uploading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.add_a_photo_outlined, shadows: _shadow),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                court.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  shadows: _shadow,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  CourtPhoto(court: court, height: 260),
                  // dark fade at the top (icons) and bottom (title):
                  // white text stays readable on any photo
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x66000000),
                          Color(0x00000000),
                          Color(0x00000000),
                          Color(0x99000000),
                        ],
                        stops: [0, 0.3, 0.55, 1],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SportBadge(court.sport),
                      const SizedBox(width: 10),
                      Icon(Icons.schedule, size: 16, color: scheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        'Открыто 08:00 – 22:00',
                        style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Цена за час',
                                style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '$price MDL',
                                style: theme.textTheme.headlineSmall?.copyWith(color: scheme.primary),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Сегодня свободно',
                              style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            slotsSummary,
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle('Удобства'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [for (final a in court.amenities) AmenityChip(a)],
                  ),
                  const SizedBox(height: 24),
                  const SectionTitle('Информация'),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        InfoRow(icon: Icons.location_on_outlined, label: 'Адрес', value: court.address),
                        const Divider(height: 1),
                        InfoRow(icon: Icons.map_outlined, label: 'Район', value: court.district),
                        const Divider(height: 1),
                        const InfoRow(icon: Icons.schedule, label: 'Пн–Пт', value: '08:00 – 22:00'),
                        const Divider(height: 1),
                        const InfoRow(icon: Icons.weekend_outlined, label: 'Сб–Вс', value: '09:00 – 23:00'),
                      ],
                    ),
                  ),
                  if (slotsForThisCourt && slotsModel.error != null) ...[
                    const SizedBox(height: 16),
                    ErrorView(
                      message: slotsModel.error!,
                      onRetry: () => context.read<SlotsModel>().load(widget.courtId),
                    ),
                  ],
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomActionBar(
        caption: 'Цена за час',
        value: '$price MDL',
        buttonLabel: 'Выбрать время',
        onPressed: () => context.push('/courts/${court.id}/slots'),
      ),
    );
  }
}
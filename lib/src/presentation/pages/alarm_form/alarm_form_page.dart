import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../viewmodels/alarm_form_viewmodel.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/injections/dependency_injection_simple.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_input_styles.dart';

/// Tela para criar/editar alarmes
class AlarmFormPage extends StatefulWidget {
  final LatLng? preselectedLocation;
  final LatLng? initialLocation;

  const AlarmFormPage({
    super.key,
    this.preselectedLocation,
    this.initialLocation,
  });

  @override
  State<AlarmFormPage> createState() => _AlarmFormPageState();
}

class _AlarmFormPageState extends State<AlarmFormPage> {
  late final AlarmFormViewModel _viewModel;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _viewModel = sl<AlarmFormViewModel>();
    _selectedLocation = widget.preselectedLocation ?? widget.initialLocation;

    if (_selectedLocation != null) {
      _viewModel.setLocation(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Configurar Alarme',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              return TextButton(
                onPressed: _viewModel.isFormValid ? _saveAlarm : null,
                child: _viewModel.isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Salvar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _viewModel,
        builder: (context, _) {
          if (_viewModel.isSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.of(context).pop(true);
            });
          }

          if (_viewModel.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_viewModel.errorMessage!),
                  backgroundColor: AppColors.error,
                ),
              );
            });
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mini mapa
                  _buildMiniMap(),

                  // Formulário
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Seção: Onde o alarme deve tocar?
                        const _SectionTitle(title: 'Onde o alarme deve tocar?'),
                        const SizedBox(height: AppSpacing.md),

                        // Campo de endereço
                        _buildAddressField(),

                        const SizedBox(height: AppSpacing.xl),

                        // Seção: Identifique seu alarme
                        const _SectionTitle(title: 'Identifique seu alarme'),
                        const SizedBox(height: AppSpacing.md),

                        // Nome do Alarme
                        Text(
                          'Nome do Alarme',
                          style: AppTextStyles.label
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _titleController,
                          style: AppTextStyles.bodyLarge,
                          decoration: AppInputStyles.defaultDecoration(
                            hint: 'Casa',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nome é obrigatório';
                            }
                            return null;
                          },
                          onChanged: _viewModel.setTitle,
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Descrição (Opcional)
                        Text(
                          'Descrição (Opcional)',
                          style: AppTextStyles.label
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        TextFormField(
                          controller: _descriptionController,
                          style: AppTextStyles.bodyLarge,
                          maxLines: 3,
                          decoration: AppInputStyles.defaultDecoration(
                            hint: 'Alarme para quando chegar em casa',
                          ),
                          onChanged: _viewModel.setDescription,
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Seção: Raio de Ativação
                        const _SectionTitle(title: 'Raio de Ativação'),
                        const SizedBox(height: AppSpacing.md),

                        Row(
                          children: [
                            Text(
                              'Distância',
                              style: AppTextStyles.label,
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.radiusSm),
                              ),
                              child: Text(
                                '${_viewModel.radius.toInt()}m',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: AppColors.accent,
                            inactiveTrackColor: AppColors.textHint,
                            thumbColor: Colors.white,
                            overlayColor: AppColors.accent.withOpacity(0.2),
                            trackHeight: 4,
                          ),
                          child: Slider(
                            value: _viewModel.radius,
                            min: AppConstants.minAlarmRadius,
                            max: AppConstants.maxAlarmRadius,
                            divisions: 19,
                            onChanged: _viewModel.setRadius,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xl),

                        // Seção: Como você quer ser alertado?
                        const _SectionTitle(
                            title: 'Como você quer ser alertado?'),
                        const SizedBox(height: AppSpacing.md),

                        // Som do Alarme
                        _SettingRow(
                          icon: Icons.music_note,
                          label: 'Som do Alarme',
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Padrão',
                                style: AppTextStyles.bodyMedium,
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppColors.iconSecondary,
                              ),
                            ],
                          ),
                          onTap: () {
                            // TODO: Abrir seletor de som
                          },
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Volume
                        Text(
                          'Volume',
                          style: AppTextStyles.label
                              .copyWith(color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: AppSpacing.sm),

                        Row(
                          children: [
                            const Icon(
                              Icons.volume_down,
                              color: AppColors.iconSecondary,
                              size: 20,
                            ),
                            Expanded(
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: AppColors.accent,
                                  inactiveTrackColor: AppColors.textHint,
                                  thumbColor: Colors.white,
                                  trackHeight: 4,
                                ),
                                child: Slider(
                                  value: _viewModel.volume.toDouble(),
                                  min: 0,
                                  max: 100,
                                  divisions: 10,
                                  onChanged: (value) =>
                                      _viewModel.setVolume(value.toInt()),
                                ),
                              ),
                            ),
                            Container(
                              width: 50,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${_viewModel.volume}%',
                                style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Vibração
                        _SettingSwitchRow(
                          label: 'Vibração',
                          value: _viewModel.vibrationEnabled,
                          onChanged: _viewModel.setVibrationEnabled,
                        ),

                        const SizedBox(height: AppSpacing.md),

                        // Manter a tela ligada
                        _SettingSwitchRow(
                          label: 'Manter a tela ligada',
                          value: false,
                          onChanged: (value) {
                            // TODO: Implementar
                          },
                        ),

                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMiniMap() {
    if (_selectedLocation == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 200,
      margin: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _selectedLocation!,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('selected'),
            position: _selectedLocation!,
            draggable: true,
            onDragEnd: _onMarkerDragEnd,
          ),
        },
        onTap: _onMapTapped,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.place, color: AppColors.iconSecondary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              _selectedLocation != null
                  ? 'Lat: ${_selectedLocation!.latitude.toStringAsFixed(4)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(4)}'
                  : 'Digite ou selecione no mapa',
              style: AppTextStyles.bodyMedium.copyWith(
                color: _selectedLocation != null
                    ? AppColors.textPrimary
                    : AppColors.textHint,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    _viewModel.setLocation(position.latitude, position.longitude);
  }

  void _onMarkerDragEnd(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    _viewModel.setLocation(position.latitude, position.longitude);
  }

  void _saveAlarm() {
    if (_formKey.currentState?.validate() ?? false) {
      _viewModel.createAlarm();
    }
  }
}

/// Título de seção
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Linha de configuração com tap
class _SettingRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.icon,
    required this.label,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.iconSecondary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyLarge,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

/// Linha de configuração com switch
class _SettingSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingSwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyLarge,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.active,
          ),
        ],
      ),
    );
  }
}

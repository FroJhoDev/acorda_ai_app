import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/theme/app_input_styles.dart';

/// Página de configuração de alarme
class AlarmConfigPage extends StatefulWidget {
  final LatLng? initialLocation;

  const AlarmConfigPage({
    super.key,
    this.initialLocation,
  });

  @override
  State<AlarmConfigPage> createState() => _AlarmConfigPageState();
}

class _AlarmConfigPageState extends State<AlarmConfigPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  double _radius = 500;
  int _volume = 75;
  bool _vibrationEnabled = true;
  bool _keepScreenOn = false;
  String _selectedSound = 'Padrão';

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Configurar Alarme'),
        actions: [
          TextButton(
            onPressed: _saveAlarm,
            child: const Text(
              'Salvar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mini mapa
            _buildMiniMap(),

            // Formulário
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Seção: Onde o alarme deve tocar?
                    _SectionTitle(
                      title: 'Onde o alarme deve tocar?',
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // Campo de endereço
                    TextFormField(
                      readOnly: true,
                      decoration: AppInputStyles.defaultDecoration(
                        hint: 'Digite ou selecione no mapa',
                        prefixIcon: const Icon(Icons.place),
                      ),
                      initialValue: 'Rua Fictícia, 123, Bairro Imaginário',
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Seção: Identifique seu alarme
                    _SectionTitle(title: 'Identifique seu alarme'),
                    const SizedBox(height: AppSpacing.md),

                    // Nome do Alarme
                    Text(
                      'Nome do Alarme',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _nameController,
                      decoration: AppInputStyles.defaultDecoration(
                        hint: 'Casa',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome é obrigatório';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Descrição (Opcional)
                    Text(
                      'Descrição (Opcional)',
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration: AppInputStyles.defaultDecoration(
                        hint: 'Alarme para quando chegar em casa',
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Seção: Raio de Ativação
                    _SectionTitle(title: 'Raio de Ativação'),
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
                            '${_radius.toInt()}m',
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
                        value: _radius,
                        min: 10,
                        max: 1000,
                        divisions: 99,
                        onChanged: (value) {
                          setState(() {
                            _radius = value;
                          });
                        },
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Seção: Como você quer ser alertado?
                    _SectionTitle(title: 'Como você quer ser alertado?'),
                    const SizedBox(height: AppSpacing.md),

                    // Som do Alarme
                    _SettingRow(
                      icon: Icons.music_note,
                      label: 'Som do Alarme',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _selectedSound,
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
                      style: AppTextStyles.label,
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    Row(
                      children: [
                        const Icon(
                          Icons.volume_down,
                          color: AppColors.iconSecondary,
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.accent,
                              inactiveTrackColor: AppColors.textHint,
                              thumbColor: Colors.white,
                            ),
                            child: Slider(
                              value: _volume.toDouble(),
                              min: 0,
                              max: 100,
                              onChanged: (value) {
                                setState(() {
                                  _volume = value.toInt();
                                });
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: 50,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '$_volume%',
                            style: const TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Vibração
                    _SettingSwitchRow(
                      label: 'Vibração',
                      value: _vibrationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _vibrationEnabled = value;
                        });
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Manter a tela ligada
                    _SettingSwitchRow(
                      label: 'Manter a tela ligada',
                      value: _keepScreenOn,
                      onChanged: (value) {
                        setState(() {
                          _keepScreenOn = value;
                        });
                      },
                    ),

                    const SizedBox(height: AppSpacing.xxl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniMap() {
    if (widget.initialLocation == null) {
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
          target: widget.initialLocation!,
          zoom: 15,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('selected'),
            position: widget.initialLocation!,
          ),
        },
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
        mapToolbarEnabled: false,
      ),
    );
  }

  void _saveAlarm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Salvar alarme
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Alarme salvo com sucesso!'),
          backgroundColor: AppColors.active,
        ),
      );
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

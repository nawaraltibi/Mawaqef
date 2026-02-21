import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../../../../core/styles/app_colors.dart';
import '../../../../core/styles/app_text_styles.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/vehicles_list_refresh_notifier.dart';
import '../../../../core/utils/navigation_utils.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/unified_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../data/repositories/auth_local_repository.dart';
import '../../../../core/injection/service_locator.dart';
import '../bloc/vehicles_bloc.dart';
import '../utils/vehicles_error_handler.dart';
import '../utils/color_name_mapper.dart';
import '../widgets/vehicle_form_fields.dart';
import '../../../vehicles/domain/usecases/get_vehicles_usecase.dart';
import '../../../vehicles/data/models/vehicle_model.dart';

/// Add Vehicle Screen (User side)
class AddVehicleScreen extends StatefulWidget {
  final String? source; // 'booking_pre_payment' or 'vehicles_list'
  final Map<String, dynamic>? returnData; // Data to pass back when navigating

  const AddVehicleScreen({super.key, this.source, this.returnData});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _typeController = TextEditingController();
  final _otherCarMakeController = TextEditingController();

  String? _selectedCarMake;
  Color? _selectedColor;

  @override
  void dispose() {
    _plateController.dispose();
    _typeController.dispose();
    _otherCarMakeController.dispose();
    super.dispose();
  }

  void _submit() {
    // Validate dropdowns first
    if (_selectedCarMake == null || _selectedCarMake!.isEmpty) {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        UnifiedSnackbar.error(
          context,
          message:
              '${l10n.vehiclesFormNameLabel} ${l10n.vehiclesErrorValidation.toLowerCase()}',
        );
      }
      return;
    }

    // Validate "Other" car make input if selected
    if (_selectedCarMake == 'Other') {
      if (_otherCarMakeController.text.trim().isEmpty) {
        final l10n = AppLocalizations.of(context);
        if (l10n != null) {
          UnifiedSnackbar.error(context, message: l10n.vehiclesErrorValidation);
        }
        return;
      }
    }

    if (_selectedColor == null) {
      final l10n = AppLocalizations.of(context);
      if (l10n != null) {
        UnifiedSnackbar.error(
          context,
          message:
              '${l10n.vehiclesFormColorLabel} ${l10n.vehiclesErrorValidation.toLowerCase()}',
        );
      }
      return;
    }

    // Validate text fields
    if (!_formKey.currentState!.validate()) return;

    // Determine car make: use "Other" input if selected, otherwise use dropdown value
    final carMake = _selectedCarMake == 'Other'
        ? _otherCarMakeController.text.trim()
        : _selectedCarMake!;

    // Convert Color to color name
    final colorName = ColorNameMapper.mapColorToName(_selectedColor!);

    context.read<VehiclesBloc>().add(
      AddVehicleRequested(
        platNumber: _plateController.text.trim(),
        carMake: carMake,
        carModel: _typeController.text.trim(),
        color: colorName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.vehiclesAddTitle,
          style: AppTextStyles.titleLarge(context),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppColors.border.withValues(alpha: 0.2),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: true,
        child: BlocConsumer<VehiclesBloc, VehiclesState>(
          listenWhen: (previous, current) =>
              current is VehicleActionSuccess ||
              current is VehicleActionFailure,
          listener: (context, state) async {
            if (state is VehicleActionSuccess) {
              UnifiedSnackbar.success(
                context,
                message: l10n.vehiclesSuccessAdded,
              );
              context.read<VehiclesBloc>().add(ResetVehiclesState());
              Future.delayed(const Duration(milliseconds: 350), () async {
                if (context.mounted) {
                  // Navigate based on source
                  if (widget.source == 'booking_pre_payment' &&
                      widget.returnData != null) {
                    // نفس نمط العودة من إضافة مركبة لصفحة المركبات: استدعاء API ثم goAndClearStack
                    try {
                      final getVehiclesUseCase = getIt<GetVehiclesUseCase>();
                      final vehiclesEntities = await getVehiclesUseCase();

                      final vehicles = vehiclesEntities
                          .map(
                            (entity) => VehicleModel(
                              vehicleId: entity.vehicleId,
                              platNumber: entity.platNumber,
                              carMake: entity.carMake,
                              carModel: entity.carModel,
                              color: entity.color,
                              status: entity.status,
                              requestStatus: entity.requestStatus,
                              userId: entity.userId,
                              createdAt: entity.createdAt,
                              updatedAt: entity.updatedAt,
                            ),
                          )
                          .toList();

                      final updatedReturnData = Map<String, dynamic>.from(
                        widget.returnData!,
                      );
                      updatedReturnData['vehicles'] = vehicles;

                      if (context.mounted) {
                        context.goAndClearStack(
                          Routes.userMainBookingsPrePaymentPath,
                          extra: updatedReturnData,
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        context.goAndClearStack(
                          Routes.userMainBookingsPrePaymentPath,
                          extra: widget.returnData,
                        );
                      }
                    }
                  } else {
                    // طلب تحديث قائمة المركبات قبل الانتقال حتى تُستدعى الـ API وتظهر آخر مركبة
                    getIt<VehiclesListRefreshNotifier>().requestRefresh();

                    final userType = await AuthLocalRepository.getUserType();
                    if (userType != 'owner') {
                      context.goAndClearStack(Routes.userMainVehiclesPath);
                    } else {
                      context.goAndClearStack(Routes.ownerMainPath);
                    }
                  }
                }
              });
            } else if (state is VehicleActionFailure) {
              // 422 should be shown inline; other errors as snackbar
              if (state.statusCode != 422) {
                final errorMessage = VehiclesErrorHandler.handleErrorState(
                  state.error,
                  state.statusCode,
                  l10n,
                );
                UnifiedSnackbar.error(context, message: errorMessage);
              }
            }
          },
          builder: (context, state) {
            final isLoading = state is VehicleActionLoading;
            final inlineError =
                state is VehicleActionFailure && state.statusCode == 422
                ? VehiclesErrorHandler.handleErrorState(
                    state.error,
                    state.statusCode,
                    l10n,
                  )
                : null;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(
                start: 24.w,
                end: 24.w,
                top: 20.h,
                bottom: 20.h,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (inlineError != null) ...[
                      Container(
                        padding: EdgeInsetsDirectional.all(16.w),
                        decoration: BoxDecoration(
                          color: AppColors.error.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: AppColors.error.withValues(alpha: 0.25),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              EvaIcons.alertCircleOutline,
                              size: 20.sp,
                              color: AppColors.error,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                inlineError,
                                style: AppTextStyles.bodySmall(
                                  context,
                                  color: AppColors.error,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                    VehicleFormFields(
                      selectedCarMake: _selectedCarMake,
                      onCarMakeChanged: (value) {
                        setState(() {
                          _selectedCarMake = value;
                          if (value != 'Other') {
                            _otherCarMakeController.clear();
                          }
                        });
                      },
                      otherCarMakeController: _otherCarMakeController,
                      plateController: _plateController,
                      typeController: _typeController,
                      selectedColor: _selectedColor,
                      onColorChanged: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                      enabled: !isLoading,
                    ),
                    SizedBox(height: 32.h),
                    CustomElevatedButton(
                      title: l10n.vehiclesAddButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _submit,
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

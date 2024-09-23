import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moiz_steel/view/registration_form_images.dart';
import '../controller/outlet_images_registration_controller.dart';
import '../widgets/build_check_box.dart';
import '../widgets/build_form_field.dart';
import '../widgets/build_title_text.dart';
import '../widgets/custom_appbar.dart';
import '../widgets/custom_button_widget.dart';

class RegistrationFormScreen extends StatelessWidget {
  final FormController controller = Get.put(FormController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Registration Form'),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TitleText(title: 'Business Name'),
                CustomFormField(
                  controller: controller.businessNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'Owner Name'),
                CustomFormField(
                  controller: controller.ownerNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'CNIC Number'),
                CustomFormField(
                  controller: controller.cnicNumberController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    } else if (value.length != 13) {
                      return 'CNIC must be 13 digits';
                    }

                    return null;
                  },
                  maxLength: 13,
                ),
                TitleText(title: 'NTN Number'),
                CustomFormField(
                  controller: controller.ntnNumberController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'Landline Number'),
                CustomFormField(
                  controller: controller.landlineNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    } else if (value.length != 11) {
                      return 'landline number must be 11 digits';
                    }
                    return null;
                  },
                  maxLength: 11,
                ),
                TitleText(title: 'Mobile Number'),
                CustomFormField(
                  controller: controller.mobileNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    } else if (value.length != 11 || value.length > 11) {
                      return 'Mobile number must be 11 digits';
                    }
                    return null;
                  },
                  maxLength: 11,
                ),
                TitleText(title: 'Billing Address'),
                CustomFormField(
                  controller: controller.billingAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'Shipping Address'),
                CustomFormField(
                  controller: controller.shippingAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'Contact Person for Billing and Invoice'),
                CustomFormField(
                  controller: controller.billingContactPersonController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'Contact Person for Logistic Matter'),
                CustomFormField(
                  controller: controller.logisticsContactPersonController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'City Name'),
                CustomFormField(
                  controller: controller.cityNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'Complete Address'),
                CustomFormField(
                  controller: controller.completeAddressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'Year in Business Since'),
                CustomFormField(
                  controller: controller.yearInBusinessController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                TitleText(title: 'Monthly Sale Volume in MTN'),
                CustomFormField(
                  controller: controller.monthlySaleVolumeController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Previous Dealership and History',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                TitleText(title: 'Comments'),
                CustomFormField(
                  controller: controller.previousDealershipController,
                  keyboardType: TextInputType.multiline,
                  // validator: (value) {
                  //   if (value == null || value.isEmpty) {
                  //     return 'This field is required';
                  //   }
                  //   return null;
                  // },
                ),
                const SizedBox(height: 16.0),
                CustomCheckbox(
                  title: 'Owner',
                  value: controller
                      .isOwner, // This should be an RxBool from the controller
                  onChanged: () {
                    controller.toggleOwnership(true); // Handle ownership logic
                  },
                ),
                CustomCheckbox(
                  title: 'Rent',
                  value: controller
                      .isOnRent, // This should be an RxBool from the controller
                  onChanged: () {
                    controller.toggleOwnership(false); // Handle rent logic
                  },
                ),
                const SizedBox(height: 16.0),
                CustomButtonWidget(
                  text: 'Next',
                  icon: Icons.arrow_circle_right_rounded,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Proceed if the form is valid
                      Get.to(() => OutletRegistrationImages(),
                          transition: Transition.leftToRight);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

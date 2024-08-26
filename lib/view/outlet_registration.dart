import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moiz_steel/constants.dart';
import 'package:moiz_steel/view/registration_form_images.dart';
import '../controller/outlet_images_registration_controller.dart';
import 'package:moiz_steel/widgets/custom_text_form_field.dart';
import 'package:moiz_steel/widgets/custom_button_widget.dart';
class RegistrationFormScreen extends StatelessWidget {
  final FormController controller = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Form',style: kAppBarTextColor,),
        backgroundColor: kAppBarColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: [
              CustomTextFormField(
                controller: controller.businessNameController,
                hintText: 'Business Name',
                hintTextColor: Colors.grey,

              ),
              SizedBox(height: 10,),
              CustomTextFormField(
                controller: controller.ownerNameController,
                hintText: 'Owner Name',
                hintTextColor: Colors.grey,

              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.cnicNumberController,
                hintText: 'CNIC Number',
                hintTextColor: Colors.grey,

                keyboardType: TextInputType.number,
              ),

              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.ntnNumberController,
                hintText: 'NTN Number',
                hintTextColor: Colors.grey,

                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.landlineNumberController,
                hintText: 'Landline Number',
                hintTextColor: Colors.grey,

                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.mobileNumberController,
                hintText: 'Mobile Number',
                hintTextColor: Colors.grey,

                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.billingAddressController,
                hintText: 'Billing Address',
                hintTextColor: Colors.grey,

              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.shippingAddressController,
                hintText: 'Shipping Address',
                hintTextColor: Colors.grey,

              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.billingContactPersonController,
                hintText: 'Contact Person for Billing and Invoice',
                hintTextColor: Colors.grey,

              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.logisticsContactPersonController,
                hintText: 'Contact Person for Logistic Matter',
                hintTextColor: Colors.grey,

              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.cityNameController,
                hintText: 'City Name',
                hintTextColor: Colors.grey,

              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.completeAddressController,
                hintText: 'Complete Address',
                hintTextColor: Colors.grey,

              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.yearInBusinessController,
                hintText: 'Year in Business Since',
                hintTextColor: Colors.grey,

                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10,),

              CustomTextFormField(
                controller: controller.monthlySaleVolumeController,
                hintText: 'Monthly Sale Volume in MTN',
                hintTextColor: Colors.grey,

                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 16.0),
              const Text(
                'Previous Dealership and History',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              CustomTextFormField(
                controller: controller.previousDealershipController,
                hintText: 'Comments',
                hintTextColor: Colors.grey,

                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 16.0),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(
                            () => Checkbox(
                          value: controller.isOwner.value,
                          onChanged: (bool? value) {
                            controller.toggleOwnership(true);

                          },
                        ),
                      ),
                      const Text('Owner'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Obx(
                            () => Checkbox(
                          value: controller.isOnRent.value,
                          onChanged: (bool? value) {
                            controller.toggleOwnership(false);
                          },
                        ),
                      ),
                      const Text('Rent'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              CustomButtonWidget(text: 'Submit',
                onPressed: () {
                  Get.to(() => OutletRegistrationImages());

                  // Implement submit functionality
                },
              ),

            ],

          ),
        ),
      ),
    );
  }

  bool _validateForm() {
    // Add form validation logic
    return true;
  }
}

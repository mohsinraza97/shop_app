import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../utils/utilities/common_utils.dart';
import '../../widgets/common/progress_loader.dart';
import '../../resources/app_strings.dart';
import '../../../utils/utilities/dialog_utils.dart';
import '../../../utils/utilities/image_utils.dart';
import '../../../utils/constants/app_constants.dart';
import '../../../utils/utilities/navigation_utils.dart';
import '../../view_models/product/product_list_view_model.dart';
import '../../../data/models/entities/product.dart';
import '../../resources/app_assets.dart';
import '../../../data/enums/manage_product_options.dart';
import '../../../data/models/ui/ui_response.dart';

class ManageProductPage extends StatefulWidget {
  final String? productId;
  final ManageProductOptions? manageOption;

  const ManageProductPage({
    this.productId,
    this.manageOption = ManageProductOptions.add,
  });

  @override
  _ManageProductPageState createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  var _product = Product(
    id: '',
    title: '',
    description: '',
    imageUrl: '',
    price: 0,
  );
  var _isLoading = false;
  var _isInit = false;
  late ProductListViewModel _viewModel;

  final _focusNodeImage = FocusNode();
  final _controllerImage = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    _focusNodeImage.addListener(_imagePreviewListener);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      _isInit = true;
      _viewModel = Provider.of<ProductListViewModel>(context, listen: false);
      if (widget.manageOption == ManageProductOptions.edit) {
        _product = _viewModel.findById(widget.productId);
        _controllerImage.text = _product.imageUrl ?? '';
      }
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.manageOption == ManageProductOptions.add
        ? AppStrings.title_add_product
        : AppStrings.title_edit_product;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () => submitForm(),
            icon: Icon(Icons.done),
            tooltip: AppStrings.tooltip_save,
          ),
        ],
      ),
      body: _buildBodyWidget(context),
    );
  }

  Widget _buildBodyWidget(BuildContext context) {
    return Stack(
      children: [
        Form(
          key: _form,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            child: Column(
              children: [
                _buildTitleField(context),
                SizedBox(height: 16),
                _buildPriceField(context),
                SizedBox(height: 16),
                _buildDescriptionField(),
                SizedBox(height: 16),
                _buildImageField(),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 48,
                  child: RaisedButton(
                    onPressed: () => submitForm(),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    child: Text(AppStrings.save.toUpperCase()),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ProgressLoader(visible: _isLoading),
      ],
    );
  }

  @override
  void dispose() {
    _focusNodeImage.removeListener(_imagePreviewListener);

    _focusNodeImage.dispose();
    _controllerImage.dispose();

    super.dispose();
  }

  Widget _buildTitleField(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _product.title,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     color: Theme.of(context).primaryColor,
        //   ),
        // ),
        labelText: AppStrings.input_field_title,
        // labelStyle: TextStyle(
        //   color: Theme.of(context).primaryColor,
        // ),
      ),
      keyboardType: TextInputType.text,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          // Returning a value means there's an error
          return AppStrings.validation_required;
        }
        // Returning null means input is correct
        return null;
      },
      onSaved: (value) {
        _product.title = value?.trim() ?? '';
      },
    );
  }

  Widget _buildPriceField(BuildContext context) {
    var price = _product.price == 0 ? '' : _product.price.toString();
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: price,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: AppStrings.input_field_price,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      inputFormatters: <TextInputFormatter>[
        // LengthLimitingTextInputFormatter(5),
        // FilteringTextInputFormatter.digitsOnly,
      ],
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return AppStrings.validation_required;
        }
        double? price = double.tryParse(value ?? '');
        if (price == null || price <= 0) {
          return AppStrings.validation_invalid_price;
        }
        return null;
      },
      onSaved: (value) {
        _product.price = double.tryParse(value?.trim() ?? '0') ?? 0;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: _product.description,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: AppStrings.input_field_description,
        alignLabelWithHint: true,
      ),
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        int length = value?.length ?? 0;
        if (length <= 0) {
          return AppStrings.validation_required;
        }
        if (length < 10) {
          return AppStrings.validation_invalid_description;
        }
        return null;
      },
      onSaved: (value) {
        _product.description = value?.trim() ?? '';
      },
    );
  }

  Widget _buildImageField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
          ),
          child: _controllerImage.text.isEmpty
              ? ImageUtils.getLocalImage(AppAssets.image_placeholder)
              : ImageUtils.getNetworkImage(_controllerImage.text),
        ),
        Expanded(
          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: AppStrings.input_field_image,
            ),
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            controller: _controllerImage,
            focusNode: _focusNodeImage,
            onEditingComplete: () {
              setState(() {});
            },
            validator: (value) {
              return _validateImage(value);
            },
            onSaved: (value) {
              _product.imageUrl = value?.trim() ?? '';
            },
            onFieldSubmitted: (value) {
              submitForm();
            },
          ),
        ),
      ],
    );
  }

  String? _validateImage(String? value) {
    if (value?.isEmpty ?? false) {
      return AppStrings.validation_required;
    }
    if (!(value?.startsWith('http') ?? false) &&
        !(value?.startsWith('https') ?? false)) {
      return AppStrings.validation_invalid_image_url;
    }
    if (!(value?.endsWith('.png') ?? false) &&
        !(value?.endsWith('.jpg') ?? false) &&
        !(value?.endsWith('.jpeg') ?? false)) {
      return AppStrings.validation_invalid_image_type;
    }
    return null;
  }

  void _imagePreviewListener() {
    if (!_focusNodeImage.hasFocus) {
      // null indicates image is valid
      if (_validateImage(_controllerImage.text) == null) {
        setState(() {});
      }
    }
  }

  void _toggleLoader({required bool loading}) {
    setState(() {
      _isLoading = loading;
    });
  }

  Future<void> submitForm() async {
    // This will execute validator function of each field inside form
    bool isValid = _form.currentState?.validate() ?? false;
    if (isValid) {
      // Hide keyboard
      CommonUtils.removeCurrentFocus(context);

      // This will execute onSaved function of each field inside form
      _form.currentState?.save();

      _toggleLoader(loading: true);
      if (widget.manageOption == ManageProductOptions.add) {
        _viewModel.add(_product).then((response) {
          _handleResponse(response);
        });
      } else if (widget.manageOption == ManageProductOptions.edit) {
        _viewModel.update(_product).then((response) {
          _handleResponse(response);
        });
      }
    }
  }

  void _handleResponse(UiResponse<bool> response) {
    _toggleLoader(loading: false);
    if (response.hasData && response.data!) {
      NavigationUtils.pop(context, result: _product);
    } else {
      DialogUtils.showErrorDialog(
        context,
        message: response.errorMessage,
      );
    }
  }
}

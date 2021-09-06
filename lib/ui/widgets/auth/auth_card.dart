import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/enums/auth_mode.dart';
import '../../../data/models/entities/user.dart';
import '../../../data/models/ui/ui_response.dart';
import '../../resources/app_strings.dart';
import '../../view_models/auth/auth_view_model.dart';
import '../../../utils/constants/route_constants.dart';
import '../../../utils/utilities/common_utils.dart';
import '../../../utils/utilities/dialog_utils.dart';
import '../../../utils/utilities/navigation_utils.dart';

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  static const double initial_height = 260;
  static const double expanded_height = 330;

  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _authMode = AuthMode.login;
  var _isLoading = false;
  var _email = "";
  var _password = "";
  var _obscurePassword = true;
  AnimationController? _animController;
  Animation<Size>? _authModeAnim;
  AuthViewModel? _viewModel;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _viewModel = Provider.of<AuthViewModel>(context, listen: false);
    });
    _setUpAnimation();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      elevation: 8.0,
      child: _buildAnimatedContainer(deviceSize),
    );
  }

  @override
  void dispose() {
    _animController?.dispose();

    super.dispose();
  }

  Widget _buildAnimatedBuilder(Size deviceSize) {
    // Although not using this function but still keeping AnimatedBuilder related code for the demonstration purpose
    return AnimatedBuilder(
      animation: _authModeAnim!,
      builder: (ctx, staticChild) {
        final height = _authModeAnim?.value.height ?? initial_height;
        return Container(
          height: height,
          constraints: BoxConstraints(
            minHeight: height,
          ),
          width: deviceSize.width * 0.75,
          margin: const EdgeInsets.all(16.0),
          child: staticChild,
        );
      },
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildEmailField(),
              SizedBox(height: 16),
              _buildPasswordField(),
              if (_authMode == AuthMode.sign_up) _buildConfirmPasswordField(),
              SizedBox(height: 24),
              if (_isLoading)
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )
              else
                _buildPrimaryButton(context),
              _buildSwitchModeButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedContainer(Size deviceSize) {
    // With AnimatedContainer we do not need to manage animation & controller on our own.
    final height =
        _authMode == AuthMode.login ? initial_height : expanded_height;
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
      height: height,
      constraints: BoxConstraints(
        minHeight: height,
      ),
      width: deviceSize.width * 0.75,
      margin: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _buildEmailField(),
              SizedBox(height: 16),
              _buildPasswordField(),
              if (_authMode == AuthMode.sign_up) _buildConfirmPasswordField(),
              SizedBox(height: 24),
              if (_isLoading)
                CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                )
              else
                _buildPrimaryButton(context),
              _buildSwitchModeButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: AppStrings.input_field_email,
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return AppStrings.validation_required;
        }
        String emailRegExp =
            r'^[\w-\+]+(\.[\w]+)*@[\w-]+(\.[\w]+)*(\.[a-zA-Z]{2,})$';
        if (!RegExp(emailRegExp).hasMatch(value!)) {
          return AppStrings.validation_invalid_email;
        }
        return null;
      },
      onSaved: (value) {
        _email = value ?? '';
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: AppStrings.input_field_password,
        suffixIcon: _buildPasswordVisibilityIcon(),
      ),
      obscureText: _obscurePassword,
      controller: _passwordController,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value?.isEmpty ?? false) {
          return AppStrings.validation_required;
        }
        int length = value?.length ?? 0;
        if (length < 8) {
          return AppStrings.validation_invalid_password;
        }
        return null;
      },
      onSaved: (value) {
        _password = value ?? '';
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return Column(
      children: [
        SizedBox(height: 16),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          enabled: _authMode == AuthMode.sign_up,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: AppStrings.input_field_confirm_password,
            suffixIcon: _buildPasswordVisibilityIcon(),
          ),
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          validator: _authMode == AuthMode.sign_up
              ? (value) {
                  if (value?.isEmpty ?? false) {
                    return AppStrings.validation_required;
                  }
                  if (value != _passwordController.text) {
                    return AppStrings.validation_password_not_match;
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildPasswordVisibilityIcon() {
    return IconButton(
      icon: Icon(
        _obscurePassword ? Icons.visibility_off : Icons.visibility,
        color: Theme.of(context).primaryColor,
      ),
      onPressed: () {
        setState(() {
          _obscurePassword = !_obscurePassword;
        });
      },
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildPrimaryButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      child: RaisedButton(
        child: Text(
          '${_authMode == AuthMode.login ? AppStrings.login : AppStrings.sign_up}'
              .toUpperCase(),
        ),
        onPressed: _submit,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        color: Theme.of(context).primaryColor,
        textColor: Theme.of(context).primaryTextTheme.button?.color,
      ),
    );
  }

  Widget _buildSwitchModeButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: FlatButton(
        child: Text(
          '${_authMode == AuthMode.sign_up ? AppStrings.login : AppStrings.sign_up} ${AppStrings.instead}'
              .toUpperCase(),
        ),
        onPressed: _switchAuthMode,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        textColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _setUpAnimation() {
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    final anim = CurvedAnimation(
      parent: _animController!,
      curve: Curves.fastOutSlowIn,
    );
    _authModeAnim = Tween<Size>(
      begin: Size(double.infinity, initial_height), // Initial Width & Height
      end: Size(double.infinity, expanded_height), // Expanded Width & Height
    ).animate(anim);
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.login) {
      setState(() {
        _authMode = AuthMode.sign_up;
      });
      _animController?.forward();
    } else {
      setState(() {
        _authMode = AuthMode.login;
      });
      _animController?.reverse();
    }
  }

  void _toggleLoader({required bool loading}) {
    setState(() {
      _isLoading = loading;
    });
  }

  void _submit() {
    // This will execute validator function of each field inside form
    bool isValid = _formKey.currentState?.validate() ?? false;
    if (isValid) {
      // Hide keyboard
      CommonUtils.removeCurrentFocus(context);

      // This will execute onSaved function of each field inside form
      _formKey.currentState?.save();

      var userRequest = UserRequest(email: _email, password: _password);
      _toggleLoader(loading: true);
      if (_authMode == AuthMode.login) {
        _viewModel?.login(userRequest).then((response) {
          _handleResponse(response);
        });
      } else {
        _viewModel?.signUp(userRequest).then((response) {
          _handleResponse(response);
        });
      }
    }
  }

  void _handleResponse(UiResponse<bool> response) {
    _toggleLoader(loading: false);
    if (response.hasData && response.data!) {
      NavigationUtils.replace(context, RouteConstants.product_overview);
    } else {
      DialogUtils.showErrorDialog(
        context,
        message: response.errorMessage,
      );
    }
  }
}

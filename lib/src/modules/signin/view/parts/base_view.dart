// import 'package:chaseapp/src/shared/util/helpers/locator.dart';
// import 'package:flutter/material.dart';
// import 'package:chaseapp/src/modules/signin/view/providers/base_model.dart';
// import 'package:chaseapp/src/shared/util/helpers/locator.dart';
// import 'package:provider/provider.dart';

// class BaseView<T extends BaseModel> extends StatefulWidget {
//   final Widget Function(BuildContext context, T model, Widget? child) builder;
//   final Function(T) onModelReady;

//   const BaseView({required this.builder, required this.onModelReady});

//   @override
//   _BaseViewState<T> createState() => _BaseViewState<T>();
// }

// class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
//   T model = locator<T>();

//   @override
//   void initState() {
//     widget.onModelReady(model);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<T>(
//         create: (context) => model,
//         child: Consumer<T>(builder: widget.builder));
//   }
// }

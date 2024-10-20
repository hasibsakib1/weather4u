import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueHandler<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T) dataBuilder;
  final Widget Function()? loadingBuilder;
  final Widget Function(Object, StackTrace?)? errorBuilder;

  const AsyncValueHandler(
    this.asyncValue, {
    Key? key,
    required this.dataBuilder,
    this.loadingBuilder,
    this.errorBuilder,
  }) : super(key: key);

  static Widget defaultLoadingBuilder() {
    return const Center(child: CircularProgressIndicator());
  }

  static Widget defaultErrorBuilder(Object error, StackTrace? stackTrace) {
    return Text('Error: $error');
  }
  

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: dataBuilder,
      loading: loadingBuilder ?? defaultLoadingBuilder,
      error: errorBuilder ?? defaultErrorBuilder,
    );
  }
}

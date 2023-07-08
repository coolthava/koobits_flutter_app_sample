import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koobits_flutter_app/core/di/service_locator.dart';
import 'package:koobits_flutter_app/presentation/bloc/post/post_cubit.dart';
import 'package:koobits_flutter_app/presentation/bloc/post/post_state.dart';
import 'package:koobits_flutter_app/presentation/screen/home/widget/empty_widget.dart';
import 'package:koobits_flutter_app/presentation/screen/home/widget/error_state_widget.dart';
import 'package:koobits_flutter_app/presentation/screen/home/widget/loading_state_widget.dart';
import 'package:koobits_flutter_app/presentation/screen/home/widget/post_data_item_widget.dart';

@RoutePage()
class MyHomePage extends StatefulWidget implements AutoRouteWrapper {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => sl.get<PostCubit>(),
      child: this,
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  late PostCubit _postCubit;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    _postCubit = BlocProvider.of<PostCubit>(context);
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _controller.addListener(() {
      _postCubit.searchDataForText(_controller.value.text);
    });

    _postCubit.getPostData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// To prevent resize of UI/Widget when keyboard appears if value is false
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: BlocBuilder<PostCubit, PostState>(builder: (context, state) {
          return TextField(
            controller: _controller,
            keyboardType: TextInputType.text,
            focusNode: _focusNode,
            cursorWidth: 3,
            cursorColor: Colors.grey,
            decoration: InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: state is SuccessPostState ? 'Input text here' : '',
              hintStyle: const TextStyle(color: Colors.white70),
            ),
          );
        }),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocConsumer<PostCubit, PostState>(
          bloc: _postCubit,
          listenWhen: (prev, curr) => curr is SuccessPostState,
          listener: (context, state) {
            /// To immediately allow typing once results are successfully returned
            if (state is SuccessPostState) {
              _focusNode.requestFocus();
            }
          },
          builder: (context, state) {
            switch (state) {
              case EmptyPostState():
                return const EmptyWidget();
              case ErrorPostState():
                return const ErrorStateWidget();
              case SuccessPostState():
                {
                  var data = state.postData;

                  /// This ListView can also be made into a separate widget for
                  /// re-usability if needed
                  return ListView.separated(
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(
                          top: index == 0 ? 12 : 0,
                          bottom: index == data.length - 1 ? 12 : 0,
                        ),
                        child: PostDataWidget(data[index]),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                    itemCount: data.length,
                  );
                }
              case LoadingPostState():
                return const LoadingStateWidget();
              case InitialPostState():
              default:
                return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}

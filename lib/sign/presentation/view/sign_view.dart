import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/core/resources/app_routes.dart';
import 'package:movies_app/core/resources/app_values.dart';

class SignView extends StatefulWidget {
  const SignView({
    super.key,
  });

  @override
  State<SignView> createState() => _SignViewState();
}

class _SignViewState extends State<SignView> {
  TextEditingController? passwordController = TextEditingController();
  String errorText = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Image.asset(
              'assets/images/cinema_bg.jpg',
              width: double.infinity,
              height: AppSize.s150,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 100,),
                  const Text(
                    'Cinema',
                    style: TextStyle(color: Colors.white, fontSize: AppSize.s60),
                  ),
                  const SizedBox(
                    height: AppPadding.p36,
                  ),
                  const Text(
                    'Đăng nhập',
                    style: TextStyle(color: Colors.white, fontSize: AppSize.s30),
                  ),
                  const SizedBox(
                    height: AppPadding.p20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppPadding.p20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        hintStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1.5,
                          ),
                        ),
                      ),
                      obscureText: true
                    ),
                  ),
                  const SizedBox(
                    height: AppPadding.p20,
                  ),
                  Text(errorText,style: const TextStyle(color: Colors.white),),
                  ElevatedButton(
                      onPressed: () {
                        if(passwordController?.text == '123456'){
                          context.goNamed(AppRoutes.moviesRoute);
                        }else{
                          setState(() {
                            errorText = 'Mật khẩu không đúng';
                          });
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                          (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.red;
                            }
                            return Colors.black;
                          },
                        ),
                        padding: MaterialStateProperty.resolveWith<EdgeInsets?>((states) => const EdgeInsets.only(
                            top: AppPadding.p10, left: AppPadding.p20, right: AppPadding.p20, bottom: AppPadding.p10)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), 
                          ),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: AppSize.s30),
                      )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

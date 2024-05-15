import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fetch_git_users/model/user_search_view_model.dart';
import 'package:fetch_git_users/model/github_user.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

class UserSearchPage extends StatefulWidget {
  const UserSearchPage({Key? key}) : super(key: key);

  @override
  _UserSearchPageState createState() => _UserSearchPageState();
}

class _UserSearchPageState extends State<UserSearchPage> with SingleTickerProviderStateMixin {
  late AnimationController _controllerAnimation;
  late Animation<double> _animation;
  final _viewModel = UserSearchViewModel();
  final TextEditingController _controller = TextEditingController();

  void cleanSearchAndFields() {
    _controller.clear();
    _viewModel.clearStreams();
  }

  @override
  void initState() {
    super.initState();
    _controllerAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controllerAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade400,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            children: [
              SizedBox(
                height: 90,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Neumorphic(
                    style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(15)),
                      depth: 5,
                      lightSource: LightSource.bottomRight,
                      oppositeShadowLightSource: true,
                      intensity: 1,
                      color: Colors.grey.shade300,
                    ),
                    child: Container(
                      width: 300,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Coloque aqui o user do GitHub",
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            if (value == null || value.isEmpty) {
                              final scaffoldMessenger =
                                  ScaffoldMessenger.of(context);
                              scaffoldMessenger.showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red.shade200,
                                  content: Text('Digite algo!',style: TextStyle(fontSize: 18,fontWeight: FontWeight.w700),),
                                ),
                              );
                            } else {
                              _viewModel.searchUsers(value);
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 50,
                    child: NeumorphicButton(
                      duration: Duration(milliseconds: 300),
                      drawSurfaceAboveChild: true,
                      style: NeumorphicStyle(
                        boxShape: NeumorphicBoxShape.circle(),
                        shape: NeumorphicShape.convex,
                        depth: 5,
                        oppositeShadowLightSource: true,
                        intensity: 30,
                        color: Colors.grey.shade200,
                        lightSource: LightSource.bottomRight,
                      ),
                      onPressed: () {
                        Future.delayed(Duration(milliseconds: 300)).then((_) {
                          cleanSearchAndFields();
                        });
                      },
                      padding: EdgeInsets.all(18),
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _animation.value * 1 * 3.14,
                            child: Icon(
                              Icons.cleaning_services_sharp,
                              size: 20,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    depth: 5,
                    lightSource: LightSource.bottomRight,
                    oppositeShadowLightSource: true,
                    intensity: 1,
                    color: Colors.grey.shade300,
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: StreamBuilder<List<GithubUser>>(
                          stream: _viewModel.usersStream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data!.isEmpty) {
                                return Center(
                                  child: Text('...',style: TextStyle(fontSize: 50),),
                                );
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final user = snapshot.data![index];
                                  return ListTile(
                                    hoverColor: Colors.blueAccent.shade200,
                                    onTap: () {
                                      HapticFeedback.heavyImpact();
                                      _viewModel
                                          .getUserRepositories(user.login);
                                    },
                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(user.avatarUrl),
                                    ),
                                    title: Text(user.login),
                                  );
                                },
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text('...'),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.grey.shade100,
                                Colors.grey.shade300.withOpacity(0),
                              ],
                            ),
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              "Usuários",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
              Expanded(
                child: Neumorphic(
                  style: NeumorphicStyle(
                    shape: NeumorphicShape.convex,
                    boxShape:
                        NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                    depth: 5,
                    lightSource: LightSource.bottomRight,
                    oppositeShadowLightSource: true,
                    intensity: 1,
                    color: Colors.grey.shade300,
                  ),
                  child: Container(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: StreamBuilder<List<dynamic>>(
                            stream: _viewModel.repositoriesStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final repository = snapshot.data![index];
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text(repository['name']),
                                          subtitle: Text(
                                              repository['description'] ??
                                                  'No description'),
                                        ),
                                        Divider(
                                          color: Colors.grey.shade400,
                                        )
                                      ],
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(
                                      'Erro ao carregar repositórios: ${snapshot.error}'),
                                );
                              }
                              return const SizedBox(); // Retorna um widget vazio se não houver dados ainda
                            },
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.grey.shade300,
                                  Colors.grey.shade300.withOpacity(0),
                                ],
                              ),
                            ),
                            padding: EdgeInsets.all(8.0),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: Text(
                                "Repositórios",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

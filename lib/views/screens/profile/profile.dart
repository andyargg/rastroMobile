import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final router = AutoRouter.of(context);
    
    return Scaffold(
      backgroundColor: Color(0xFFE3E2E2),
      appBar: AppBar(
        backgroundColor: Color(0xFFE3E2E2),
        elevation: 0,
        leading: IconButton(
          icon: Icon(LucideIcons.chevronLeft),
          onPressed: router.pop,
        ),
        centerTitle: true,
        title: Text(
          "Perfil",
          style: TextStyle(
            fontSize: 24,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20),
        children: [
          Center(
            child: CircleAvatar(
              radius: 62.5,
              backgroundColor: Color(0xFFC98643),
              backgroundImage: AssetImage('assets/profilePhoto/lucioPro.jpg'),
            ),
          ),
          
          SizedBox(height: 20),
          
          Text(
            "Lucio Ricolini Arriola",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'lucionicoliniarriolapro@gmail.com',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontFamily: 'Roboto',
              color: Color(0xFF7B7676),
            ),
          ),
          
          SizedBox(height: 20),
          
          FractionallySizedBox(
            widthFactor: 0.4,
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Color(0xFFC98643),
                minimumSize: Size.fromHeight(40),
              ),
              onPressed: () {},
              child: Text(
                'Editar perfil',
                style: TextStyle(color: Color(0xFF402E1B)),
              ),
            ),
          ),
          
          SizedBox(height: 30),
          
          Divider(
            color: Color(0xFFC98643),
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
          
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                spacing: 10,
                children: [
                  Icon(LucideIcons.settings, color: Color(0xFFC98643)),
                  Expanded(child: Text('Configuración')),
                  Icon(LucideIcons.chevronRight),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                spacing: 12,
                children: [
                  Icon(LucideIcons.clock, color: Color(0xFFC98643)),
                  Expanded(child: Text('Historial de pedidos')),
                  Icon(LucideIcons.chevronRight),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                spacing: 10,
                children: [
                  Icon(LucideIcons.lock, color: Color(0xFFC98643)),
                  Expanded(child: Text('Cambiar contraseña')),
                  Icon(LucideIcons.chevronRight),
                ],
              ),
            ),
          ),
          
          Divider(
            color: Color(0xFFC98643),
            thickness: 2,
            indent: 10,
            endIndent: 10,
          ),
          
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                spacing: 10,
                children: [
                  Icon(LucideIcons.messageCircle, color: Color(0xFFC98643)),
                  Expanded(child: Text('Contactar a soporte')),
                  Icon(LucideIcons.chevronRight),
                ],
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                spacing: 10,
                children: [
                  Icon(LucideIcons.logOut, color: Color(0xFFC98643)),
                  Expanded(child: Text('Salir')),
                  Icon(LucideIcons.chevronRight),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
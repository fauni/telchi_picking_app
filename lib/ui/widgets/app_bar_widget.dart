import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget{
  final String titulo;
  final IconData? icon;
  final VoidCallback? onPush;
  const AppBarWidget({
    super.key,
    required this.titulo,
    this.icon,
    this.onPush
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.surface,
      title: Text(titulo),
      
      actions: [
        icon != null 
        ? IconButton(onPressed: onPush, icon: Icon(icon)): const SizedBox()
      ],
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}




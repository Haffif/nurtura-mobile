import 'package:flutter/material.dart';
import 'package:nurtura_grow/theme/colors.dart';

class CustomDropdownMenuItem {
  final String text;
  final IconData icon;
  final Color color;
  final Function()? onTap;

  CustomDropdownMenuItem({
    required this.text,
    required this.icon,
    required this.color,
    required this.onTap
  });
}

class DropdownButtonComponent extends StatelessWidget {
  final String text;
  final IconData icon;
  final bool hasDropdown;
  final List<CustomDropdownMenuItem>? dropdownItems;


  const DropdownButtonComponent({
    super.key,
    required this.text,
    required this.icon,
    this.hasDropdown = false,
    this.dropdownItems,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Center(
        child: ListTile(
          leading: Icon(icon, color: AppColors.primaryColor, size: 24),
          title: Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          trailing: hasDropdown
              ? PopupMenuButton<CustomDropdownMenuItem>(
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            onSelected: (value) {
              value.onTap!();
            },
            itemBuilder: (BuildContext context) {
              return dropdownItems!.map((CustomDropdownMenuItem choice) {
                return PopupMenuItem<CustomDropdownMenuItem>(
                  value: choice,
                  child: InkWell(
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(choice.icon, color: choice.color),
                          const SizedBox(width: 8),
                          Text(
                            choice.text,
                            style: TextStyle(
                              color: choice.color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList();
            },
          )
              : null,
          onTap: () {
            if (!hasDropdown) {
              // Handle button tap for the case with no dropdown
            }
          },
        ),
      ),
    );
  }
}
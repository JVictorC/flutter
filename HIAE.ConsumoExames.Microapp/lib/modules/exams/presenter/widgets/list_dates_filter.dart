import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class ListDatesFilter extends StatefulWidget {
  int? selectedValue;
  final void Function(int) selectedButton;
  ListDatesFilter({
    required this.selectedButton,
    required this.selectedValue,
  });

  @override
  State<ListDatesFilter> createState() => _ListDatesFilterState();
}

class _ListDatesFilterState extends State<ListDatesFilter> {
  final List<int> year = [3, 6, 2022, 2021, 2020, 2019];
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(
          top: 20,
          bottom: 10,
          right: 5,
          left: 5,
        ),
        child: SizedBox(
          height: 30,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            separatorBuilder: (context, index) => Container(
              width: 10,
            ),
            itemCount: year.length,
            itemBuilder: (context, index) {
              String title = [3, 6].contains(year[index])
                  ? 'Últimos ${year[index]} meses'
                  : year[index].toString();

              return InkWell(
                onTap: () {
                  widget.selectedButton(
                    year[index],
                  );

                  setState(() {
                    widget.selectedValue = year[index];
                  });
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: widget.selectedValue != null &&
                              year[index] == widget.selectedValue
                          ? ZeraColors.primaryMedium
                          : Colors.white,
                      border: Border.all(
                        color: Theme.of(context).dividerColor,
                      ),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          8,
                        ),
                      ),
                    ),
                    child: Center(
                      child: ZeraText(
                        title,
                        color: widget.selectedValue != null &&
                                year[index] == widget.selectedValue
                            ? Colors.white
                            : ZeraColors.neutralDark01,
                        theme: const ZeraTextTheme(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
}

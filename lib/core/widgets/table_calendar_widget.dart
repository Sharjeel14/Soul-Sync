import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:date_app/core/extensions/app_extensions.dart';
import 'package:date_app/core/theme/app_colors.dart';
import 'package:date_app/core/widgets/app_text.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomCalendarPicker extends StatelessWidget {
  final DateTime initialDate;

  const CustomCalendarPicker({super.key, required this.initialDate});

  @override
  Widget build(BuildContext context) {
    final DateTime today = DateTime.now();
    DateTime focusedDay = initialDate.isBefore(today) ? today : initialDate;
    DateTime? selectedDay = focusedDay;

    return StatefulBuilder(
      builder: (context, setState) {
        return Dialog(
          insetPadding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          backgroundColor: AppColors.backgroundDark,
          child: Stack(
            children: [
              Container(
                width: 370,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    20.verticalSpace,

                    /// HEADER
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: focusedDay,
                                firstDate: today,
                                lastDate: DateTime(2099, 12, 31),
                                initialDatePickerMode: DatePickerMode.year,
                                builder: (context, child) {
                                  return Theme(
                                    data: ThemeData.dark().copyWith(
                                      colorScheme: const ColorScheme.dark(
                                        primary: AppColors.primary,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (picked != null) {
                                setState(() {
                                  focusedDay = picked;
                                  selectedDay = picked;
                                });
                              }
                            },
                            child: AppText(
                              DateFormat.yMMMM().format(focusedDay),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.white,
                            ),
                          ),
                        ),

                        /// ARROWS
                        Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.chevron_left,
                                color: AppColors.white,
                                size: 15,
                              ),
                              onPressed: () {
                                setState(() {
                                  DateTime prevMonth = DateTime(
                                    focusedDay.year,
                                    focusedDay.month - 1,
                                  );

                                  focusedDay = prevMonth.isBefore(today)
                                      ? today
                                      : prevMonth;
                                });
                              },
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              icon: const Icon(
                                Icons.chevron_right,
                                color: AppColors.white,
                                size: 15,
                              ),
                              onPressed: () {
                                setState(() {
                                  focusedDay = DateTime(
                                    focusedDay.year,
                                    focusedDay.month + 1,
                                  );
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    8.verticalSpace,

                    /// CALENDAR
                    TableCalendar(
                      headerVisible: false,
                      firstDay: today,
                      lastDay: DateTime.utc(2099, 12, 31),
                      focusedDay: focusedDay,
                      calendarFormat: CalendarFormat.month,
                      selectedDayPredicate: (day) =>
                          isSameDay(selectedDay, day),

                      onDaySelected: (selected, focused) {
                        context.safePop(selected);
                      },

                      daysOfWeekStyle: const DaysOfWeekStyle(
                        weekdayStyle: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                        weekendStyle: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),

                      calendarStyle: const CalendarStyle(
                        outsideDaysVisible: false,

                        defaultTextStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColors.white,
                        ),

                        weekendTextStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColors.white,
                        ),

                        selectedDecoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),

                        selectedTextStyle: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),

                        todayTextStyle: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

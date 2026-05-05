import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:med_reminder/models/add_medicine_model.dart';
import 'package:med_reminder/models/add_refill_model.dart';
import 'package:med_reminder/screens/drawer.dart';
import 'package:med_reminder/screens/medicine_detail.dart';
import 'package:med_reminder/screens/new_entry.dart';
import 'package:med_reminder/screens/refill_detail.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/calender_day_model.dart';
import '../notifications/notifications.dart';
import '../provider/auth_provider.dart';
import 'calender.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Flutter notifications
  final Notifications _notifications = Notifications();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  // Medicine and refill reminders
  List<MedicineModel> medReminders = [];
  List<MedicineModel> todayMedReminders = [];
  List<RefillModel> refillReminders = [];
  List<RefillModel> todayRefillReminders = [];

  // Calendar days
  final CalendarDayModel _days = CalendarDayModel();
  late List<CalendarDayModel> _daysList;
  final months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  int _lastChooseDay = 0;

  @override
  void initState() {
    super.initState();
    _daysList = _days.getCurrentDays();
    initNotifies();
    setData();
  }

  Future<void> initNotifies() async {
    flutterLocalNotificationsPlugin = await _notifications.initNotifies(context);
  }

  Future<void> setData() async {
    setState(() {
      medReminders.clear();
      refillReminders.clear();
      todayMedReminders.clear();
      todayRefillReminders.clear();
    });

    // Fetch reminders
    final medicineData = await getReminders();
    final refillData = await getRefillReminders();

    setState(() {
      medReminders = medicineData;
      refillReminders = refillData;
    });

    // Set today's reminders
    chooseDay(_daysList[_lastChooseDay]);
  }

  Future<List<MedicineModel>> getReminders() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return await ap.getMedicineRemindersFromFirebase();
  }

  Future<List<RefillModel>> getRefillReminders() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return await ap.getrefillRemindersFromFirebase();
  }

  void chooseDay(CalendarDayModel clickedDay) {
    setState(() {
      _lastChooseDay = _daysList.indexOf(clickedDay);
      _daysList.forEach((day) => day.isChecked = false);

      clickedDay.isChecked = true;
      todayMedReminders = medReminders.where((reminder) {
        final pillDate = DateTime.parse(reminder.dateTime);
        return clickedDay.dayNumber == pillDate.day &&
            clickedDay.month == pillDate.month &&
            clickedDay.year == pillDate.year;
      }).toList();

      todayRefillReminders = refillReminders.where((reminder) {
        final pillDate = DateTime.parse(reminder.date);
        return clickedDay.dayNumber == pillDate.day &&
            clickedDay.month == pillDate.month &&
            clickedDay.year == pillDate.year;
      }).toList();

      todayMedReminders.sort((a, b) => a.startTime.compareTo(b.startTime));
      todayRefillReminders.sort((a, b) => a.time.compareTo(b.time));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfff1f4f8),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Medi ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 5.h,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Reminder",
              style: GoogleFonts.abel(
                color: Colors.green,
                fontSize: 5.h,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0),
        child: Column(
          children: [
            const TopContainer(),
            Text(
              "${months[DateTime.now().month - 1]} ${DateTime.now().year}",
              style: GoogleFonts.poppins(fontSize: 3.h),
            ),
            SizedBox(height: 1.5.h),
            Calendar(chooseDay, _daysList),
            SizedBox(height: 2.h),
            buildRemindersSection("Reminders today", todayMedReminders),
            Flexible(child: BottomContainer(m: todayMedReminders)),
            SizedBox(height: 2.h),
            buildRemindersSection("Refill reminders today", todayRefillReminders),
            Flexible(child: RefillContainer(r: todayRefillReminders)),
          ],
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: SizedBox(
        width: 18.w,
        height: 9.h,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewEntryPage()),
            );
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add, size: 35.sp),
        ),
      ),
    );
  }

  Widget buildRemindersSection(String title, List reminders) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(bottom: 1.h),
      child: Text(
        "$title: ${reminders.length}",
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}

// Add unchanged classes for TopContainer, BottomContainer, RefillContainer, MedicineCard, RefillMedicineCard here...

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});
  // final int? count;
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
              bottom: 1.h,
            ),
            child: Text('Hello,',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color:Colors.green))),
        Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(
              bottom: 1.h,
            ),
            child: Text('${ap.userModel.name}',
                style: Theme.of(context).textTheme.titleSmall)),
        SizedBox(
          height: 2.h,
        ),
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key, required this.m});
  final List<MedicineModel>? m;

  @override
  Widget build(BuildContext context) {
    return (m == null || m!.isEmpty)
        ? Center(
      child: Text(
        'No reminder added!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.grey),
      ),
    )
        : GridView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(top: 1.h),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemCount: m!.length,
      itemBuilder: (context, index) {
        final medicine = m![index];
        return MedicineCard(
          medicineName: medicine.medicineName ?? "Unknown Medicine",
          dosage: medicine.dosage ?? 0,
          interval: medicine.interval ?? 0,
          medicineType: medicine.medicineType ?? "default",
          startTime: medicine.startTime ?? "N/A",
          date: medicine.dateTime ?? DateTime.now().toIso8601String(),
        );
      },
    );
  }
}


class RefillContainer extends StatelessWidget {
  const RefillContainer({super.key, required this.r});
  final List<RefillModel>? r;

  @override
  Widget build(BuildContext context) {
    return (r == null || r!.isEmpty)
        ? Center(
      child: Text(
        'No refill reminder added!',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.grey),
      ),
    )
        : GridView.builder(
      padding: EdgeInsets.only(top: 1.h),
      scrollDirection: Axis.horizontal,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
      ),
      itemCount: r!.length,
      itemBuilder: (context, index) {
        final refill = r![index];
        return RefillMedicineCard(
          medicineName: refill.medicineName ?? "Unknown Medicine",
          medicineType: refill.medicineType ?? "default",
          time: refill.time ?? "N/A",
          date: refill.date ?? DateTime.now().toIso8601String(),
        );
      },
    );
  }
}


class MedicineCard extends StatelessWidget {
  const MedicineCard({
    Key? key,
    required this.medicineName,
    required this.dosage,
    required this.interval,
    required this.medicineType,
    required this.startTime,
    required this.date,
  }) : super(key: key);

  final String? medicineName;
  final int? dosage;
  final int? interval;
  final String? medicineType;
  final String? startTime;
  final String? date;

  @override
  Widget build(BuildContext context) {
    final safeDate = date != null ? DateTime.parse(date!) : DateTime.now();
    final displayDate = "${safeDate.day}/${safeDate.month}/${safeDate.year}";

    return InkWell(
      highlightColor: Colors.green[100],
      splashColor: Colors.green,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineDetails(
              medicineName: medicineName ?? "Unknown",
              medicineType: medicineType ?? "Unknown",
              dosage: dosage ?? 0,
              interval: interval ?? 0,
              startTime: startTime ?? "N/A",
              date: displayDate,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(1.h),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(2.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset("assets/${medicineType ?? 'default'}.png", height: 7.h),
            const Spacer(),
            Text(
              medicineName ?? "Unknown",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 0.3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Every ${interval ?? 0} hours",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                Text(startTime ?? "N/A"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class RefillMedicineCard extends StatelessWidget {
  const RefillMedicineCard({
    Key? key,
    required this.medicineName,
    required this.medicineType,
    required this.time,
    required this.date,
  }) : super(key: key);

  final String? medicineName;
  final String? medicineType;
  final String? time;
  final String? date;

  @override
  Widget build(BuildContext context) {
    final safeDate = date != null ? DateTime.parse(date!) : DateTime.now();
    final displayDate = "${safeDate.day}/${safeDate.month}/${safeDate.year}";

    return InkWell(
      highlightColor: Colors.red[100],
      splashColor: Colors.red,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RefillDetails(
              medicineName: medicineName ?? "Unknown",
              medicineType: medicineType ?? "Unknown",
              time: time ?? "N/A",
              date: displayDate,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(1.h),
        margin: EdgeInsets.all(1.h),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(2.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Image.asset("assets/${medicineType ?? 'default'}.png", height: 7.h),
            const Spacer(),
            Text(
              medicineName ?? "Unknown",
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 0.3.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Refill today",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
                Text(time ?? "N/A"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


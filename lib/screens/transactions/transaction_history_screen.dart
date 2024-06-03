import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:susubox/utils/utils.dart';

import '../../ApiService/api_service.dart';
import '../../components/error_container.dart';
import '../../components/loading_dialog.dart';
import '../../model/transaction_history.dart';

class CardData{
  final String transaction;
  final String description;
  final String time;
  final String status;
  final String amount;
  final String date;
  final String ref;
  final String narration;
  final IconData icon;
  final Color color;

  const CardData(this.transaction,
      this.description,
      this.time,
      this.status,
      this.amount,
      this.date,
      this.ref,
      this.narration,
      this.icon, this.color);
}

class TransactionHistoryScreen extends StatefulWidget {
  final String resourceId;
  const TransactionHistoryScreen({required this.resourceId, super.key});

  @override
  State<TransactionHistoryScreen> createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {

  bool dataLoaded = false;
  bool errorOccurred = false;
  String token = '';

  TransactionHistory? transactions;
  List<CardData> cardDataList = [];

  Future<TransactionHistory?> getAllTransactions() async{
    setState(() {
      dataLoaded = false;
      errorOccurred = false;
    });
    try {
      transactions = await ApiService()
          .getTransactionHistory(token, widget.resourceId, 100)
          .timeout(const Duration(seconds: 90));
      if (transactions != null) {
        cardDataList = transactions!.data.map((transaction) {
          final dateTime = DateTime.parse(transaction.attributes.transactionDate.toString());
          final date = DateFormat('MMM yy').format(dateTime);
          final time = DateFormat('hh:mm a').format(dateTime);

          return CardData(
            '${transaction.attributes.transactionType[0].toUpperCase()}${transaction.attributes.transactionType.substring(1).toLowerCase()}',
            transaction.attributes.description,
            time,
            '${transaction.attributes.status[0].toUpperCase()}${transaction.attributes.status.substring(1).toLowerCase()}',
            'GHS ${transaction.attributes.amount}',
            date,
            transaction.attributes.referenceNumber,
            transaction.attributes.narration,
            FontAwesomeIcons.wallet,
            buttonColor,
          );
        }).toList();
        setState(() {
          dataLoaded = true;
        });
      }
    }
    catch(e){
      print('Error happened $e');
      setState(() {
        errorOccurred = true;
      });
    }
    return null;
  }

  void getData() async{
    final prefs = await SharedPreferences.getInstance();
    token = (prefs.getString('token') ?? '');
    getAllTransactions();
  }

  late Map<String, bool> _expanded;

  @override
  void initState() {
    super.initState();
    getData();
    _expanded = {};
  }

  @override
  Widget build(BuildContext context) {

    Map<String, List<CardData>> groupedCardData = {};
    for (var cardData in cardDataList) {
      if (groupedCardData.containsKey(cardData.date)) {
        groupedCardData[cardData.date]!.add(cardData);
      } else {
        groupedCardData[cardData.date] = [cardData];
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: errorOccurred ? ErrorContainer(refreshPage: getAllTransactions)
          : dataLoaded ?
        cardDataList.isEmpty ? Center(
          child: Text('No transactions',
           style: TextStyle(fontSize: 20.sp, color: Colors.white, fontWeight: FontWeight.w700),
          )
        )
        : Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction History',
                style: TextStyle(
                    fontSize: 28.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.03),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: groupedCardData.keys.length,
                itemBuilder: (context, dateIndex) {
                  String date = groupedCardData.keys.elementAt(dateIndex);
                  List<CardData> cards = groupedCardData[date]!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          String uniqueKey = '$date-$index';
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _expanded[uniqueKey] = !_expanded.containsKey(uniqueKey) ? true : !_expanded[uniqueKey]!;
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                    color: blackFaded,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 40.w,
                                                height: 40.h,
                                                decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: buttonColor),
                                                child: const Icon(
                                                  FontAwesomeIcons.wallet, // Update as needed
                                                  color: Colors.white,
                                                ),
                                              ),
                                              SizedBox(width: 4.w),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      cards[index].transaction,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                          FontWeight.w700),
                                                    ),
                                                    Text(
                                                      'Susu payment to account',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14.sp,
                                                          fontWeight:
                                                          FontWeight.w300),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          cards[index].amount,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.sp,
                                              fontWeight: FontWeight.w700),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 40.w,
                                              height: 20.h,
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: blackFaded)
                                            ),
                                            SizedBox(width: 5.w),
                                            Text(
                                              cards[index].time,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(width: 15.w),
                                            Text(
                                              cards[index].status,
                                              style: TextStyle(
                                                  color: customGreen,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {},
                                          child: Container(
                                            width: 20.w,
                                            height: 20.h,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.white),
                                            child: Icon(
                                              _expanded[uniqueKey] ?? false
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (_expanded[uniqueKey] ?? false)
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Divider(
                                              height: 2,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              cards[index].narration,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                              cards[index].description,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                  FontWeight.w300),
                                            ),
                                            SizedBox(height: 5.h),
                                            Text(
                                             'Ref: ${cards[index].ref}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ],
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        ): const LoadingDialog()
    );
  }
}
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Banking Design System Icons
/// Comprehensive icon system for banking applications
/// Includes Material Icons and Font Awesome icons organized by category

class BankingIcons {
  // Private constructor to prevent instantiation
  BankingIcons._();

  // ===========================================================================
  // NAVIGATION & ACTIONS
  // ===========================================================================

  static const IconData home = Icons.home_outlined;
  static const IconData homeFilled = Icons.home;
  static const IconData menu = Icons.menu;
  static const IconData close = Icons.close;
  static const IconData back = Icons.arrow_back;
  static const IconData forward = Icons.arrow_forward;
  static const IconData up = Icons.keyboard_arrow_up;
  static const IconData down = Icons.keyboard_arrow_down;
  static const IconData search = Icons.search;
  static const IconData filter = Icons.filter_list;
  static const IconData settings = Icons.settings_outlined;
  static const IconData settingsFilled = Icons.settings;

  // ===========================================================================
  // FINANCIAL & BANKING
  // ===========================================================================

  static const IconData account = Icons.account_balance_outlined;
  static const IconData accountFilled = Icons.account_balance;
  static const IconData card = Icons.credit_card;
  static const IconData cardOutlined = Icons.credit_card_outlined;
  static const IconData wallet = Icons.account_balance_wallet_outlined;
  static const IconData walletFilled = Icons.account_balance_wallet;
  static const IconData payment = Icons.payment;
  static const IconData receipt = Icons.receipt_outlined;
  static const IconData receiptFilled = Icons.receipt;
  static const IconData transaction = Icons.swap_horiz;
  static const IconData transfer = Icons.send;
  static const IconData deposit = Icons.arrow_downward;
  static const IconData withdraw = Icons.arrow_upward;
  static const IconData loan = Icons.account_balance;
  static const IconData investment = Icons.trending_up;
  static const IconData savings = Icons.savings_outlined;
  static const IconData savingsFilled = Icons.savings;

  // ===========================================================================
  // CURRENCY & MONEY
  // ===========================================================================

  static const IconData dollar = Icons.attach_money;
  static const IconData euro = Icons.euro;
  static const IconData ruble = Icons.currency_ruble;
  static const IconData yen = Icons.currency_yen;
  static const IconData pound = Icons.currency_pound;
  static const IconData bitcoin = Icons.currency_bitcoin;
  static const IconData exchange = Icons.currency_exchange;

  // ===========================================================================
  // USER & PROFILE
  // ===========================================================================

  static const IconData user = Icons.person_outlined;
  static const IconData userFilled = Icons.person;
  static const IconData users = Icons.people_outlined;
  static const IconData usersFilled = Icons.people;
  static const IconData profile = Icons.account_circle_outlined;
  static const IconData profileFilled = Icons.account_circle;
  static const IconData security = Icons.security;
  static const IconData fingerprint = Icons.fingerprint;
  static const IconData faceId = Icons.face;

  // ===========================================================================
  // COMMUNICATION
  // ===========================================================================

  static const IconData notification = Icons.notifications_outlined;
  static const IconData notificationFilled = Icons.notifications;
  static const IconData message = Icons.message_outlined;
  static const IconData messageFilled = Icons.message;
  static const IconData email = Icons.email_outlined;
  static const IconData emailFilled = Icons.email;
  static const IconData phone = Icons.phone_outlined;
  static const IconData phoneFilled = Icons.phone;
  static const IconData chat = Icons.chat_outlined;
  static const IconData chatFilled = Icons.chat;

  // ===========================================================================
  // STATUS & FEEDBACK
  // ===========================================================================

  static const IconData success = Icons.check_circle_outlined;
  static const IconData successFilled = Icons.check_circle;
  static const IconData error = Icons.error_outlined;
  static const IconData errorFilled = Icons.error;
  static const IconData warning = Icons.warning_outlined;
  static const IconData warningFilled = Icons.warning;
  static const IconData info = Icons.info_outlined;
  static const IconData infoFilled = Icons.info;
  static const IconData help = Icons.help_outlined;
  static const IconData helpFilled = Icons.help;

  // ===========================================================================
  // ACTIONS & CONTROLS
  // ===========================================================================

  static const IconData add = Icons.add;
  static const IconData remove = Icons.remove;
  static const IconData edit = Icons.edit_outlined;
  static const IconData editFilled = Icons.edit;
  static const IconData delete = Icons.delete_outlined;
  static const IconData deleteFilled = Icons.delete;
  static const IconData copy = Icons.content_copy;
  static const IconData share = Icons.share;
  static const IconData download = Icons.download;
  static const IconData upload = Icons.upload;
  static const IconData refresh = Icons.refresh;
  static const IconData favorite = Icons.favorite_border;
  static const IconData favoriteFilled = Icons.favorite;

  // ===========================================================================
  // TIME & CALENDAR
  // ===========================================================================

  static const IconData calendar = Icons.calendar_today;
  static const IconData dateRange = Icons.date_range;
  static const IconData schedule = Icons.schedule;
  static const IconData time = Icons.access_time;
  static const IconData history = Icons.history;

  // ===========================================================================
  // LOCATION & MAPS
  // ===========================================================================

  static const IconData location = Icons.location_on;
  static const IconData locationOutlined = Icons.location_on_outlined;
  static const IconData map = Icons.map;
  static const IconData navigation = Icons.navigation;

  // ===========================================================================
  // FONT AWESOME ICONS (Additional banking icons)
  // ===========================================================================

  // Banking specific
  static const IconData bank = FontAwesomeIcons.buildingColumns;
  static const IconData piggyBank = FontAwesomeIcons.piggyBank;
  static const IconData moneyBill = FontAwesomeIcons.moneyBill;
  static const IconData moneyBillWave = FontAwesomeIcons.moneyBillWave;
  static const IconData creditCardAlt = FontAwesomeIcons.creditCard;
  static const IconData chartLine = FontAwesomeIcons.chartLine;
  static const IconData chartPie = FontAwesomeIcons.chartPie;
  static const IconData chartBar = FontAwesomeIcons.chartBar;
  static const IconData trendingUp = FontAwesomeIcons.arrowTrendUp;
  static const IconData trendingDown = FontAwesomeIcons.arrowTrendDown;

  // Security
  static const IconData shield = FontAwesomeIcons.shield;
  static const IconData shieldCheck = FontAwesomeIcons.shieldHalved;
  static const IconData lock = FontAwesomeIcons.lock;
  static const IconData unlock = FontAwesomeIcons.unlock;

  // Communication
  static const IconData envelope = FontAwesomeIcons.envelope;
  static const IconData phoneAlt = FontAwesomeIcons.phone;
  static const IconData comment = FontAwesomeIcons.comment;

  // ===========================================================================
  // TRANSACTION TYPE ICONS
  // ===========================================================================

  static const Map<String, IconData> transactionIcons = {
    'transfer': transfer,
    'deposit': deposit,
    'withdraw': withdraw,
    'payment': payment,
    'loan': loan,
    'investment': investment,
    'savings': savings,
    'shopping': Icons.shopping_cart_outlined,
    'food': Icons.restaurant_outlined,
    'transport': Icons.directions_car_outlined,
    'entertainment': Icons.movie_outlined,
    'health': Icons.local_hospital_outlined,
    'education': Icons.school_outlined,
    'utilities': Icons.flash_on_outlined,
    'other': Icons.more_horiz,
  };

  // ===========================================================================
  // UTILITY METHODS
  // ===========================================================================

  /// Get icon by transaction type
  static IconData getTransactionIcon(String type) {
    return transactionIcons[type.toLowerCase()] ?? transactionIcons['other']!;
  }

  /// Get appropriate icon for amount (positive/negative)
  static IconData getAmountIcon(double amount) {
    return amount >= 0 ? trendingUp : trendingDown;
  }

  /// Get status icon by type
  static IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'success':
      case 'completed':
      case 'approved':
        return successFilled;
      case 'error':
      case 'failed':
      case 'rejected':
        return errorFilled;
      case 'warning':
      case 'pending':
        return warningFilled;
      case 'info':
      case 'processing':
        return infoFilled;
      default:
        return info;
    }
  }

  /// Get navigation icon by route name
  static IconData getNavigationIcon(String route) {
    switch (route.toLowerCase()) {
      case 'home':
      case 'dashboard':
        return home;
      case 'accounts':
      case 'cards':
        return card;
      case 'transactions':
        return transaction;
      case 'transfer':
        return transfer;
      case 'profile':
      case 'settings':
        return settings;
      default:
        return home;
    }
  }
}

/// Custom icon data for banking-specific icons that aren't in standard sets
class BankingIconData extends IconData {
  const BankingIconData(int codePoint)
      : super(
          codePoint,
          fontFamily: 'BankingIcons',
          fontPackage: 'banki2',
        );
}

/// Extension methods for easier icon usage
extension BankingIconExtension on IconData {
  /// Create an Icon widget with banking-appropriate size
  Icon icon({
    Key? key,
    double? size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return Icon(
      this,
      key: key,
      size: size ?? 24.0,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }

  /// Create a small icon
  Icon small({Color? color}) => icon(size: 16.0, color: color);

  /// Create a medium icon (default)
  Icon medium({Color? color}) => icon(size: 24.0, color: color);

  /// Create a large icon
  Icon large({Color? color}) => icon(size: 32.0, color: color);
}

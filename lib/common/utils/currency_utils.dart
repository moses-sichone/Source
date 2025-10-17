import 'package:intl/intl.dart';
import 'package:webinar/app/models/currency_model.dart';
import 'package:webinar/app/services/guest_service/guest_service.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/data/app_data.dart';

class CurrencyUtils{

  static late String userCurrency;
  
  CurrencyUtils(){
    AppData.getCurrency().then((value) {
      userCurrency = value;
      GuestService.getCurrencyList();
    });
  }
  

  init(){
    AppData.getCurrency().then((value) {
      userCurrency = value;
    });
  }

  static String getSymbol(String currency){
    var format = NumberFormat.simpleCurrency(name: currency);

    return format.currencySymbol;
  }
  

  static String calculator(var price) {
    String? symbol;

    // multi_currency is off
    if(PublicData.apiConfigData?['multi_currency'] == false){
      symbol = getSymbol(PublicData.apiConfigData?['currency']['name']);
    }

    symbol ??= getSymbol(userCurrency);

    
    if(PublicData.currencyListData.indexWhere((element) => element.currency == userCurrency) == -1){
      return PublicData.apiConfigData?['currency_position']?.toString().toLowerCase() == 'right' ? '$price$symbol' : '$symbol$price';
    }

    CurrencyModel currency =  PublicData.currencyListData[PublicData.currencyListData.indexWhere((element) => element.currency == userCurrency)];
    double newPrice = (price ?? 0.0) * (currency.exchangeRate ?? 1.0);

    return currency.currencyPosition?.toString().toLowerCase() == 'right'
        ? '${newPrice.toStringAsFixed(currency.currencyDecimal ?? 0)}$symbol'
        : '$symbol${newPrice.toStringAsFixed(currency.currencyDecimal ?? 0)}';
  }
}
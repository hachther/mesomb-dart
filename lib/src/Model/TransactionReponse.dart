

class TransactionResponse 
{
  late bool success;
  late String? message;
  late String? redirect;
  late List<dynamic> data;
  late String? reference;
  late String status;

  TransactionResponse(Map<String, dynamic> data) 
  {
    this.success = data['success'];
    this.message = data['message'];
    this.redirect = data['redirect'];
    this.data = data['transaction'];
    this.reference = data['reference'];
    this.status = data['status'];
  }

  bool isOperationSuccess() 
  {
    return this.success;
  }

  bool isTransactionSuccess() 
  {
    return this.success && this.status == 'SUCCESS';
  }

  
  bool getSuccess() 
  {
    return this.success;
  }

  
  String? getMessage() 
  {
    return this.message;
  }


  String? getRedirect() 
  {
    return this.redirect;
  }

  
  List<dynamic> getData() 
  {
    return this.data;
  }

  
  String? getReference() 
  {
    return this.reference;
  }

  
  String getStatus() 
  {
    return this.status;
  }

}

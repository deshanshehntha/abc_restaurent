class Cart{

  String title;
  double amount;
  int quantity;
  double total;

  setTitle(String title){
    this.title = title;
  }

  setTotal( double total ){
    this.total = total;
  }

  setAmount( double amount){
    this.amount = amount;
  }


  setQuantity( int quantity ){
    this.quantity = quantity;
  }

  String getTitle(){
    return this.title;
  }

  double getAmount(){
    return this.amount;
  }

  int getQuantity(){
    return this.quantity;
  }

  double getTotal(){
    return this.total;
  }

  @override
  String toString() {
    return '{ ${this.title}, ${this.quantity} }';
  }
}
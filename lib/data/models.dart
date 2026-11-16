enum FieldType { phone, amount, text, select }

class Field {
  final String key, label;
  final FieldType type;
  final List<String> options;
  final bool optional;
  const Field(this.key, this.label, this.type,
      {this.options = const [], this.optional = false});
}

class ServiceDef {
  final String id, nameBn, icon;
  final List<Field> fields;
  final double Function(double) fee;
  final bool credit, noBalance;
  ServiceDef(this.id, this.nameBn, this.icon, this.fields, this.fee,
      {this.credit = false, this.noBalance = false});
}

class Txn {
  final String id, title, phone, ref;
  final double amount, fee, balanceAfter;
  final DateTime at;
  final bool credit, isSend;
  Txn({required this.id, required this.title, required this.phone,
      required this.ref, required this.amount, required this.fee,
      required this.balanceAfter, required this.at,
      required this.credit, required this.isSend});
}

class InboxMsg {
  final String title, body, kind; // kind: txn | offer
  final DateTime at;
  InboxMsg(this.title, this.body, this.kind, this.at);
}

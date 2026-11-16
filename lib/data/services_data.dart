import 'models.dart';

const _phone = Field('acc', 'প্রাপকের নম্বর', FieldType.phone);
const _amt = Field('amt', 'পরিমাণ (৳)', FieldType.amount);
const _ref = Field('ref', 'রেফারেন্স (ঐচ্ছিক)', FieldType.text, optional: true);
const _bank = Field('bank', 'ব্যাংক', FieldType.select,
    options: ['ডাচ-বাংলা ব্যাংক', 'ব্র্যাক ব্যাংক', 'সিটি ব্যাংক', 'ইসলামী ব্যাংক']);
const _accno = Field('accno', 'অ্যাকাউন্ট নম্বর', FieldType.text);
double _zero(double a) => 0;
Field _sel(String k, String l, List<String> o) =>
    Field(k, l, FieldType.select, options: o);

final services = <ServiceDef>[
  ServiceDef('send', 'সেন্ড মানি', 'send_money', [_phone, _amt, _ref], _zero),
  ServiceDef('recharge', 'মোবাইল রিচার্জ', 'recharge', [
    _sel('op', 'অপারেটর', ['গ্রামীণফোন', 'রবি', 'বাংলালিংক', 'এয়ারটেল', 'টেলিটক']),
    const Field('acc', 'মোবাইল নম্বর', FieldType.phone), _amt], _zero),
  ServiceDef('cashout', 'ক্যাশ আউট', 'cash_out',
      [const Field('acc', 'এজেন্ট নম্বর', FieldType.phone), _amt], (a) => a * 0.0185),
  ServiceDef('payment', 'পেমেন্ট', 'payment',
      [const Field('acc', 'মার্চেন্ট নম্বর', FieldType.phone), _amt, _ref], _zero),
  ServiceDef('addmoney', 'অ্যাড মানি', 'add_money', [_bank, _accno, _amt], _zero,
      credit: true),
  ServiceDef('bill', 'পে বিল', 'pay_bill', [
    _sel('biller', 'বিলার', ['DESCO', 'DPDC', 'Titas Gas', 'Dhaka WASA', 'Link3']),
    _accno, _amt], (a) => a < 1000 ? 10 : a * 0.01),
  ServiceDef('savings', 'সেভিংস', 'savings', [_amt], _zero),
  ServiceDef('loan', 'লোন', 'loan', [_amt], _zero, credit: true),
  ServiceDef('insurance', 'ইন্স্যুরেন্স', 'insurance', [
    _sel('plan', 'প্ল্যান', ['লাইফ', 'হেলথ', 'অ্যাক্সিডেন্ট']),
    const Field('nominee', 'নমিনির নাম', FieldType.text), _amt], _zero),
  ServiceDef('bank', 'বিকাশ টু ব্যাংক', 'bkash_to_bank', [_bank, _accno, _amt],
      (a) => a * 0.005),
  ServiceDef('edu', 'এডুকেশন ফি', 'education', [
    _sel('inst', 'প্রতিষ্ঠান', ['ঢাকা বিশ্ববিদ্যালয়', 'বুয়েট', 'জাতীয় বিশ্ববিদ্যালয়']),
    const Field('sid', 'স্টুডেন্ট আইডি', FieldType.text), _amt], (a) => a * 0.01),
  ServiceDef('micro', 'মাইক্রোফাইন্যান্স', 'microfinance', [
    _sel('ngo', 'সংস্থা', ['ব্র্যাক', 'আশা', 'গ্রামীণ ব্যাংক']),
    const Field('mid', 'সদস্য আইডি', FieldType.text), _amt], _zero),
  ServiceDef('toll', 'টোল', 'toll', [
    _sel('br', 'ব্রিজ', ['পদ্মা সেতু', 'যমুনা সেতু']),
    const Field('plate', 'গাড়ির নম্বর', FieldType.text), _amt], _zero),
  ServiceDef('request', 'রিকোয়েস্ট মানি', 'request_money', [_phone, _amt, _ref],
      _zero, noBalance: true),
  ServiceDef('remit', 'রেমিট্যান্স', 'remittance', [
    _sel('src', 'মাধ্যম', ['Western Union', 'Wise', 'Remitly']),
    const Field('refno', 'রেফারেন্স নম্বর', FieldType.text), _amt], _zero,
      credit: true),
  ServiceDef('donate', 'ডোনেশন', 'donation', [
    _sel('org', 'সংস্থা', ['রেড ক্রিসেন্ট', 'ব্র্যাক', 'জাকাত ফান্ড']), _amt], _zero),
];

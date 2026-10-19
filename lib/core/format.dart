String money(double value) => '\$${value.toStringAsFixed(2)}';

String shortDate(String iso) {
  final parsed = DateTime.tryParse(iso);
  if (parsed == null) return '';
  return parsed.toLocal().toString().split(' ').first;
}

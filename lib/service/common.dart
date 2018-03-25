class PeriodUtils {
  static String dateToStorageKey(DateTime d) =>
      [d.year, d.month, d.day].map((v) => '$v'.padLeft(2, '0')).join('-');
}

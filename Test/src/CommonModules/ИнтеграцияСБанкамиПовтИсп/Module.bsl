#Область ПрограммныйИнтерфейс

// Возвращает Истина, если в базе есть хотя бы одна действующая настройка интеграции.
// 
// Возвращаемое значение:
//   Булево - признак наличия действующей настройки интеграции.
//
Функция ИнтеграцияВИнформационнойБазеВключена() Экспорт
	
	Возврат Справочники.НастройкиИнтеграцииСБанками.ИнтеграцияВИнформационнойБазеВключена();
	
КонецФункции

// Возвращает Истина, если для расчетного счета включена интеграция.
//
// Параметры:
//  СчетОрганизации	 - СправочникСсылка.БанковскиеСчета - Ссылка на расчетный счет организации.
// 
// Возвращаемое значение:
//   Булево - признак включенной интеграции для расчетного счета.
//
Функция ИнтеграцияВключена(СчетОрганизации) Экспорт
	
	Возврат Справочники.НастройкиИнтеграцииСБанками.ИнтеграцияВключена(СчетОрганизации);
	
КонецФункции

// Возвращает префикс информационной базы для платежных поручений из банка.
//
// Параметры:
//  Банк - СправочникСсылка.Банки - Банк, для которого нужно определить префикс.
//
// Возвращаемое значение:
//   Строка - префикс информационной базы для платежных поручений.
//
Функция ПрефиксБанкаИнтеграции(Банк) Экспорт
	
	Возврат Справочники.НастройкиИнтеграцииСБанками.ПрефиксБанкаИнтеграции(Банк);
	
КонецФункции

#КонецОбласти

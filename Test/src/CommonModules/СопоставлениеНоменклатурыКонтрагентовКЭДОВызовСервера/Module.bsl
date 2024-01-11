////////////////////////////////////////////////////////////////////////////////
// Подсистема "Клиент ЭДО".
// ОбщийМодуль.СопоставлениеНоменклатурыКонтрагентовКЭДОВызовСервера.
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ИнтеграцияПодсистемы

// Возвращает единицу хранения номенклатуры.
//
// Параметры:
//  Номенклатура - СправочникСсылка.Номенклатура - ссылка номенклатуры,
//
// Возвращаемое значение:
//  СправочникСсылка.УпаковкиЕдиницыИзмерения - единица хранения номенклатуры.
//
Функция ЕдиницаХраненияНоменклатуры(Знач Номенклатура) Экспорт
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Номенклатура, "ЕдиницаИзмерения");
	
КонецФункции

// Возвращает ключевые сведения о номенклатуре контрагента
//
// Параметры:
//  НоменклатураКонтрагента - СправочникСсылка.НоменклатураКонтрагентов - ссылка на номенклатуру контрагента
// 
// Возвращаемое значение:
//  Структура - сведения о номенклатуре контрагента:
//    * Номенклатура   - СправочникСсылка.Номенклатура               - сопоставленная номенклатура
//    * Характеристика - СправочникСсылка.ХарактеристикиНоменклатуры - сопоставленная характеристика номенклатуры
//    * Упаковка       - СправочникСсылка.ЕдиницыИзмерения           - сопоставленная упаковка номенклатуры
//
Функция ДанныеНоменклатурыКонтрагента(НоменклатураКонтрагента) Экспорт
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(НоменклатураКонтрагента, "Номенклатура, Характеристика, Упаковка");
	
КонецФункции

// См. СопоставлениеНоменклатурыКонтрагентов.НоменклатураКонтрагентаПоНоменклатуреВСтрокеТаблицы.
//
Функция НоменклатураКонтрагентаПоНоменклатуреВСтрокеТаблицы(Контрагент, НоменклатураИБ) Экспорт
	
	Возврат СопоставлениеНоменклатурыКонтрагентов.НоменклатураКонтрагентаПоНоменклатуреВСтрокеТаблицы(Контрагент, НоменклатураИБ);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает сумму остатка товаров в ценах поставщиков.
//
Функция ПолучитьСуммуОстаткаТоваровВЦенахПоставщиков() Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОстаткиТоваровОстатки.Товар КАК Товар,
	|	ОстаткиТоваровОстатки.КоличествоОстаток КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ОстаткиТоваровМП.Остатки КАК ОстаткиТоваровОстатки";
	
	ВыборкаОстатков = Запрос.Выполнить().Выбрать();
	
	СуммаОстатка = 0;
	Пока ВыборкаОстатков.Следующий() Цикл
		СуммаОстатка = СуммаОстатка + РегистрыСведений.ЦеныПоставщиковМП.ПолучитьЦенуТовара(, ВыборкаОстатков.Товар) * ВыборкаОстатков.КоличествоОстаток;
	КонецЦикла;
	
	Возврат СуммаОстатка;
	
КонецФункции

// Получает количество остатка товара.
//
Функция ПолучитьКоличествоОстаткаТовара(Товар) Экспорт
	
	Запрос = Новый Запрос();
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЕСТЬNULL(ОстаткиТоваровОстатки.КоличествоОстаток, 0) КАК КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.ОстаткиТоваровМП.Остатки(, Товар = &Товар) КАК ОстаткиТоваровОстатки";
	
	Запрос.УстановитьПараметр("Товар", Товар);
	
	ВыборкаОстатков = Запрос.Выполнить().Выбрать();
	
	Если ВыборкаОстатков.Следующий() Тогда
		Возврат ВыборкаОстатков.КоличествоОстаток;
	Иначе
		Возврат 0;
	КонецЕсли;
	
КонецФункции

// Получает остатки товаров.
//
Функция ПолучитьОстаткиТоваров(Отбор = Неопределено) Экспорт
	
	Запрос = Новый Запрос();
	
	Если ЗначениеЗаполнено(Отбор) Тогда
		Если Отбор.ЭтоГруппа Тогда
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ОстаткиТоваровОстатки.Товар КАК Товар,
			|	ОстаткиТоваровОстатки.КоличествоОстаток КАК Количество,
			|	ОстаткиТоваровОстатки.СуммаОстаток КАК Сумма,
			|	ОстаткиТоваровОстатки.Товар.Наименование КАК НаименованиеТовара
			|ИЗ
			|	РегистрНакопления.ОстаткиТоваровМП.Остатки(, Товар.Родитель = &Отбор) КАК ОстаткиТоваровОстатки
			|
			|УПОРЯДОЧИТЬ ПО
			|	НаименованиеТовара";
		Иначе
			Запрос.Текст =
			"ВЫБРАТЬ
			|	ОстаткиТоваровОстатки.Товар КАК Товар,
			|	ОстаткиТоваровОстатки.КоличествоОстаток КАК Количество,
			|	ОстаткиТоваровОстатки.СуммаОстаток КАК Сумма,
			|	ОстаткиТоваровОстатки.Товар.Наименование КАК НаименованиеТовара
			|ИЗ
			|	РегистрНакопления.ОстаткиТоваровМП.Остатки(, Товар = &Отбор) КАК ОстаткиТоваровОстатки
			|
			|УПОРЯДОЧИТЬ ПО
			|	НаименованиеТовара";
		КонецЕсли;
		Запрос.УстановитьПараметр("Отбор", Отбор);
	Иначе
		Запрос.Текст =
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Товар КАК Товар,
		|	ОстаткиТоваровОстатки.КоличествоОстаток КАК Количество,
		|	ОстаткиТоваровОстатки.СуммаОстаток КАК Сумма,
		|	ОстаткиТоваровОстатки.Товар.Наименование КАК НаименованиеТовара
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваровМП.Остатки КАК ОстаткиТоваровОстатки
		|
		|УПОРЯДОЧИТЬ ПО
		|	НаименованиеТовара";
	КонецЕсли;
	
	ТаблицаОстатков = Запрос.Выполнить().Выгрузить();
	
	Возврат ТаблицаОстатков;
	
КонецФункции

#КонецОбласти

#КонецЕсли

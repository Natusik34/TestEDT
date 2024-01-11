#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И( ЗначениеРазрешено(Касса)
	|	ИЛИ ТипДенежныхСредств <> Значение(Перечисление.ТипыДенежныхСредств.Наличные)
	|	ИЛИ ЗначениеРазрешено(КассаПолучатель)
	|	ИЛИ ТипДенежныхСредствПолучатель <> Значение(Перечисление.ТипыДенежныхСредств.Наличные)
	|	) ";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Определяет список команд заполнения.
//
// Параметры:
//   КомандыЗаполнения - ТаблицаЗначений - Таблица с командами заполнения. Для изменения.
//       См. описание 1 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ЗаполнениеОбъектовПереопределяемый.ПередДобавлениемКомандЗаполнения().
//
Процедура ДобавитьКомандыЗаполнения(КомандыЗаполнения, Параметры) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#КонецОбласти

// Процедура формирования таблицы платежного календаря.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПеремещениеДСПлан - Текущий документ,
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа.
Процедура СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств КАК Статья,
	|	ТаблицаДокумента.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ТаблицаДокумента.СтатусУтвержденияПлатежа КАК СтатусУтвержденияПлатежа,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Касса
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	&Ссылка КАК СчетНаОплату,
	|	ТаблицаДокумента.ВалютаДокумента КАК Валюта,
	|	-ТаблицаДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.ПеремещениеДСПлан КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаДокумента.Дата,
	|	&Организация,
	|	ТаблицаДокумента.СтатьяДвиженияДенежныхСредств,
	|	ТаблицаДокумента.ТипДенежныхСредствПолучатель,
	|	ТаблицаДокумента.СтатусУтвержденияПлатежа,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредствПолучатель = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.КассаПолучатель
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредствПолучатель = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.БанковскийСчетПолучатель
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ,
	|	&Ссылка,
	|	ТаблицаДокумента.ВалютаДокумента,
	|	ТаблицаДокумента.СуммаДокумента
	|ИЗ
	|	Документ.ПеремещениеДСПлан КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлатежныйКалендарь", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Процедура формирования таблицы денежных средств в резерве.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПеремещениеДСПлан - Текущий документ,
//	ДополнительныеСвойства - ДополнительныеСвойства - Дополнительные свойства документа.
Процедура СформироватьТаблицаДенежныеСредстваВРезерве(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.Дата КАК Период,
	|	&Организация КАК Организация,
	|	ТаблицаДокумента.ТипДенежныхСредств КАК ТипДенежныхСредств,
	|	ВЫБОР
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Наличные)
	|			ТОГДА ТаблицаДокумента.Касса
	|		КОГДА ТаблицаДокумента.ТипДенежныхСредств = ЗНАЧЕНИЕ(Перечисление.ТипыДенежныхСредств.Безналичные)
	|			ТОГДА ТаблицаДокумента.БанковскийСчет
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК БанковскийСчетКасса,
	|	&Ссылка КАК Документ,
	|	ТаблицаДокумента.ВалютаДокумента КАК Валюта,
	|	ТаблицаДокумента.СуммаДокумента КАК Сумма
	|ИЗ
	|	Документ.ПеремещениеДСПлан КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Ссылка = &Ссылка
	|	И ТаблицаДокумента.СтатусУтвержденияПлатежа = ЗНАЧЕНИЕ(Перечисление.СтатусыУтвержденияПлатежей.Утвержден)
	|	И ТаблицаДокумента.РезервироватьДенежныеСредства";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДенежныеСредстваВРезерве",
		РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаПлатежныйКалендарь()

// Формирует таблицу данных документа.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ПеремещениеДСПлан - Текущий документ,
//	СтруктураДополнительныеСвойства - Структура - Дополнительные свойства документа.
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	СформироватьТаблицаПлатежныйКалендарь(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДенежныеСредстваВРезерве(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если НЕ Константы.КонтролироватьОстаткиПриПроведении.Получить() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	Если ПолучитьФункциональнуюОпцию("ИспользоватьРезервированиеДенежныхСредств") Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
		|	ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|	ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКассаПредставление,
		|	ДенежныеСредстваВРезервеОстатки.Валюта КАК Валюта,
		|	ДенежныеСредстваВРезервеОстатки.Документ КАК Документ,
		|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток КАК ВРезерве
		|ИЗ
		|	РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментКонтроля, Документ = &СсылкаНаДокумент) КАК ДенежныеСредстваВРезервеОстатки
		|ГДЕ
		|	ДенежныеСредстваВРезервеОстатки.СуммаОстаток < 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ДвиженияДенежныеСредстваВРезервеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.Организация КАК ОрганизацияПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса КАК БанковскийСчетКассаПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.Валюта КАК ВалютаПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств КАК ТипДенежныхСредствПредставление,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаОстаток, 0) КАК СуммаОстаток,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК ОстатокДенежныхСредств,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПриЗаписи КАК СуммаПриЗаписи,
		|	ДвиженияДенежныеСредстваВРезервеИзменение.СуммаИзменение КАК СуммаИзменение,
		|	ЕСТЬNULL(РезервыПоДокументам.СуммаОстаток, 0) + ЕСТЬNULL(НеснижаемыеОстаткиДенежныхСредствСрезПоследних.СуммаНеснижаемогоОстатка, 0) - ДвиженияДенежныеСредстваВРезервеИзменение.СуммаПриЗаписи КАК ВРезерве,
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) КАК СвободныйОстаток
		|ИЗ
		|	ДвиженияДенежныеСредстваВРезервеИзменение КАК ДвиженияДенежныеСредстваВРезервеИзменение
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДенежныеСредства.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваОстатки
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.Организация = ДенежныеСредстваОстатки.Организация
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = ДенежныеСредстваОстатки.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = ДенежныеСредстваОстатки.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = ДенежныеСредстваОстатки.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НеснижаемыеОстаткиДенежныхСредств.СрезПоследних(&МоментКонтроля, ) КАК НеснижаемыеОстаткиДенежныхСредствСрезПоследних
		|		ПО ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = НеснижаемыеОстаткиДенежныхСредствСрезПоследних.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ДенежныеСредстваВРезервеОстатки.Организация КАК Организация,
		|			ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств КАК ТипДенежныхСредств,
		|			ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса КАК БанковскийСчетКасса,
		|			ДенежныеСредстваВРезервеОстатки.Валюта КАК Валюта,
		|			СУММА(ДенежныеСредстваВРезервеОстатки.СуммаОстаток) КАК СуммаОстаток
		|		ИЗ
		|			РегистрНакопления.ДенежныеСредстваВРезерве.Остатки(&МоментКонтроля, ) КАК ДенежныеСредстваВРезервеОстатки
		|		
		|		СГРУППИРОВАТЬ ПО
		|			ДенежныеСредстваВРезервеОстатки.Организация,
		|			ДенежныеСредстваВРезервеОстатки.ТипДенежныхСредств,
		|			ДенежныеСредстваВРезервеОстатки.БанковскийСчетКасса,
		|			ДенежныеСредстваВРезервеОстатки.Валюта) КАК РезервыПоДокументам
		|		ПО (ДенежныеСредстваОстатки.Организация = РезервыПоДокументам.Организация)
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.ТипДенежныхСредств = РезервыПоДокументам.ТипДенежныхСредств
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.БанковскийСчетКасса = РезервыПоДокументам.БанковскийСчетКасса
		|			И ДвиженияДенежныеСредстваВРезервеИзменение.Валюта = РезервыПоДокументам.Валюта
		|ГДЕ
		|	ЕСТЬNULL(ДенежныеСредстваОстатки.СуммаВалОстаток, 0) - (ЕСТЬNULL(НеснижаемыеОстаткиДенежныхСредствСрезПоследних.СуммаНеснижаемогоОстатка, 0) + ЕСТЬNULL(РезервыПоДокументам.СуммаОстаток, 0)) < 0");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		Запрос.УстановитьПараметр("СсылкаНаДокумент", ДокументСсылка);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если 	НЕ МассивРезультатов[0].Пустой()
			ИЛИ НЕ МассивРезультатов[1].Пустой() Тогда
			ДокументОбъектПеремещениеДСПлан = ДокументСсылка.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам в резерве.
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			КонтрольОстатковУНФ.ДенежныеСредстваВРезерве(ДокументОбъектПеремещениеДСПлан, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
		// Отрицательный остаток по денежным средствам с учетом резервов.
		Если НЕ МассивРезультатов[1].Пустой() Тогда //Если остатка денежных средств не хватает, то выводить ошибку по резервам нет смысла
			Если ДокументОбъектПеремещениеДСПлан.РезервироватьДенежныеСредства Тогда
				ВыборкаИзРезультатаЗапроса = МассивРезультатов[1].Выбрать();
				КонтрольОстатковУНФ.ДенежныеСредстваСУчетомРезервов(ДокументОбъектПеремещениеДСПлан, ВыборкаИзРезультатаЗапроса, Отказ);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#Область ВерсионированиеОбъектов

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	Возврат;
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#КонецОбласти

#Область ИнтерфейсПечати

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	Возврат;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
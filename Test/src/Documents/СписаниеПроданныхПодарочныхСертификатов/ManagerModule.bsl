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
	|	ЗначениеРазрешено(Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти
	
// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства) Экспорт

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	КурсыВалютСрезПоследних.Курс КАК Курс,
	|	КурсыВалютСрезПоследних.Кратность КАК Кратность
	|ПОМЕСТИТЬ КурсыВалют
	|ИЗ
	|	РегистрСведений.КурсыВалют.СрезПоследних(&МоментВремени, Валюта В (&ВалютаНациональная, &ВалютаУчета)) КАК КурсыВалютСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.НомерСтроки КАК НомерСтроки,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Ссылка.Дата КАК Период,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Ссылка.Организация КАК Организация,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Ссылка.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Ссылка.Корреспонденция КАК СчетУчета,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.НомерСертификата КАК НомерСертификата,
	|	ВЫРАЗИТЬ(СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Остаток * КурсыНац.Курс * КурсыУпр.Кратность / (КурсыУпр.Курс * КурсыНац.Кратность) КАК ЧИСЛО(15, 2)) КАК Сумма,
	|	ВЫРАЗИТЬ(СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Остаток * КурсыНац.Курс / КурсыНац.Кратность КАК ЧИСЛО(15, 2)) КАК СуммаВал,
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Остаток КАК ОстатокСертификата
	|ПОМЕСТИТЬ ВременнаяТаблицаПодарочныеСертификаты
	|ИЗ
	|	Документ.СписаниеПроданныхПодарочныхСертификатов.ПодарочныеСертификаты КАК СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыНац
	|		ПО (КурсыНац.Валюта = &ВалютаНациональная)
	|		ЛЕВОЕ СОЕДИНЕНИЕ КурсыВалют КАК КурсыУпр
	|		ПО (КурсыУпр.Валюта = &ВалютаУчета)
	|ГДЕ
	|	СписаниеПроданныхПодарочныхСертификатовПодарочныеСертификаты.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаСписаниеСертификатов);
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	Запрос.УстановитьПараметр("ВалютаНациональная", Константы.НациональнаяВалюта.Получить());
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// Сформируем пустую таблицу проводок.
	ПроведениеДокументовУНФ.СформироватьТаблицуПроводок(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства);
	
	СформироватьТаблицаПодарочныеСертификаты(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства);
	СформироватьТаблицаРасчетыСПокупателями(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства);
	СформироватьТаблицаДоходыИРасходы(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства);
	СформироватьТаблицаУправленческий(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Формирует таблицу значение, содержащую данные для проведения по регистру.
// Таблицу значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаПодарочныеСертификаты(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВременнаяТаблицаОплатаПлатежнымиКартами.Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ВременнаяТаблицаОплатаПлатежнымиКартами.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ВременнаяТаблицаОплатаПлатежнымиКартами.НомерСертификата КАК НомерСертификата,
	|	ВременнаяТаблицаОплатаПлатежнымиКартами.ОстатокСертификата КАК Сумма
	|ИЗ
	|	ВременнаяТаблицаПодарочныеСертификаты КАК ВременнаяТаблицаОплатаПлатежнымиКартами";
	
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПодарочныеСертификаты", РезультатЗапроса);
	
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаРасчетыСПокупателями(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаСписаниеСертификатов);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ПериодКонтроля", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени.Дата);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("ВалютаРасчетов", Константы.НациональнаяВалюта.Получить());
	Запрос.УстановитьПараметр("СписаниеАванса", НСтр("ru='Списание предоплаты'"));
	
	Для Каждого КлючИЗначение Из СтруктураДополнительныеСвойства.ДляСертификатов Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	// Формирование временной таблицы по расчетам с покупателями.
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	&КонтрагентДляПредоплаты КАК Контрагент,
	|	ЛОЖЬ КАК ВестиРасчетыПоДокументам,
	|	&СчетУчетаАвансовПокупателя КАК СчетУчета,
	|	&ДоговорПоУмолчанию КАК Договор,
	|	НЕОПРЕДЕЛЕНО КАК Документ,
	|	ЗНАЧЕНИЕ(Документ.ЗаказПокупателя.ПустаяСсылка) КАК Заказ,
	|	&ВалютаРасчетов КАК Валюта,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыРасчетов.Аванс) КАК ТипРасчетов,
	|	СУММА(ТаблицаДокумента.Сумма) КАК Сумма,
	|	СУММА(ТаблицаДокумента.СуммаВал) КАК СуммаВал,
	|	СУММА(ТаблицаДокумента.Сумма) КАК СуммаДляОстатка,
	|	СУММА(ТаблицаДокумента.СуммаВал) КАК СуммаВалДляОстатка,
	|	ВЫРАЗИТЬ(&СписаниеАванса КАК СТРОКА(100)) КАК СодержаниеПроводки
	|ИЗ
	|	ВременнаяТаблицаПодарочныеСертификаты КАК ТаблицаДокумента
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаДокумента.Период,
	|	ТаблицаДокумента.Организация";
	
	Результат = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаРасчетыСПокупателями", Результат.Выгрузить());
	
КонецПроцедуры

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаДоходыИРасходы(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылкаСписаниеСертификатов);
	Запрос.УстановитьПараметр("Организация", СтруктураДополнительныеСвойства.ДляПроведения.Организация);
	Запрос.УстановитьПараметр("МоментВремени", Новый Граница(СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени, ВидГраницы.Включая));
	Запрос.УстановитьПараметр("СписаниеСертификатов", НСтр("ru = 'Списание сертификатов'"));
	
	Для Каждого КлючИЗначение Из СтруктураДополнительныеСвойства.ДляСертификатов Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ТаблицаДокумента.НомерСтроки КАК НомерСтроки,
	|	ТаблицаДокумента.Период КАК Период,
	|	ТаблицаДокумента.Организация КАК Организация,
	|	ТаблицаДокумента.СтруктурнаяЕдиница КАК СтруктурнаяЕдиница,
	|	НЕОПРЕДЕЛЕНО КАК Заказ,
	|	НЕОПРЕДЕЛЕНО КАК НаправлениеДеятельности,
	|	ТаблицаДокумента.СчетУчета КАК СчетУчета,
	|	&КонтрагентДляПредоплаты КАК Аналитика,
	|	&СписаниеСертификатов КАК СодержаниеПроводки,
	|	ТаблицаДокумента.Сумма КАК СуммаДоходов,
	|	0 КАК СуммаРасходов,
	|	ТаблицаДокумента.Сумма КАК Сумма
	|ИЗ
	|	ВременнаяТаблицаПодарочныеСертификаты КАК ТаблицаДокумента
	|
	|УПОРЯДОЧИТЬ ПО
	|	НомерСтроки";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДоходыИРасходы", РезультатЗапроса.Выгрузить());
	
КонецПроцедуры // СформироватьТаблицаДоходыИРасходы()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицаУправленческий(ДокументСсылкаСписаниеСертификатов, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	1 КАК Порядок,
	|	ТаблицаУправленческий.НомерСтроки КАК НомерСтроки,
	|	ТаблицаУправленческий.Период КАК Период,
	|	ТаблицаУправленческий.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Справочник.СценарииПланирования.Фактический) КАК СценарийПланирования,
	|	&СчетУчетаАвансовПокупателя КАК СчетДт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаДт,
	|	0 КАК СуммаВалДт,
	|	&Корреспонденция КАК СчетКт,
	|	НЕОПРЕДЕЛЕНО КАК ВалютаКт,
	|	0 КАК СуммаВалКт,
	|	ТаблицаУправленческий.Сумма КАК Сумма,
	|	ВЫРАЗИТЬ(&СписаниеАванса КАК СТРОКА(100)) КАК Содержание
	|ИЗ
	|	ВременнаяТаблицаПодарочныеСертификаты КАК ТаблицаУправленческий
	|ГДЕ
	|	ТаблицаУправленческий.Сумма <> 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	Порядок,
	|	НомерСтроки";
	
	Запрос.УстановитьПараметр("СписаниеАванса", НСтр("ru = 'Списание предоплаты'"));
	Запрос.УстановитьПараметр("ВалютаУчета", Константы.ВалютаУчета.Получить());
	Запрос.УстановитьПараметр("Корреспонденция", ДокументСсылкаСписаниеСертификатов.Корреспонденция);
	
	Для Каждого КлючИЗначение Из СтруктураДополнительныеСвойства.ДляСертификатов Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл  
		НоваяПроводка = СтруктураДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаУправленческий.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяПроводка, Выборка);
	КонецЦикла;
	
КонецПроцедуры // СформироватьТаблицаУправленческий()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылкаСписаниеСертификатов, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Если ПроведениеДокументовУНФ.КонтрольОстатковВыключен() Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Если временные таблицы "ДвиженияЗапасыИзменение", необходимо выполнить контроль реализации товаров.
	Если СтруктураВременныеТаблицы.ДвиженияПодарочныеСертификатыИзменение Тогда
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияПодарочныеСертификатыИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияПодарочныеСертификатыИзменение.ПодарочныйСертификат КАК ПодарочныйСертификат,
		|	ДвиженияПодарочныеСертификатыИзменение.НомерСертификата КАК НомерСертификата,
		|	ЕСТЬNULL(ДвиженияПодарочныеСертификатыИзменение.СуммаИзменение, 0) + ЕСТЬNULL(ПодарочныеСертификатыОстатки.СуммаОстаток, 0) КАК ОстатокПодарочныеСертификаты,
		|	ЕСТЬNULL(ПодарочныеСертификатыОстатки.СуммаОстаток, 0) КАК СуммаОстатокПодарочныеСертификаты
		|ИЗ
		|	ДвиженияПодарочныеСертификатыИзменение КАК ДвиженияПодарочныеСертификатыИзменение
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.ПодарочныеСертификаты.Остатки(&МоментКонтроля, ) КАК ПодарочныеСертификатыОстатки
		|		ПО ДвиженияПодарочныеСертификатыИзменение.ПодарочныйСертификат = ПодарочныеСертификатыОстатки.ПодарочныйСертификат
		|			И ДвиженияПодарочныеСертификатыИзменение.НомерСертификата = ПодарочныеСертификатыОстатки.НомерСертификата
		|			И (ЕСТЬNULL(ПодарочныеСертификатыОстатки.СуммаОстаток, 0) < 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки");
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		Если НЕ МассивРезультатов[0].Пустой() Тогда
			ДокументОбъектСписаниеСертификатов = ДокументСсылкаСписаниеСертификатов.ПолучитьОбъект()
		КонецЕсли;
		
		// Отрицательный остаток по подарочным сертификатам
		Если Не МассивРезультатов[0].Пустой() Тогда
			ВыборкаИзРезультатаЗапроса = МассивРезультатов[0].Выбрать();
			КонтрольОстатковУНФ.ПодарочныеСертификаты(ДокументОбъектСписаниеСертификатов, ВыборкаИзРезультатаЗапроса, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // ВыполнитьКонтроль()

#КонецЕсли
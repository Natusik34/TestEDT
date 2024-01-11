#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события ПередЗаписью набора записей.
//
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Установка исключительной блокировки текущего набора записей регистратора.
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ПодарочныеСертификаты.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияПодарочныеСертификатыИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияПодарочныеСертификатыИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияПодарочныеСертификатыИзменение Тогда
		
		// Если временная таблица "ДвиженияПодарочныеСертификатыИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияПодарочныеСертификатыПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ПодарочныеСертификаты.НомерСтроки КАК НомерСтроки,
		|	ПодарочныеСертификаты.ПодарочныйСертификат КАК ПодарочныйСертификат,
		|	ПодарочныеСертификаты.НомерСертификата КАК НомерСертификата,
		|	ВЫБОР
		|		КОГДА ПодарочныеСертификаты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ПодарочныеСертификаты.Сумма
		|		ИНАЧЕ -ПодарочныеСертификаты.Сумма
		|	КОНЕЦ КАК СуммаПередЗаписью
		|ПОМЕСТИТЬ ДвиженияПодарочныеСертификатыПередЗаписью
		|ИЗ
		|	РегистрНакопления.ПодарочныеСертификаты КАК ПодарочныеСертификаты
		|ГДЕ
		|	ПодарочныеСертификаты.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияПодарочныеСертификатыИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияПодарочныеСертификатыПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияПодарочныеСертификатыИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияПодарочныеСертификатыИзменение.ПодарочныйСертификат КАК ПодарочныйСертификат,
		|	ДвиженияПодарочныеСертификатыИзменение.НомерСертификата КАК НомерСертификата,
		|	ДвиженияПодарочныеСертификатыИзменение.СуммаПередЗаписью КАК СуммаПередЗаписью
		|ПОМЕСТИТЬ ДвиженияПодарочныеСертификатыПередЗаписью
		|ИЗ
		|	ДвиженияПодарочныеСертификатыИзменение КАК ДвиженияПодарочныеСертификатыИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ПодарочныеСертификаты.НомерСтроки,
		|	ПодарочныеСертификаты.ПодарочныйСертификат,
		|	ПодарочныеСертификаты.НомерСертификата,
		|	ВЫБОР
		|		КОГДА ПодарочныеСертификаты.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА ПодарочныеСертификаты.Сумма
		|		ИНАЧЕ -ПодарочныеСертификаты.Сумма
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ПодарочныеСертификаты КАК ПодарочныеСертификаты
		|ГДЕ
		|	ПодарочныеСертификаты.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
		
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияПодарочныеСертификатыИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияПодарочныеСертификатыИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияПодарочныеСертификатыИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияПодарочныеСертификатыИзменение");
	
	КонецЕсли;
	
КонецПроцедуры // ПередЗаписью()

// Процедура - обработчик события ПриЗаписи набора записей.
//
Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка
		ИЛИ НЕ ДополнительныеСвойства.Свойство("ДляПроведения")
		ИЛИ НЕ ДополнительныеСвойства.ДляПроведения.Свойство("СтруктураВременныеТаблицы") Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураВременныеТаблицы = ДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы;
	
	// Рассчитывается изменение нового набора относительно текущего с учетом накопленных изменений
	// и помещается во временную таблицу "ДвиженияПодарочныеСертификатыИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияПодарочныеСертификатыИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияПодарочныеСертификатыИзменение.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|	ДвиженияПодарочныеСертификатыИзменение.НомерСертификата КАК НомерСертификата,
	|	СУММА(ДвиженияПодарочныеСертификатыИзменение.СуммаПередЗаписью) КАК СуммаПередЗаписью,
	|	СУММА(ДвиженияПодарочныеСертификатыИзменение.СуммаИзменение) КАК СуммаИзменение,
	|	СУММА(ДвиженияПодарочныеСертификатыИзменение.СуммаПриЗаписи) КАК СуммаПриЗаписи
	|ПОМЕСТИТЬ ДвиженияПодарочныеСертификатыИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияПодарочныеСертификатыПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияПодарочныеСертификатыПередЗаписью.ПодарочныйСертификат КАК ПодарочныйСертификат,
	|		ДвиженияПодарочныеСертификатыПередЗаписью.НомерСертификата КАК НомерСертификата,
	|		ДвиженияПодарочныеСертификатыПередЗаписью.СуммаПередЗаписью КАК СуммаПередЗаписью,
	|		ДвиженияПодарочныеСертификатыПередЗаписью.СуммаПередЗаписью КАК СуммаИзменение,
	|		0 КАК СуммаПриЗаписи
	|	ИЗ
	|		ДвиженияПодарочныеСертификатыПередЗаписью КАК ДвиженияПодарочныеСертификатыПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияПодарочныеСертификатыПриЗаписи.НомерСтроки,
	|		ДвиженияПодарочныеСертификатыПриЗаписи.ПодарочныйСертификат,
	|		ДвиженияПодарочныеСертификатыПриЗаписи.НомерСертификата,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияПодарочныеСертификатыПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияПодарочныеСертификатыПриЗаписи.Сумма
	|			ИНАЧЕ ДвиженияПодарочныеСертификатыПриЗаписи.Сумма
	|		КОНЕЦ,
	|		ДвиженияПодарочныеСертификатыПриЗаписи.Сумма
	|	ИЗ
	|		РегистрНакопления.ПодарочныеСертификаты КАК ДвиженияПодарочныеСертификатыПриЗаписи
	|	ГДЕ
	|		ДвиженияПодарочныеСертификатыПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияПодарочныеСертификатыИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияПодарочныеСертификатыИзменение.ПодарочныйСертификат,
	|	ДвиженияПодарочныеСертификатыИзменение.НомерСертификата
	|
	|ИМЕЮЩИЕ
	|	СУММА(ДвиженияПодарочныеСертификатыИзменение.СуммаИзменение) <> 0
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ПодарочныйСертификат,
	|	НомерСертификата");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияПодарочныеСертификатыИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияПодарочныеСертификатыИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияПодарочныеСертификатыПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияПодарочныеСертификатыПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
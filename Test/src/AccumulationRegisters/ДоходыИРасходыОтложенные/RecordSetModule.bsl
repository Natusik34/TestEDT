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
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.ДоходыИРасходыОтложенные.НаборЗаписей");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.УстановитьЗначение("Регистратор", Отбор.Регистратор.Значение);
	Блокировка.Заблокировать();
	
	Если НЕ СтруктураВременныеТаблицы.Свойство("ДвиженияДоходыИРасходыОтложенныеИзменение") ИЛИ
		СтруктураВременныеТаблицы.Свойство("ДвиженияДоходыИРасходыОтложенныеИзменение") И НЕ СтруктураВременныеТаблицы.ДвиженияДоходыИРасходыОтложенныеИзменение Тогда
		
		// Если временная таблица "ДвиженияДоходыИРасходыОтложенныеИзменение" не существует или не содержит записей
		// об изменении набора, значит набор записывается первый раз или для набора был выполнен контроль остатков.
		// Текущее состояние набора помещается во временную таблицу "ДвиженияДоходыИРасходыОтложенныеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно текущего.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	РегистрНакопленияДоходыИРасходыОтложенные.НомерСтроки КАК НомерСтроки,
		|	РегистрНакопленияДоходыИРасходыОтложенные.Организация КАК Организация,
		|	РегистрНакопленияДоходыИРасходыОтложенные.Документ КАК Документ,
		|	РегистрНакопленияДоходыИРасходыОтложенные.НаправлениеДеятельности КАК НаправлениеДеятельности,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияДоходыИРасходыОтложенные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияДоходыИРасходыОтложенные.СуммаДоходов
		|		ИНАЧЕ -РегистрНакопленияДоходыИРасходыОтложенные.СуммаДоходов
		|	КОНЕЦ КАК СуммаДоходовПередЗаписью,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияДоходыИРасходыОтложенные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияДоходыИРасходыОтложенные.СуммаРасходов
		|		ИНАЧЕ -РегистрНакопленияДоходыИРасходыОтложенные.СуммаРасходов
		|	КОНЕЦ КАК СуммаРасходовПередЗаписью
		|ПОМЕСТИТЬ ДвиженияДоходыИРасходыОтложенныеПередЗаписью
		|ИЗ
		|	РегистрНакопления.ДоходыИРасходыОтложенные КАК РегистрНакопленияДоходыИРасходыОтложенные
		|ГДЕ
		|	РегистрНакопленияДоходыИРасходыОтложенные.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	Иначе
		
		// Если временная таблица "ДвиженияДоходыИРасходыОтложенныеИзменение" существует и содержит записи
		// об изменении набора, значит набор записывается не первый раз и для набора не был выполнен контроль остатков.
		// Текущее состояние набора и текущее состояние изменений помещаются во временную таблицу "ДвиженияДоходыИРасходыОтложенныеПередЗаписью",
		// чтобы при записи получить изменение нового набора относительно первоначального.
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	ДвиженияДоходыИРасходыОтложенныеИзменение.НомерСтроки КАК НомерСтроки,
		|	ДвиженияДоходыИРасходыОтложенныеИзменение.Организация КАК Организация,
		|	ДвиженияДоходыИРасходыОтложенныеИзменение.Документ КАК Документ,
		|	ДвиженияДоходыИРасходыОтложенныеИзменение.НаправлениеДеятельности КАК НаправлениеДеятельности,
		|	ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаДоходовПередЗаписью КАК СуммаДоходовПередЗаписью,
		|	ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаРасходовПередЗаписью КАК СуммаРасходовПередЗаписью
		|ПОМЕСТИТЬ ДвиженияДоходыИРасходыОтложенныеПередЗаписью
		|ИЗ
		|	ДвиженияДоходыИРасходыОтложенныеИзменение КАК ДвиженияДоходыИРасходыОтложенныеИзменение
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РегистрНакопленияДоходыИРасходыОтложенные.НомерСтроки,
		|	РегистрНакопленияДоходыИРасходыОтложенные.Организация,
		|	РегистрНакопленияДоходыИРасходыОтложенные.Документ,
		|	РегистрНакопленияДоходыИРасходыОтложенные.НаправлениеДеятельности,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияДоходыИРасходыОтложенные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияДоходыИРасходыОтложенные.СуммаДоходов
		|		ИНАЧЕ -РегистрНакопленияДоходыИРасходыОтложенные.СуммаДоходов
		|	КОНЕЦ,
		|	ВЫБОР
		|		КОГДА РегистрНакопленияДоходыИРасходыОтложенные.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА РегистрНакопленияДоходыИРасходыОтложенные.СуммаРасходов
		|		ИНАЧЕ -РегистрНакопленияДоходыИРасходыОтложенные.СуммаРасходов
		|	КОНЕЦ
		|ИЗ
		|	РегистрНакопления.ДоходыИРасходыОтложенные КАК РегистрНакопленияДоходыИРасходыОтложенные
		|ГДЕ
		|	РегистрНакопленияДоходыИРасходыОтложенные.Регистратор = &Регистратор
		|	И &Замещение");
		
		Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
		Запрос.УстановитьПараметр("Замещение", Замещение);
				
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		
	КонецЕсли;
	
	// Временная таблица "ДвиженияДоходыИРасходыОтложенныеИзменение" уничтожается
	// Удаляется информация о ее существовании.
	
	Если СтруктураВременныеТаблицы.Свойство("ДвиженияДоходыИРасходыОтложенныеИзменение") Тогда
		
		Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияДоходыИРасходыОтложенныеИзменение");
		Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
		Запрос.Выполнить();
		СтруктураВременныеТаблицы.Удалить("ДвиженияДоходыИРасходыОтложенныеИзменение");
	
	КонецЕсли;
	
	// Хозяйственная операция
	ХозяйственныеОперацииСервер.ЗаполнитьХозяйственнуюОперациюВНабореЗаписей(ЭтотОбъект);
	// Конец Хозяйственная операция
	
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
	// и помещается во временную таблицу "ДвиженияДоходыИРасходыОтложенныеИзменение".
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МИНИМУМ(ДвиженияДоходыИРасходыОтложенныеИзменение.НомерСтроки) КАК НомерСтроки,
	|	ДвиженияДоходыИРасходыОтложенныеИзменение.Организация КАК Организация,
	|	ДвиженияДоходыИРасходыОтложенныеИзменение.Документ КАК Документ,
	|	ДвиженияДоходыИРасходыОтложенныеИзменение.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|	СУММА(ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаДоходовПередЗаписью) КАК СуммаДоходовПередЗаписью,
	|	СУММА(ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаДоходовИзменение) КАК СуммаДоходовИзменение,
	|	СУММА(ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаДоходовПриЗаписи) КАК СуммаДоходовПриЗаписи,
	|	СУММА(ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаРасходовПередЗаписью) КАК СуммаРасходовПередЗаписью,
	|	СУММА(ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаРасходовИзменение) КАК СуммаРасходовИзменение,
	|	СУММА(ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаРасходовПриЗаписи) КАК СуммаРасходовПриЗаписи
	|ПОМЕСТИТЬ ДвиженияДоходыИРасходыОтложенныеИзменение
	|ИЗ
	|	(ВЫБРАТЬ
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью.НомерСтроки КАК НомерСтроки,
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью.Организация КАК Организация,
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью.Документ КАК Документ,
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью.НаправлениеДеятельности КАК НаправлениеДеятельности,
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью.СуммаДоходовПередЗаписью КАК СуммаДоходовПередЗаписью,
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью.СуммаДоходовПередЗаписью КАК СуммаДоходовИзменение,
	|		0 КАК СуммаДоходовПриЗаписи,
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью.СуммаРасходовПередЗаписью КАК СуммаРасходовПередЗаписью,
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью.СуммаРасходовПередЗаписью КАК СуммаРасходовИзменение,
	|		0 КАК СуммаРасходовПриЗаписи
	|	ИЗ
	|		ДвиженияДоходыИРасходыОтложенныеПередЗаписью КАК ДвиженияДоходыИРасходыОтложенныеПередЗаписью
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		ДвиженияДоходыИРасходыОтложенныеПриЗаписи.НомерСтроки,
	|		ДвиженияДоходыИРасходыОтложенныеПриЗаписи.Организация,
	|		ДвиженияДоходыИРасходыОтложенныеПриЗаписи.Документ,
	|		ДвиженияДоходыИРасходыОтложенныеПриЗаписи.НаправлениеДеятельности,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияДоходыИРасходыОтложенныеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияДоходыИРасходыОтложенныеПриЗаписи.СуммаДоходов
	|			ИНАЧЕ ДвиженияДоходыИРасходыОтложенныеПриЗаписи.СуммаДоходов
	|		КОНЕЦ,
	|		ДвиженияДоходыИРасходыОтложенныеПриЗаписи.СуммаДоходов,
	|		0,
	|		ВЫБОР
	|			КОГДА ДвиженияДоходыИРасходыОтложенныеПриЗаписи.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
	|				ТОГДА -ДвиженияДоходыИРасходыОтложенныеПриЗаписи.СуммаРасходов
	|			ИНАЧЕ ДвиженияДоходыИРасходыОтложенныеПриЗаписи.СуммаРасходов
	|		КОНЕЦ,
	|		ДвиженияДоходыИРасходыОтложенныеПриЗаписи.СуммаРасходов
	|	ИЗ
	|		РегистрНакопления.ДоходыИРасходыОтложенные КАК ДвиженияДоходыИРасходыОтложенныеПриЗаписи
	|	ГДЕ
	|		ДвиженияДоходыИРасходыОтложенныеПриЗаписи.Регистратор = &Регистратор) КАК ДвиженияДоходыИРасходыОтложенныеИзменение
	|
	|СГРУППИРОВАТЬ ПО
	|	ДвиженияДоходыИРасходыОтложенныеИзменение.Организация,
	|	ДвиженияДоходыИРасходыОтложенныеИзменение.Документ,
	|	ДвиженияДоходыИРасходыОтложенныеИзменение.НаправлениеДеятельности
	|
	|ИМЕЮЩИЕ
	|	(СУММА(ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаДоходовИзменение) <> 0
	|		ИЛИ СУММА(ДвиженияДоходыИРасходыОтложенныеИзменение.СуммаРасходовИзменение) <> 0)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Организация,
	|	Документ,
	|	НаправлениеДеятельности");
	
	Запрос.УстановитьПараметр("Регистратор", Отбор.Регистратор.Значение);
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаИзРезультатаЗапроса = РезультатЗапроса.Выбрать();
	ВыборкаИзРезультатаЗапроса.Следующий();
	
	// Новые изменения были помещены во временную таблицу "ДвиженияДоходыИРасходыОтложенныеИзменение".
	// Добавляется информация о ее существовании и наличии в ней записей об изменении.
	СтруктураВременныеТаблицы.Вставить("ДвиженияДоходыИРасходыОтложенныеИзменение", ВыборкаИзРезультатаЗапроса.Количество > 0);
	
	// Временная таблица "ДвиженияДоходыИРасходыОтложенныеПередЗаписью" уничтожается
	Запрос = Новый Запрос("УНИЧТОЖИТЬ ДвиженияДоходыИРасходыОтложенныеПередЗаписью");
	Запрос.МенеджерВременныхТаблиц = СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	Запрос.Выполнить();
	
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
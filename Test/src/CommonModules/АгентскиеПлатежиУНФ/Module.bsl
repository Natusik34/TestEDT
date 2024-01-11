
#Область ПрограммныйИнтерфейс

// Заполняет договор платежного агента в строке табличной части.
//
// Параметры:
//  СтруктураДанные - Структура - структура параметров агентского платежа.
//
Процедура ЗаполнитьДоговорПлатежногоАгентаВСтроке(СтруктураДанные) Экспорт
	
	СтруктураДанные.Вставить("ДоговорКонтрагента", Справочники.ДоговорыКонтрагентов.ПустаяСсылка());
	СтруктураДанные.Вставить("ДанныеАгентскогоДоговора", Неопределено);
	
	Если НЕ ПолучитьФункциональнуюОпцию("АгентскиеУслуги")
		ИЛИ НЕ ЗначениеЗаполнено(СтруктураДанные.Номенклатура)
		ИЛИ НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтруктураДанные.Номенклатура, "ЭтоАгентскаяУслуга") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ТекстЗапросаИсточник = 
		"ВЫБРАТЬ
		|	НоменклатураДокумента.Ссылка КАК Номенклатура,
		|	НоменклатураДокумента.Договор КАК ДоговорКонтрагента
		|ПОМЕСТИТЬ ТаблицаИсточник
		|ИЗ
		|	Справочник.Номенклатура КАК НоменклатураДокумента
		|ГДЕ
		|	НоменклатураДокумента.Ссылка = &Номенклатура";
	
	ТекстыЗапроса = Новый Массив;
	ТекстыЗапроса.Добавить(ТекстЗапросаИсточник);
	ТекстыЗапроса.Добавить(ТекстЗапросДанныеАгентскогоДоговора());
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(ТекстыЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());

	Запрос.УстановитьПараметр("Номенклатура", СтруктураДанные.Номенклатура);
	Запрос.УстановитьПараметр("Период", СтруктураДанные.ДатаОбработки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		СтруктураДанные.ДоговорКонтрагента = Выборка.ДоговорКонтрагента;
		
		Если Выборка.ДоговорПлатежногоАгента И Выборка.АвтоматическиВыделятьВознаграждениеВЧеке Тогда
			ДанныеАгентскогоДоговора = ДанныеАгентскогоДоговораШаблон();
			ЗаполнитьЗначенияСвойств(ДанныеАгентскогоДоговора, Выборка);
		Иначе
			ДанныеАгентскогоДоговора = Неопределено;
		КонецЕсли;
		
		СтруктураДанные.ДанныеАгентскогоДоговора = ДанныеАгентскогоДоговора;
		
	КонецЕсли;
	
КонецПроцедуры

// Заполняет договор платежного агента в табличной части.
//
// Параметры:
//  ТаблицаФормы - ДанныеФормыКоллекция - таблицы формы.
//
Процедура ЗаполнитьДоговорПлатежногоАгентаВТЧСервер(ТаблицаФормы) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТаблицаТоваров.НомерСтроки,
	|	ТаблицаТоваров.Номенклатура
	|ПОМЕСТИТЬ ТаблицаЗапроса
	|ИЗ
	|	&ТаблицаТоваров КАК ТаблицаТоваров
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаЗапроса.НомерСтроки,
	|	ТаблицаЗапроса.Номенклатура,
	|	ТаблицаЗапроса.Номенклатура.Договор КАК ДоговорПлатежногоАгента
	|ИЗ
	|	ТаблицаЗапроса КАК ТаблицаЗапроса";
	
	Запрос.УстановитьПараметр("ТаблицаТоваров",  ТаблицаФормы.Выгрузить(,"НомерСтроки,Номенклатура"));
	
	ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
	
	Для Каждого СтрокаТаблицы Из ТаблицаФормы Цикл
		
		СтрокаРезультата = ТаблицаРезультата[СтрокаТаблицы.НомерСтроки-1];
		
		СтрокаТаблицы.ДоговорПлатежногоАгента = СтрокаРезультата.ДоговорПлатежногоАгента;
		
	КонецЦикла;
	
КонецПроцедуры

// Пересчитывает цену с учетом агентского вознаграждения.
//
// Параметры:
//  ТекущаяСтрока - Структура - строка табличной части товаров для обработки.
//  СтруктураДействий - Структура - структура действий к выполнению при изменении реквизитов.
//  КэшированныеЗначения - Структура - структура данных кэшированных значений.
//
Процедура ПересчитатьЦенуСУчетомАгентскогоВознаграждения(ТекущаяСтрока, СтруктураДействий, КэшированныеЗначения = Неопределено) Экспорт
	ПараметрыЗаполнения = Неопределено;
	Если СтруктураДействий.Свойство("ПересчитатьЦенуСУчетомАгентскогоВознаграждения", ПараметрыЗаполнения) Тогда
		
		Если ЗначениеЗаполнено(ПараметрыЗаполнения) И ПараметрыЗаполнения.Цена = ТекущаяСтрока.Цена Тогда
			// Выделение не требуется.
			Возврат;
		КонецЕсли;
		
		ДанныеАгентскогоДоговора = АгентскиеПлатежиУНФКлиентСервер.ДанныеАгентскогоДоговора(ТекущаяСтрока);
		Если ЗначениеЗаполнено(ДанныеАгентскогоДоговора) И ДанныеАгентскогоДоговора.ВознаграждениеВключеноВСтоимость Тогда
			Цена = 0;
			ЦенаСАгентскимВознаграждением = ТекущаяСтрока.Цена;
			АгентскиеПлатежиУНФКлиентСервер.РассчитатьПоказателиАгентскогоПлатежа(ДанныеАгентскогоДоговора, Цена, ЦенаСАгентскимВознаграждением);
			
			ТекущаяСтрока.Цена = Цена;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

// Процедура выделяет агентское вознаграждение в табличной части
//
// Параметры:
//  Объект -ДокументОбъект - документ, в котором осуществляется выделение агентского вознаграждения
//  Форма - Форма - форма документа
//  ТекущаяСтрока - Структура - строка табличной части товаров для обработки.
//  СтруктураДействий - Структура - структура действий к выполнению при изменении реквизитов.
//  КэшированныеЗначения - Структура - структура данных кэшированных значений.
//
Процедура ВыделитьАгентскоеВознаграждение(Объект, Форма, СтруктураДействий = Неопределено, ТекущаяСтрока = Неопределено, КэшированныеЗначения = Неопределено) Экспорт
	
	КоллекцияДействийСоСтроками = Новый Соответствие;
	АгентскиеПлатежиУНФКлиентСервер.ВыделитьАгентскоеВознаграждениеВТаблице(Объект, ТекущаяСтрока);
	
	АгентскиеПлатежиУНФКлиентСервер.ЗаполнитьРасчетныеПоляАгентскогоВознаграждения(Объект, ТекущаяСтрока, Форма);
	
	Если ТекущаяСтрока = Неопределено ИЛИ СтруктураДействий.Свойство("ЗаполнитьДоговорПлатежногоАгента") Тогда
		АгентскиеПлатежиУНФКлиентСервер.УстановитьВидимостьДоступностьЭлементовАгентскогоВознаграждения(Форма, Объект);
	КонецЕсли;
	
КонецПроцедуры

// Процедура настраивает форму для отображения агентского вознаграждения
//
// Параметры:
//  Форма	 - Форма	 - форма документа
//  Объект	 - ДокументОбъект	 - объект документа для настройки
//
Процедура УправлениеЭлементамиАгентскогоВознаграждения(Форма, Объект) Экспорт
	
	ИспользоватьАгентскиеПлатежиИРазделениеВыручки = Ложь;
	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Форма, "ИспользоватьАгентскиеПлатежиИРазделениеВыручки") Тогда
		ИспользоватьАгентскиеПлатежиИРазделениеВыручки = Форма.ИспользоватьАгентскиеПлатежиИРазделениеВыручки;
	КонецЕсли;
	Если НЕ ИспользоватьАгентскиеПлатежиИРазделениеВыручки Тогда
		Возврат;
	КонецЕсли;
	
	// Заполнить данные договора.
	ЗаполнитьДанныеАгентскогоДоговора(Объект);
	
	// Заполнить расчетные поля.
	АгентскиеПлатежиУНФКлиентСервер.ЗаполнитьРасчетныеПоляАгентскогоВознаграждения(Объект,, Форма);
	
	// Установить видимость.
	АгентскиеПлатежиУНФКлиентСервер.УстановитьВидимостьДоступностьЭлементовАгентскогоВознаграждения(Форма, Объект);
	
КонецПроцедуры

// Возвращает параметры платежного договора
// 
// Параметры:
//  ПлатежныйДоговор - ДокументОбъект - документ по которому необходимо получить параметры платежного договора.
//  СуммаДокумента - Число - сумма документа.
// 
// Возвращаемое значение:
//  Структура - реквизиты платежного договора.
//
Функция ПараметрыПлатежногоДоговора(ПлатежныйДоговор, СуммаДокумента) Экспорт
	
	Если НЕ ЗначениеЗаполнено(ПлатежныйДоговор) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	СтруктураРеквизитов = Новый Структура;
	СтруктураРеквизитов.Вставить("Владелец");
	СтруктураРеквизитов.Вставить("ПроцентКомиссионногоВознаграждения");
	СтруктураРеквизитов.Вставить("АдресОператораПеревода");
	СтруктураРеквизитов.Вставить("ИННОператораПеревода");
	СтруктураРеквизитов.Вставить("НаименованиеОператораПеревода");
	СтруктураРеквизитов.Вставить("ОперацияПлатежногоАгента");
	СтруктураРеквизитов.Вставить("ПризнакАгента");
	СтруктураРеквизитов.Вставить("ТелефонПлатежногоАгента");
	СтруктураРеквизитов.Вставить("ТелефонОператораПоПриемуПлатежей");
	СтруктураРеквизитов.Вставить("ТелефонОператораПеревода");
	СтруктураРеквизитов.Вставить("ТелефонПоставщика");
	СтруктураРеквизитов.Вставить("ИННПоставщикаУслуг");
	
	РеквизитыПлатежногоДоговора = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПлатежныйДоговор, СтруктураРеквизитов);
	
	РеквизитыПлатежногоДоговора.Вставить("Агент", РеквизитыПлатежногоДоговора.Владелец);
	РеквизитыПлатежногоДоговора.Удалить("Владелец");
	
	Если ЗначениеЗаполнено(РеквизитыПлатежногоДоговора.Агент) И НЕ ЗначениеЗаполнено(РеквизитыПлатежногоДоговора.ИННПоставщикаУслуг) Тогда
		РеквизитыПлатежногоДоговора.ИННПоставщикаУслуг = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РеквизитыПлатежногоДоговора.Агент, "ИНН");
	КонецЕсли;
	
	ВознагражденияАгента = СуммаДокумента / 100 * РеквизитыПлатежногоДоговора.ПроцентКомиссионногоВознаграждения;
	РеквизитыПлатежногоДоговора.Вставить("ВознагражденияАгента", ВознагражденияАгента);
	
	Возврат РеквизитыПлатежногоДоговора;
	
КонецФункции

// Заполняет данные платежного договора из базы данных.
//
// Параметры:
//  ОбщиеПараметры - Структура - параметры платежного договора.
//  ДоговорКонтрагента - СправочникСсылка.ДоговорыКонтрагентов - договор платежного агента для заполнения.
//  СуммаДокумента - Число - сумма документа.
//
Процедура ЗаполнитьПараметрыПлатежногоДоговора(ОбщиеПараметры, ДоговорКонтрагента, СуммаДокумента) Экспорт
	
	РеквизитыПлатежногоДоговора = ПараметрыПлатежногоДоговора(ДоговорКонтрагента, СуммаДокумента);
	
	Если ЗначениеЗаполнено(РеквизитыПлатежногоДоговора) Тогда
		
		ОбщиеПараметры.ПризнакАгента = РеквизитыПлатежногоДоговора.ПризнакАгента;
		
		ОбщиеПараметры.ДанныеАгента.ПлатежныйАгент.Операция = РеквизитыПлатежногоДоговора.ОперацияПлатежногоАгента;
		ОбщиеПараметры.ДанныеАгента.ПлатежныйАгент.Телефон  = РеквизитыПлатежногоДоговора.ТелефонПлатежногоАгента;
		
		ОбщиеПараметры.ДанныеАгента.ОператорПеревода.Телефон      = РеквизитыПлатежногоДоговора.ТелефонОператораПеревода;
		ОбщиеПараметры.ДанныеАгента.ОператорПеревода.Наименование = РеквизитыПлатежногоДоговора.НаименованиеОператораПеревода;
		ОбщиеПараметры.ДанныеАгента.ОператорПеревода.Адрес        = РеквизитыПлатежногоДоговора.АдресОператораПеревода;
		ОбщиеПараметры.ДанныеАгента.ОператорПеревода.ИНН          = РеквизитыПлатежногоДоговора.ИННОператораПеревода;
		
		ОбщиеПараметры.ДанныеАгента.ОператорПоПриемуПлатежей.Телефон = РеквизитыПлатежногоДоговора.ТелефонОператораПоПриемуПлатежей;
		
		ОбщиеПараметры.ДанныеПоставщика.Телефон      = РеквизитыПлатежногоДоговора.ТелефонПоставщика;
		ОбщиеПараметры.ДанныеПоставщика.Наименование = Строка(РеквизитыПлатежногоДоговора.Агент);
		ОбщиеПараметры.ДанныеПоставщика.ИНН          = РеквизитыПлатежногоДоговора.ИННПоставщикаУслуг;
	КонецЕсли;
	
КонецПроцедуры

// Заполняет данные платежного договора строки чека на основании шапке
//
// Параметры:
//  ОбщиеПараметры - Структура - см. ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыОперацииФискализацииЧека()
//  ПозицияЧека - Структура - см функцию БПО ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыФискальнойСтрокиЧека()
//  СтрокаЗапасы - СтрокаТаблицыЗначений - строка табличной части Запасы
//                                                    
Процедура ЗаполнитьПараметрыПлатежногоДоговораВСтроке(ОбщиеПараметры, ПозицияЧека, СтрокаЗапасы = Неопределено) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАгентскиеПлатежиИРазделениеВыручки") Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыПлатежногоДоговора = Неопределено;
	Если НЕ СтрокаЗапасы = Неопределено И ЗначениеЗаполнено(СтрокаЗапасы.ДоговорПлатежногоАгента) Тогда
		// Договор в строке.
		ПараметрыПлатежногоДоговора = Новый Структура;
		ПараметрыПлатежногоДоговора.Вставить("ПризнакАгента");
		ПараметрыПлатежногоДоговора.Вставить("ДанныеАгента", ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыДанныеАгента());
		ПараметрыПлатежногоДоговора.Вставить("ДанныеПоставщика", ОборудованиеЧекопечатающиеУстройстваКлиентСервер.ПараметрыДанныеПоставщика());
		
		ЗаполнитьПараметрыПлатежногоДоговора(ПараметрыПлатежногоДоговора, СтрокаЗапасы.ДоговорПлатежногоАгента, СтрокаЗапасы.Сумма);
		
	КонецЕсли;
	
	Если ПараметрыПлатежногоДоговора = Неопределено Тогда
		Возврат;
	ИначеЕсли ПараметрыПлатежногоДоговора.ПризнакАгента = Перечисления.ПризнакиАгента.Комиссионер Тогда
		Возврат;
	КонецЕсли;
	
	ПозицияЧека.ПризнакАгентаПоПредметуРасчета = ПараметрыПлатежногоДоговора.ПризнакАгента;
		
	ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Операция = ПараметрыПлатежногоДоговора.ДанныеАгента.ПлатежныйАгент.Операция;
	ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Телефон  = ПараметрыПлатежногоДоговора.ДанныеАгента.ПлатежныйАгент.Телефон;
	
	ПозицияЧека.ДанныеАгента.ОператорПеревода.Телефон      = ПараметрыПлатежногоДоговора.ДанныеАгента.ОператорПеревода.Телефон;
	ПозицияЧека.ДанныеАгента.ОператорПеревода.Наименование = ПараметрыПлатежногоДоговора.ДанныеАгента.ОператорПеревода.Наименование;
	ПозицияЧека.ДанныеАгента.ОператорПеревода.Адрес        = ПараметрыПлатежногоДоговора.ДанныеАгента.ОператорПеревода.Адрес;
	ПозицияЧека.ДанныеАгента.ОператорПеревода.ИНН          = ПараметрыПлатежногоДоговора.ДанныеАгента.ОператорПеревода.ИНН;
	
	ПозицияЧека.ДанныеАгента.ОператорПоПриемуПлатежей.Телефон = ПараметрыПлатежногоДоговора.ДанныеАгента.ОператорПоПриемуПлатежей.Телефон;
	
	ПозицияЧека.ДанныеПоставщика.Телефон      = ПараметрыПлатежногоДоговора.ДанныеПоставщика.Телефон;
	ПозицияЧека.ДанныеПоставщика.Наименование = ПараметрыПлатежногоДоговора.ДанныеПоставщика.Наименование;
	ПозицияЧека.ДанныеПоставщика.ИНН          = ПараметрыПлатежногоДоговора.ДанныеПоставщика.ИНН;  
	
КонецПроцедуры

// Процедура дополняет данные кассовой смены информацией об агентских платежах
//
// Параметры:
//  СтруктураСостояниеКассовойСмены	 - Структура	 - Данные открытой кассовой смены
//
Процедура ДополнитьСтруктуруСостоянияКассовойСмены(СтруктураСостояниеКассовойСмены) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ДенежныеСредстваККМОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ДенежныеСредстваККМОстатки.СуммаВалОстаток КАК СуммаВалОстаток
	|ИЗ
	|	РегистрНакопления.ДенежныеСредстваВКассахККМ.Остатки(
	|			,
	|			КассаККМ = &КассаККМ
	|				И ДоговорКонтрагента <> ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)) КАК ДенежныеСредстваККМОстатки";
	
	Запрос.УстановитьПараметр("КассаККМ", СтруктураСостояниеКассовойСмены.КассаККМ);
	
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	СтруктураСостояниеКассовойСмены.Вставить("ДеньгиПоДоговорамПлатежногоАгента", Новый Массив);
	
	СуммаАгентскихПлатежей = 0;
	Пока Выборка.Следующий() Цикл
		СтруктураДенегАгента = Новый Структура;
		СтруктураДенегАгента.Вставить("ДоговорАгента", Выборка.ДоговорКонтрагента);
		СтруктураДенегАгента.Вставить("Сумма", Выборка.СуммаВалОстаток);
		СтруктураСостояниеКассовойСмены.ДеньгиПоДоговорамПлатежногоАгента.Добавить(СтруктураДенегАгента);
		СуммаАгентскихПлатежей = СуммаАгентскихПлатежей + Выборка.СуммаВалОстаток;
	КонецЦикла;
	
	СтруктураСостояниеКассовойСмены.Вставить("СуммаАгентскихПлатежей", СуммаАгентскихПлатежей);
	
КонецПроцедуры

// Процедура заполняет параметры платежного договора в шапке документа
//
// Параметры:
//  ОбщиеПараметры	 - Структура	 - параметры договора платежного агента
//  ДокументОбъект	 - ДокументОбъект	 - документ для заполнения данными
//
Процедура ЗаполнитьПараметрыПлатежногоДоговораВШапке(ОбщиеПараметры, ДокументОбъект) Экспорт
	
	Если НЕ ПолучитьФункциональнуюОпцию("ИспользоватьАгентскиеПлатежиИРазделениеВыручки") Тогда
		Возврат;
	КонецЕсли;
	
	// Если в табличной части только одна услуга и комиссия заполняем в шапке
	ЕстьДругиеТоварыУслуги = Ложь;
	ДоговорыАгентов = Новый Массив;
	Для каждого СтрокаЗапасов Из ДокументОбъект.Запасы Цикл
		Если ЗначениеЗаполнено(СтрокаЗапасов.ДоговорПлатежногоАгента) Тогда
			ДоговорыАгентов.Добавить(СтрокаЗапасов.ДоговорПлатежногоАгента);
		Иначе
			ЕстьДругиеТоварыУслуги = Истина;
		КонецЕсли;
	КонецЦикла;
	
	ДоговорыАгентов = ОбщегоНазначенияКлиентСервер.СвернутьМассив(ДоговорыАгентов);
	Если НЕ ЕстьДругиеТоварыУслуги И ДоговорыАгентов.Количество() = 1 Тогда
		ДоговорКонтрагента = ДоговорыАгентов[0];
		ЗаполнитьПараметрыПлатежногоДоговора(ОбщиеПараметры, ДоговорКонтрагента, ДокументОбъект.СуммаДокумента);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ТекстЗапросДанныеАгентскогоДоговора()
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ТаблицаИсточник.*,
		|	ЕСТЬNULL(ПроцентыВознагражденияПоДоговорамСрезПоследних.ПроцентВознаграждения, ДоговорыКонтрагентов.ПроцентКомиссионногоВознаграждения) КАК ПроцентВознаграждения,
		|	ДоговорыКонтрагентов.АвтоматическиВыделятьВознаграждениеВЧеке КАК АвтоматическиВыделятьВознаграждениеВЧеке,
		|	ДоговорыКонтрагентов.ВознаграждениеВключеноВСтоимость КАК ВознаграждениеВключеноВСтоимость,
		|	ДоговорыКонтрагентов.УслугаКомиссионногоВознаграждения КАК УслугаАгента,
		|	ЕСТЬNULL(ДоговорыКонтрагентов.ПризнакАгента В (
		|		ЗНАЧЕНИЕ(Перечисление.ПризнакиАгента.Агент),
		|		ЗНАЧЕНИЕ(Перечисление.ПризнакиАгента.БанковскийПлатежныйАгент),
		|		ЗНАЧЕНИЕ(Перечисление.ПризнакиАгента.БанковскийПлатежныйСубагент),
		|		ЗНАЧЕНИЕ(Перечисление.ПризнакиАгента.ПлатежныйАгент),
		|		ЗНАЧЕНИЕ(Перечисление.ПризнакиАгента.ПлатежныйСубагент)), ЛОЖЬ) КАК ДоговорПлатежногоАгента
		|ИЗ
		|	ТаблицаИсточник КАК ТаблицаИсточник
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ДоговорыКонтрагентов КАК ДоговорыКонтрагентов
		|		ПО ТаблицаИсточник.ДоговорКонтрагента = ДоговорыКонтрагентов.Ссылка
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПроцентыВознагражденияПоДоговорам.СрезПоследних(&Период, ) КАК ПроцентыВознагражденияПоДоговорамСрезПоследних
		|		ПО ТаблицаИсточник.ДоговорКонтрагента = ПроцентыВознагражденияПоДоговорамСрезПоследних.ДоговорКонтрагента
		|			И ТаблицаИсточник.Номенклатура = ПроцентыВознагражденияПоДоговорамСрезПоследних.Номенклатура";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура ЗаполнитьДанныеАгентскогоДоговора(Объект)
	
	ТекстЗапросаИсточник = 
		"ВЫБРАТЬ
		|	ТаблицаТоваров.НомерСтроки КАК НомерСтроки,
		|	ВЫБОР
		|		КОГДА &ДоговорКонтрагентаШапка = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
		|			ТОГДА ТаблицаТоваров.ДоговорПлатежногоАгента
		|		ИНАЧЕ &ДоговорКонтрагентаШапка
		|	КОНЕЦ КАК ДоговорКонтрагента,
		|	ТаблицаТоваров.Номенклатура КАК Номенклатура
		|ПОМЕСТИТЬ ТаблицаИсточник
		|ИЗ
		|	&ТаблицаТоваров КАК ТаблицаТоваров";
	
	ТекстыЗапроса = Новый Массив;
	ТекстыЗапроса.Добавить(ТекстЗапросаИсточник);
	ТекстыЗапроса.Добавить(ТекстЗапросДанныеАгентскогоДоговора());
	
	Запрос = Новый Запрос;
	Запрос.Текст = СтрСоединить(ТекстыЗапроса, ОбщегоНазначения.РазделительПакетаЗапросов());

	Если ОбщегоНазначенияКлиентСервер.ЕстьРеквизитИлиСвойствоОбъекта(Объект, "ДоговорПлатежногоАгента") Тогда
		ДоговорКонтрагентаШапка = Объект.ДоговорПлатежногоАгента;
	Иначе
		ДоговорКонтрагентаШапка = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	КонецЕсли;
	
	Запрос.УстановитьПараметр("ТаблицаТоваров", Объект.Запасы.Выгрузить(,"НомерСтроки, Номенклатура, ДоговорПлатежногоАгента"));
	Запрос.УстановитьПараметр("ДоговорКонтрагентаШапка", ДоговорКонтрагентаШапка);
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.ДоговорПлатежногоАгента И Выборка.АвтоматическиВыделятьВознаграждениеВЧеке Тогда
			ДанныеАгентскогоДоговора = ДанныеАгентскогоДоговораШаблон();
			ЗаполнитьЗначенияСвойств(ДанныеАгентскогоДоговора, Выборка);
		Иначе
			ДанныеАгентскогоДоговора = Неопределено;
		КонецЕсли;
		
		Объект.Запасы[Выборка.НомерСтроки - 1].ДанныеАгентскогоДоговора = ДанныеАгентскогоДоговора;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ДанныеАгентскогоДоговораШаблон()
	
	ДанныеАгентскогоДоговора = Новый Структура;
	ДанныеАгентскогоДоговора.Вставить("ПроцентВознаграждения");
	ДанныеАгентскогоДоговора.Вставить("ВознаграждениеВключеноВСтоимость");
	ДанныеАгентскогоДоговора.Вставить("УслугаАгента");
	
	Возврат ДанныеАгентскогоДоговора;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Форма предполагает несколько различных сценариев использования.
	// Для определения сценария работы используется параметр СценарийИспользования. Тип Строка.
	// На текущий момент известно о трех сценариях работы, они обозначаются следующими значениями параметра:
	//  * ПубликацияТорговыхПредложенийБезКонтекста
	//  * ПубликацияТорговыхПредложений
	//  * ВыгрузкаНоменклатуры
	// Значение по умолчанию - ПубликацияТорговыхПредложенийБезКонтекста для обеспечения обратной совместимости (то есть если параметр не задан)
	// При появлении новых сценариев, форму нужно будет адаптировать под них.
	Если Параметры.Свойство("СценарийИспользования") Тогда
		СценарийИспользования = Параметры.СценарийИспользования;
	Иначе
		СценарийИспользования = "ПубликацияТорговыхПредложенийБезКонтекста";
	КонецЕсли;
	Если СценарийИспользования = "ПубликацияТорговыхПредложенийБезКонтекста" Тогда
		Заголовок = НСтр("ru = 'Сопоставление значений реквизита 1С:Бизнес-сеть'");
		Элементы.ИнформацияСписок.Заголовок = НСтр("ru = 'Необходимо сопоставить значения свойств 1С:Бизнес-сеть для значений реквизитов номенклатуры.'");
		Элементы.Представление.Заголовок  = НСтр("ru = 'Значение 1С:Бизнес-сеть'");
	ИначеЕсли СценарийИспользования = "ПубликацияТорговыхПредложений" Тогда
		Заголовок = НСтр("ru = 'Сопоставление значений реквизита 1С:Бизнес-сеть'");
		Элементы.ИнформацияСписок.Заголовок = НСтр("ru = 'Необходимо сопоставить значения свойств 1С:Бизнес-сеть для значений реквизитов номенклатуры.'");
		Элементы.Представление.Заголовок  = НСтр("ru = 'Значение 1С:Бизнес-сеть'");
	ИначеЕсли СценарийИспользования = "ВыгрузкаНоменклатуры" Тогда
		Заголовок = НСтр("ru = 'Сопоставление значений реквизита 1С:Номенклатура'");
		Элементы.ИнформацияСписок.Заголовок = НСтр("ru = 'Необходимо сопоставить значения свойств 1С:Номенклатура для значений реквизитов номенклатуры.'");
		Элементы.Представление.Заголовок  = НСтр("ru = 'Значение 1С:Номенклатура'");
	КонецЕсли;
	
	УстановитьУсловноеОформление();
	
	Параметры.Свойство("ИдентификаторКатегории"          , ИдентификаторКатегории);
	Параметры.Свойство("ИдентификаторРеквизитаКатегории" , ИдентификаторРеквизита);
	Параметры.Свойство("ОбъектСопоставления"             , ОбъектСопоставления);
	Параметры.Свойство("РеквизитОбъекта"                 , РеквизитОбъекта);
	Параметры.Свойство("ТипЗначения"                     , ТипЗначения);
	Параметры.Свойство("ТолькоПросмотр"                  , ТолькоПросмотр);
	
	Если ТолькоПросмотр Тогда
		Элементы.Очистить.Доступность                    = Ложь;
		Элементы.Записать.Доступность                    = Ложь;
		Элементы.ЗаполнитьЗначенияРеквизитов.Доступность = Ложь;
		Элементы.ЗаписатьЗакрыть.Доступность             = Ложь;
		Элементы.Представление.КартинкаШапки             = Новый Картинка;
	КонецЕсли;

	ЗагрузитьЗначенияРеквизитаРубрикатора();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьЗакрыть(Команда)
	
	СохранитьИзмененияСервер();
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИзменения(Команда)
	
	СохранитьИзмененияСервер();
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	Для Каждого ЭлементСписка Из Список Цикл
		ЭлементСписка.ПредставлениеЗначенияРеквизитаКатегории = Неопределено;
		ЭлементСписка.ЗначениеНеактуально = Ложь;
	КонецЦикла;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗначенияРеквизита(Команда)
	
	КоличествоНесопоставленных = 0;
	ВсегоЗначенийРеквизитов    = 0;
	Для Каждого СтрокаСписка Из Список Цикл
		
		Если ЗначениеЗаполнено(СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории)
			И НЕ СтрокаСписка.ЗначениеНеактуально Тогда
			Продолжить;
		КонецЕсли;
		
		ВсегоЗначенийРеквизитов = ВсегоЗначенийРеквизитов + 1;
		
		ЗначениеПоиска = ВРег(СтрокаСписка.Значение);
		СтрокаПоиска   = Неопределено;
		Для каждого ЭлементСписка Из СписокЗначенийСервиса Цикл
			Если ВРег(ЭлементСписка.Значение) = ЗначениеПоиска Тогда
				СтрокаПоиска = ЭлементСписка;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		Если СтрокаПоиска = Неопределено Тогда
			КоличествоНесопоставленных = КоличествоНесопоставленных + 1;
			Продолжить;
		КонецЕсли;
		
		СтрокаСписка.ИдентификаторЗначенияРеквизитаКатегории = Формат(СтрокаПоиска.Представление, "ЧГ=");
		СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории = СтрокаПоиска.Значение;
		СтрокаСписка.ЗначениеНеактуально                     = Ложь;
		Модифицированность = Истина;
		
	КонецЦикла;
	
	// Вывод результата пользователю.
	Если КоличествоНесопоставленных > 0 Тогда
		Если КоличествоНесопоставленных = ВсегоЗначенийРеквизитов Тогда
			ТекстСообщения = НСтр("ru = 'Не удалось сопоставить значения реквизитов со значениями сервиса.'");
		Иначе
			ТекстСообщения = СтрШаблон(НСтр("ru = 'Не удалось сопоставить %1 из %2 значений реквизитов со значениями сервиса.'"),
			КоличествоНесопоставленных, ВсегоЗначенийРеквизитов);
		КонецЕсли;
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗагрузитьЗначенияРеквизитаРубрикатора()
	
	Отказ = Ложь;
	
	ОбновитьСписокЗначенийРеквизита();

	ПараметрыМетода = Новый Структура;
	ПараметрыМетода.Вставить("ИдентификаторКатегории"                , ИдентификаторКатегории);
	ПараметрыМетода.Вставить("ИдентификаторДополнительногоРеквизита" , ИдентификаторРеквизита);
	Результат = РаботаСНоменклатурой.ДанныеЗначенийДополнительногоРеквизитаКатегории(ПараметрыМетода, Отказ);

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Количество() Тогда
		ТаблицаЗначений = Результат[0].Значения;
		Для Каждого ЗначенияРубрикатора Из ТаблицаЗначений Цикл
			СписокЗначенийСервиса.Добавить(ЗначенияРубрикатора.Наименование, Формат(ЗначенияРубрикатора.Идентификатор, "ЧГ="));
			Элементы.Представление.СписокВыбора.Добавить(ЗначенияРубрикатора.Наименование);
		КонецЦикла;
		Элементы.Представление.СписокВыбора.СортироватьПоЗначению();
	КонецЕсли;
	
	Для Каждого СтрокаСписка Из Список Цикл
		Если ЗначениеЗаполнено(СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории) Тогда
			// Проверка актуальности данных.
			ЗначениеРубрикатора = СписокЗначенийСервиса.НайтиПоЗначению(СтрокаСписка.ПредставлениеЗначенияРеквизитаКатегории);
			Если ЗначениеРубрикатора = Неопределено Тогда
				СтрокаСписка.ЗначениеНеактуально = Истина;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗначенийРеквизита()
	
	Запрос = Новый Запрос;
	РаботаСНоменклатуройПереопределяемый.ИнициализацияЗапросаЗначенийДополнительныхРеквизитов(Запрос, 
		ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(РеквизитОбъекта));
	
	ИмяТаблицы   =  "втДополнительныеРеквизиты";
	СхемаЗапроса = Новый СхемаЗапроса;
	СхемаЗапроса.УстановитьТекстЗапроса(Запрос.Текст);
	СхемаЗапроса.ПакетЗапросов[0].ТаблицаДляПомещения = ИмяТаблицы;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ДополнительныеРеквизиты.Значение КАК Значение,
	|	ВЫРАЗИТЬ(СоответствиеЗначений.ИдентификаторЗначенияРеквизитаКатегории КАК СТРОКА(50)) КАК ИдентификаторЗначенияРеквизитаКатегории,
	|	ВЫРАЗИТЬ(СоответствиеЗначений.ПредставлениеЗначенияРеквизитаКатегории КАК СТРОКА(100)) КАК ПредставлениеЗначенияРеквизитаКатегории
	|ИЗ
	|	втДополнительныеРеквизиты КАК ДополнительныеРеквизиты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеЗначенийРеквизитовРаботаСНоменклатурой КАК СоответствиеЗначений
	|		ПО (СоответствиеЗначений.ОбъектСопоставления = &ОбъектСопоставления)
	|			И (СоответствиеЗначений.РеквизитОбъекта = &РеквизитОбъекта)
	|			И ДополнительныеРеквизиты.Значение = СоответствиеЗначений.Значение";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "втДополнительныеРеквизиты", ИмяТаблицы);
	
	ОсновнойЗапрос = СхемаЗапроса.ПакетЗапросов.Добавить();
	ОсновнойЗапрос.УстановитьТекстЗапроса(ТекстЗапроса);
	ЗапросУдалить  = СхемаЗапроса.ПакетЗапросов.Добавить(Тип("ЗапросУничтоженияТаблицыСхемыЗапроса"));
	ЗапросУдалить.ИмяТаблицы = ИмяТаблицы;
	
	Запрос.Текст = СхемаЗапроса.ПолучитьТекстЗапроса();
	Запрос.УстановитьПараметр("ОбъектСопоставления", ОбъектСопоставления);
	Запрос.УстановитьПараметр("РеквизитОбъекта", РеквизитОбъекта);
		
	Список.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СохранитьИзмененияСервер()
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СоответствиеЗначенийРеквизитовРаботаСНоменклатурой");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ОбъектСопоставления", ОбъектСопоставления);
		ЭлементБлокировки.УстановитьЗначение("РеквизитОбъекта", РеквизитОбъекта);
		Блокировка.Заблокировать();
		
		НаборЗаписей = РегистрыСведений.СоответствиеЗначенийРеквизитовРаботаСНоменклатурой.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ОбъектСопоставления.Значение = ОбъектСопоставления;
		НаборЗаписей.Отбор.ОбъектСопоставления.Использование = Истина;
		НаборЗаписей.Отбор.РеквизитОбъекта.Значение = РеквизитОбъекта;
		НаборЗаписей.Отбор.РеквизитОбъекта.Использование = Истина;
		НаборЗаписей.Очистить();
		
		ТаблицаСписка = РеквизитФормыВЗначение("Список");
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.СоответствиеЗначенийРеквизитовРаботаСНоменклатурой");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		ЭлементБлокировки.УстановитьЗначение("ОбъектСопоставления", ОбъектСопоставления);
		ЭлементБлокировки.УстановитьЗначение("РеквизитОбъекта", РеквизитОбъекта);
		ЭлементБлокировки.ИсточникДанных = ТаблицаСписка;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Значение", "Значение");
		Блокировка.Заблокировать();
		
		Для Каждого ЭлементКоллекции Из ТаблицаСписка Цикл
			
			Если ЗначениеЗаполнено(ЭлементКоллекции.ПредставлениеЗначенияРеквизитаКатегории) Тогда
				Запись = НаборЗаписей.Добавить();
				Запись.ОбъектСопоставления = ОбъектСопоставления;
				Запись.РеквизитОбъекта     = РеквизитОбъекта;
				Запись.Значение            = ЭлементКоллекции.Значение;
				
				ЗначениеСервиса = СписокЗначенийСервиса.НайтиПоЗначению(ЭлементКоллекции.ПредставлениеЗначенияРеквизитаКатегории);
				Если ЗначениеСервиса = Неопределено Тогда
					Запись.ИдентификаторЗначенияРеквизитаКатегории = ЭлементКоллекции.ИдентификаторЗначенияРеквизитаКатегории;
					Запись.ПредставлениеЗначенияРеквизитаКатегории = ЭлементКоллекции.ПредставлениеЗначенияРеквизитаКатегории;
				Иначе
					Запись.ИдентификаторЗначенияРеквизитаКатегории = ЗначениеСервиса.Представление;
					Запись.ПредставлениеЗначенияРеквизитаКатегории = ЗначениеСервиса.Значение;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		Модифицированность = Ложь;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		ОбщегоНазначенияБЭД.ЗаписатьВЖурналРегистрации(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), 
				ОбщегоНазначенияБЭДКлиентСервер.ПодсистемыБЭД().БизнесСеть);
			
		ОбщегоНазначения.СообщитьПользователю(
			НСтр("ru = 'Ошибка записи сопоставления. Подробности см. в журнале регистрации.'"));
		
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	СохранитьИзмененияСервер();
	Модифицированность = Ложь; // не выводить подтверждение о закрытии формы еще раз.
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеЗначенияРеквизитаКатегорииПриИзменении(Элемент)
	
	Если Элементы.Список.ТекущиеДанные.ЗначениеНеактуально Тогда
		Элементы.Список.ТекущиеДанные.ЗначениеНеактуально = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	// Установка условного оформления для неактуального значения рубрикатора.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ПросроченныеДанныеЦвет);
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Представление.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ЗначениеНеактуально");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	// Надпись <Выберите значение>.
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.НедоступныеДанныеЭДЦвет);
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("Текст", НСтр("ru = '<Выберите значение>'"));
	
	ПолеЭлемента = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.Представление.Имя);
	
	ОтборЭлемента = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.ПредставлениеЗначенияРеквизитаКатегории");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "Значение" Тогда
		ТекущиеДанные = Элементы.Список.ТекущиеДанные;
		Если ТекущиеДанные <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			ПоказатьЗначение(, ТекущиеДанные.Значение)
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

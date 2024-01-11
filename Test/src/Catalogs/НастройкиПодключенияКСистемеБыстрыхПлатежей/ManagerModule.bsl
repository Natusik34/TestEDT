///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Определяет параметры копирования торговой точки.
//
// Параметры:
//  НастройкаПодключения - СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей - настройка выполнения оплаты.
//
// Возвращаемое значение:
//  Структура - параметры копирования:
//    * Наименование - Строка - наименование копируемой торговой точки;
//    * СверкаВзаиморасчетов - Булево - признак выполнения сверки взаиморасчетов;
//    * ИдентификаторУчастника - Строка - идентификатор участника Системы быстрых платежей.
//
Функция ДанныеКопирования(НастройкаПодключения) Экспорт
	
	ДанныеКопирования = Новый Структура;
	ДанныеКопирования.Вставить("Наименование", "");
	ДанныеКопирования.Вставить("ИдентификаторУчастника", Неопределено);
	
	Если НастройкаПодключения = Неопределено Тогда
		Возврат ДанныеКопирования;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	НастройкиПодключенияКСистемеБыстрыхПлатежей.Наименование КАК Наименование,
		|	НастройкиПодключенияКСистемеБыстрыхПлатежей.ИдентификаторУчастника КАК ИдентификаторУчастника
		|ИЗ
		|	Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей КАК НастройкиПодключенияКСистемеБыстрыхПлатежей
		|ГДЕ
		|	НастройкиПодключенияКСистемеБыстрыхПлатежей.Ссылка = &НастройкаПодключения";
	
	Запрос.УстановитьПараметр("НастройкаПодключения", НастройкаПодключения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	ЗаполнитьЗначенияСвойств(
		ДанныеКопирования,
		ВыборкаДетальныеЗаписи,
		"Наименование, ИдентификаторУчастника");
	
	Возврат ДанныеКопирования;
	
КонецФункции

// Определяет наличие настроек подключения к Системе быстрых платежей.
//
// Возвращаемое значение:
//  Булево - если Истина, есть настройки подключения.
//
Функция ЕстьНастройкиПодключения() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИСТИНА КАК Признак
		|ИЗ
		|	Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей КАК НастройкиПодключенияКСистемеБыстрыхПлатежей
		|ГДЕ
		|	НЕ НастройкиПодключенияКСистемеБыстрыхПлатежей.ЭтоГруппа";
	
	РезультатЗапроса = Запрос.Выполнить();
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

// Определяет настройки подключения к Системе быстрых платежей
// по участнику.
//
// Параметры:
//  Идентификатор - Строка - идентификатор участника Системы быстрых платежей.
//
// Возвращаемое значение:
//  Массив Из Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей - используемые настройки.
//
Функция НастройкиПодключенияУчастникаСБП(Идентификатор) Экспорт
	
	Результат = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкиПодключенияКСистемеБыстрыхПлатежей.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей КАК НастройкиПодключенияКСистемеБыстрыхПлатежей
		|ГДЕ
		|	НастройкиПодключенияКСистемеБыстрыхПлатежей.ИдентификаторУчастника = &Идентификатор
		|	И НастройкиПодключенияКСистемеБыстрыхПлатежей.Используется";
	
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Результат.Добавить(ВыборкаДетальныеЗаписи.Ссылка);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Сохраняет настройки подключения к СБП в информационную базу.
//
// Параметры:
//  ПараметрыЗаполнения - Структура - данные заполнения торговой точки;
//  ПараметрыАутентификации - Структура - данные аутентификации;
//  ПараметрыОплаты - Структура - содержит данные для записи настроек в регистр сведений.
//    Структура параметра соответствует структуре регистра, которая определена
//    в метаданных за исключением полей указанных в настройках в свойстве ИсключаемыеПоля
//    процедуры ПриОпределенииНастроекПодключения;
//
// Возвращаемое значение:
//  Структура - результат создания торговой точки:
//    * Ссылка - Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей - новая настройка;
//    * Ошибка - Булево - признак ошибки сохранения;
//    * СообщениеОбОшибке  - Строка, ФорматированнаяСтрока - сообщение об ошибке для пользователя.
//
Функция НоваяНастройкаПодключения(
		ПараметрыЗаполнения,
		ПараметрыАутентификации,
		ПараметрыОплаты) Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("Ошибка", Ложь);
	Результат.Вставить("СообщениеОбОшибке", "");
	Результат.Вставить("Ссылка", Неопределено);
	
	НачатьТранзакцию();
	
	Попытка
		
		НастройкаПодключения = Справочники.НастройкиПодключенияКСистемеБыстрыхПлатежей.СоздатьЭлемент();
		ЗаполнитьЗначенияСвойств(
			НастройкаПодключения,
			ПараметрыЗаполнения,
			"ИдентификаторУчастника, Наименование");
		НастройкаПодключения.ИдентификаторМерчанта = СистемаБыстрыхПлатежейСлужебный.ИдентификаторМерчантаПоДаннымАутентификации(
			ПараметрыАутентификации);
		НастройкаПодключения.Родитель = РодительНастройки(
			ПараметрыЗаполнения.ИдентификаторУчастника);
		НастройкаПодключения.Используется = Истина;
		
		НастройкаПодключения.Записать();
		
		РезультатЗаписиНастроек = СистемаБыстрыхПлатежейСлужебный.ЗаписатьНастройкиОплаты(
			ПараметрыОплаты,
			НастройкаПодключения.Ссылка);
		
		Если РезультатЗаписиНастроек.Отказ Тогда
			Результат.Ошибка = Истина;
			Результат.СообщениеОбОшибке = РезультатЗаписиНастроек.СообщениеОбОшибке;
			ОтменитьТранзакцию();
			Возврат Результат;
		КонецЕсли;
		
		СистемаБыстрыхПлатежейСлужебный.СохранитьНастройкиАутентификации(
			НастройкаПодключения.Ссылка,
			ПараметрыАутентификации,
			НастройкаПодключения.ИдентификаторУчастника);
		
		Результат.Ссылка = НастройкаПодключения.Ссылка;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		Результат.Ошибка = Истина;
		Результат.СообщениеОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось записать настройку подключения по причине:
				|%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

// Обновляет идентификатор участника СБП у переданной настройки.
//
// Параметры:
//  НастройкаПодключения - Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей - элемент для обновления;
//  ИдентификаторУчастника - Строка - идентификатор участника Системы быстрых платежей.
//
// Возвращаемое значение:
//  СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей - новый или найденный корневой элемент.
//
Процедура ОбновитьИдентификаторУчастника(
		НастройкаПодключения,
		ИдентификаторУчастника) Экспорт
	
	НастройкаПодключенияОбъект = НастройкаПодключения.ПолучитьОбъект();
	НастройкаПодключенияОбъект.Заблокировать();
	НастройкаПодключенияОбъект.ИдентификаторУчастника = ИдентификаторУчастника;
	НастройкаПодключенияОбъект.Записать();
	
КонецПроцедуры

// Создает корневой элемент настроек подключения к СБП, если он отсутствует.
//
// Параметры:
//  ИдентификаторУчастника - Строка - идентификатор участника Системы быстрых платежей.
//
// Возвращаемое значение:
//  СправочникСсылка.НастройкиПодключенияКСистемеБыстрыхПлатежей - новый или найденный корневой элемент.
//
Функция РодительНастройки(ИдентификаторУчастника) Экспорт
	
	НачатьТранзакцию();
	
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей");
		ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ ПЕРВЫЕ 1
			|	НастройкиПодключенияКСистемеБыстрыхПлатежей.Родитель КАК Родитель
			|ИЗ
			|	Справочник.НастройкиПодключенияКСистемеБыстрыхПлатежей КАК НастройкиПодключенияКСистемеБыстрыхПлатежей
			|ГДЕ
			|	НастройкиПодключенияКСистемеБыстрыхПлатежей.ИдентификаторУчастника = &ИдентификаторУчастника";
		
		Запрос.УстановитьПараметр("ИдентификаторУчастника", ИдентификаторУчастника);
		РезультатЗапроса = Запрос.Выполнить();
		Если РезультатЗапроса.Пустой() Тогда
			
			НастройкиУчастника = СистемаБыстрыхПлатежейСлужебный.НастройкиУчастникаСБП(
				ИдентификаторУчастника);
			Если НастройкиУчастника = Неопределено Тогда
				ВызватьИсключение НСтр("ru = 'Неопределенны настройки участника СБП.'");
			КонецЕсли;
			
			РодительНастройкиОбъект = СоздатьГруппу();
			РодительНастройкиОбъект.Наименование = НастройкиУчастника.Наименование;
			РодительНастройкиОбъект.Записать();
			РодительНастройки = РодительНастройкиОбъект.Ссылка;
			
		Иначе
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			ВыборкаДетальныеЗаписи.Следующий();
			РодительНастройки = ВыборкаДетальныеЗаписи.Родитель;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстИсключения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось записать корневой узел настройки:
				|%1'"),
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ВызватьИсключение ТекстИсключения;
		
	КонецПопытки;
	
	Возврат РодительНастройки;
	
КонецФункции

#КонецОбласти

#КонецЕсли
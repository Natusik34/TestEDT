///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Начинает установку доверенных сертификатов, сертификаты будут установлены если они отсутствую в хранилище.
//
// Параметры:
//  ОповещениеЗавершения - ОписаниеОповещения - описание оповещения при завершении установки, описание результата 
//                         см. РезультатОперации.
//  Сертификаты - см. СертификатыНУЦМинцифры.СписокДоверенныхСертификатов
//
Процедура НачатьУстановкуДоверенныхСертификатов(ОповещениеЗавершения, Сертификаты = Неопределено) Экспорт
	
	Если Сертификаты = Неопределено Тогда
		РезультатОперации = РезультатОперации();
		РезультатОперации.Результат = Ложь;
		РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Не найдены корневые сертификаты.'");
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, РезультатОперации);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияБПОКлиент.ЭтоWindowsКлиент() Тогда
		Контекст = Новый Структура();
		Контекст.Вставить("Сертификаты", Сертификаты);
		Контекст.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
		
		Оповещение = Новый ОписаниеОповещения("НачатьУстановкуДоверенныхСертификатовЗавершение", ЭтотОбъект, Контекст);
		НачатьПодключениеКомпонентыExtraCryptoAPI(Оповещение);
	Иначе
		РезультатОперации = РезультатОперации();
		РезультатОперации.Результат = Ложь;
		РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Установка сертификатов поддерживается только в Windows.'");
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, РезультатОперации);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

// Начинает получение списка установленных доверенных сертификатов
//
// Параметры:
//  ОповещениеЗавершения - ОписаниеОповещения - описание оповещения при завершении проверки, описание результата 
//                         см. РезультатОперации.
//  Сертификаты - см. СертификатыНУЦМинцифры.СписокДоверенныхСертификатов
//
Процедура НачатьПроверкуДоверенныхСертификатов(ОповещениеЗавершения, Сертификаты = Неопределено) Экспорт
	
	Если Сертификаты = Неопределено Тогда
		РезультатОперации = РезультатОперации();
		РезультатОперации.Результат = Ложь;
		РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Не найдены корневые сертификаты.'");
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, РезультатОперации);
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияБПОКлиент.ЭтоWindowsКлиент() Тогда
		Контекст = Новый Структура();
		Контекст.Вставить("Сертификаты", Сертификаты);
		Контекст.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
		
		Оповещение = Новый ОписаниеОповещения("НачатьПроверкуДоверенныхСертификатовЗавершение", ЭтотОбъект, Контекст);
		НачатьПодключениеКомпонентыExtraCryptoAPI(Оповещение);
	Иначе
		РезультатОперации = РезультатОперации();
		РезультатОперации.Результат = Ложь;
		РезультатОперации.ОписаниеОшибки = НСтр("ru = 'Проверка сертификатов поддерживается только в Windows.'");
		Если ОповещениеЗавершения <> Неопределено Тогда
			ВыполнитьОбработкуОповещения(ОповещениеЗавершения, РезультатОперации);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Завершает установку компоненты
//
Процедура НачатьУстановкуДоверенныхСертификатовЗавершение(Результат, Контекст) Экспорт
	
	РезультатОперации = РезультатОперации();
	Если Результат.Подключено Тогда
		ОбъектКомпоненты = Результат.ПодключаемыйМодуль;
		Сертификаты      = Контекст.Сертификаты;
		ТекстОшибки      = "";
		Попытка
			Для Каждого Элемент Из Сертификаты Цикл
				СертификатНайден = ОбъектКомпоненты.СертификатУстановленВХранилище(Элемент.Сертификат, Элемент.Хранилище);
				СертификатНайден = (СертификатНайден = Истина); // СертификатНайден может содержать Неопределено вместо Ложь
				Если Не СертификатНайден Тогда
					УстановкаВыполнена = ОбъектКомпоненты.УстановитьСертификатВХранилище(Элемент.Сертификат, Элемент.Хранилище);
					УстановкаВыполнена = (УстановкаВыполнена = Истина); // УстановкаВыполнена может содержать Неопределено вместо Ложь
					Если Не УстановкаВыполнена Тогда
						ТекстОшибки = ТекстОшибки + Символы.ПС + ОбъектКомпоненты.GetLastError();
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			Если Не ПустаяСтрока(ТекстОшибки) Тогда
				РезультатОперации.Результат = Ложь;
				РезультатОперации.ОписаниеОшибки     = СтрШаблон(НСтр("ru = 'Установка сертификатов не выполнена. %1'"), ТекстОшибки);
			Иначе
				РезультатОперации.Результат = Истина;
			КонецЕсли;
		Исключение
			РезультатОперации.Результат = Ложь;
			РезультатОперации.ОписаниеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	ИначеЕсли ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		РезультатОперации.Результат      = Ложь;
		РезультатОперации.ОписаниеОшибки = Результат.ОписаниеОшибки;
	Иначе
		РезультатОперации.Результат      = Ложь;
		РезультатОперации.ОписаниеОшибки = СтрШаблон(НСтр("ru = 'Не удалось подключить внешнюю компоненту %1.'"), "ExtraCryptoAPI");
	КонецЕсли;
	
	Если Контекст.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеЗавершения, РезультатОперации);
	КонецЕсли;
	
КонецПроцедуры

// Завершает получение списка установленных доверенных сертификатов после установки драйвера
//
Процедура НачатьПроверкуДоверенныхСертификатовЗавершение(Результат, Контекст) Экспорт
	
	РезультатОперации = РезультатОперации();
	
	ЕстьНеНайденныеСертификаты = Ложь;
	Текст = "";
	Если Результат.Подключено Тогда
		
		ОбъектКомпоненты = Результат.ПодключаемыйМодуль;
		Сертификаты      = Контекст.Сертификаты;
		Попытка
			Для Каждого Элемент Из Сертификаты Цикл
				СертификатНайден = ОбъектКомпоненты.СертификатУстановленВХранилище(Элемент.Сертификат, Элемент.Хранилище);
				СертификатНайден = (СертификатНайден = Истина); // СертификатНайден может содержать Неопределено вместо Ложь
				Если Не СертификатНайден Тогда
					ЕстьНеНайденныеСертификаты = Истина;
					Текст = Текст + Символы.ПС + СтрШаблон(НСтр("ru = 'Сертификат в хранилище %1 не установлен.'"), Элемент.Хранилище);
				КонецЕсли;
			КонецЦикла;
			РезультатОперации.Результат      = Не ЕстьНеНайденныеСертификаты;
			РезультатОперации.ОписаниеОшибки = Сред(Текст, 2);
		Исключение
			РезультатОперации.Результат      = Ложь;
			РезультатОперации.ОписаниеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецПопытки;
		
	ИначеЕсли ЗначениеЗаполнено(Результат.ОписаниеОшибки) Тогда
		
		РезультатОперации.Результат      = Ложь;
		РезультатОперации.ОписаниеОшибки = Результат.ОписаниеОшибки;
		
	Иначе
		
		РезультатОперации.Результат      = Ложь;
		РезультатОперации.ОписаниеОшибки = СтрШаблон(НСтр("ru = 'Не удалось подключить внешнюю компоненту %1.'"), "ExtraCryptoAPI");
		
	КонецЕсли;
	
	Если Контекст.ОповещениеЗавершения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Контекст.ОповещениеЗавершения, РезультатОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает структуру результата операции
//
// Возвращаемое значение:
//  Структура:
//   * Результат - Булево
//   * ОписаниеОшибки - Строка
Функция РезультатОперации()
	
	Возврат Новый Структура("Результат, ОписаниеОшибки", Ложь, "");
	
КонецФункции

Процедура НачатьПодключениеКомпонентыExtraCryptoAPI(Оповещение)
	
	// выполнить установку компоненты
	ИмяОбъекта = "ExtraCryptoAPI";
	ПолныйПуть = "Справочник.СертификатыКлючейЭлектроннойПодписиИШифрования.Макет.КомпонентаExtraCryptoAPI";
	
	ПараметрыПодключения = ВнешниеКомпонентыБПОКлиент.ПараметрыПодключения();
	ПараметрыПодключения.ТекстПояснения = СтрШаблон(
		НСтр("ru = 'Для проверки установки корневых сертификатов требуется установить компоненту %1.'"),
		ИмяОбъекта);
	ПараметрыПодключения.ПредложитьУстановить = Истина;
	ПараметрыПодключения.ПредложитьЗагрузить = Ложь;
	
	ВнешниеКомпонентыБПОКлиент.ПодключитьКомпонентуИзМакета(Оповещение, 
		ИмяОбъекта, 
		ПолныйПуть,
		ПараметрыПодключения);
		
КонецПроцедуры

#КонецОбласти

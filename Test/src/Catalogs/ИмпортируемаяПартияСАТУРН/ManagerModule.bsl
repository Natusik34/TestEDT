#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

#Область Обмен

Функция ДанныеОбъекта(ЭлементДанных) Экспорт
	
	ДанныеИмпортируемойПартии = Новый Структура;
	
	ДанныеИмпортируемойПартии.Вставить("GUID",               ЭлементДанных.sys_guid);
	ДанныеИмпортируемойПартии.Вставить("Идентификатор",      ЭлементДанных.id);
	ДанныеИмпортируемойПартии.Вставить("Статус",             ИнтерфейсСАТУРН.СтатусИмпортируемойПродукции(ЭлементДанных.lcState));
	ДанныеИмпортируемойПартии.Вставить("ДатаПолучения",      ИнтеграцияИС.ДатаСАТУРН_ISO8601(ЭлементДанных.dateReceive));
	ДанныеИмпортируемойПартии.Вставить("ДатаВвоза",          ИнтеграцияИС.ДатаСАТУРН_ISO8601(ЭлементДанных.dateOfImport));
	ДанныеИмпортируемойПартии.Вставить("НомерТТНАРГУС",      ЭлементДанных.argus_TTNDocument);
	ДанныеИмпортируемойПартии.Вставить("КоличествоУпаковок", ЭлементДанных.unitCount);
	ДанныеИмпортируемойПартии.Вставить("КоличествоВУпаковкеСАТУРН", ЭлементДанных.unitQuantity);
	ДанныеИмпортируемойПартии.Вставить("Наименование",       ЭлементДанных.name);
	ДанныеИмпортируемойПартии.Вставить("Маркировка",         ЭлементДанных.seriesCode);
	ДанныеИмпортируемойПартии.Вставить("УпаковочнаяЕдиница", Справочники.КлючиЕдиницИзмеренияСАТУРН.ДанныеОбъекта(ЭлементДанных));
	
	ДанныеИмпортируемойПартии.Вставить("ИдентификаторАРГУС",                          ЭлементДанных.argus_journalRecID);
	ДанныеИмпортируемойПартии.Вставить("НаименованиеОтправителяАРГУС",                ЭлементДанных.argus_contractorName);
	ДанныеИмпортируемойПартии.Вставить("ИдентификаторПредприятияРастаможиванияАРГУС", ЭлементДанных.argus_pesticidesExporter);
	
	// инициализация значений, которые могут отсутствовать в структуре данных
	ДанныеИмпортируемойПартии.Вставить("ДанныеМестаХранения",        Неопределено);
	ДанныеИмпортируемойПартии.Вставить("ИдентификаторМестаХранения", "");
	
	ДанныеИмпортируемойПартии.Вставить("ДанныеПартии",               Неопределено);
	ДанныеИмпортируемойПартии.Вставить("ИдентификаторПартии",        "");
	
	ДанныеИмпортируемойПартии.Вставить("ДанныеОрганизации",          Неопределено);
	ДанныеИмпортируемойПартии.Вставить("ИдентификаторОрганизации",   "");
	
	ДанныеИмпортируемойПартии.Вставить("ДанныеПАТ",                  Неопределено);
	ДанныеИмпортируемойПартии.Вставить("ИдентификаторПАТ",           "");
	
	Если ТипЗнч(ЭлементДанных.targetWarehouseId) = Тип("Структура") Тогда
		
		Если ЭлементДанных.targetWarehouseId.Свойство("id") Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторМестаХранения", ЭлементДанных.targetWarehouseId.id);
			ДанныеИмпортируемойПартии.Вставить("ДанныеМестаХранения",        ЭлементДанных.targetWarehouseId);
			
		ИначеЕсли ЭлементДанных.targetWarehouseId.Свойство("_id") Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторМестаХранения", ЭлементДанных.targetWarehouseId._id);
			ДанныеИмпортируемойПартии.Вставить("ДанныеМестаХранения",        ЭлементДанных.targetWarehouseId);
			
		КонецЕсли;
		
	Иначе
		
		Если Не ЭлементДанных.targetWarehouseId = 0
			И Не ЭлементДанных.targetWarehouseId = "-1"
			И Не ЭлементДанных.targetWarehouseId = -1 Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторМестаХранения", ЭлементДанных.targetWarehouseId);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных.batchIdReg) = Тип("Структура") Тогда
		
		Если ЭлементДанных.batchIdReg.Свойство("id") Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторПартии", ЭлементДанных.batchIdReg.id);
			ДанныеИмпортируемойПартии.Вставить("ДанныеПартии",        ЭлементДанных.batchIdReg);
			
		ИначеЕсли ЭлементДанных.batchIdReg.Свойство("_id") Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторПартии", ЭлементДанных.batchIdReg._id);
			ДанныеИмпортируемойПартии.Вставить("ДанныеПартии",        ЭлементДанных.batchIdReg);
			
		КонецЕсли;
		
	Иначе
		
		Если Не ЭлементДанных.batchIdReg = 0
			И Не ЭлементДанных.batchIdReg = "-1"
			И Не ЭлементДанных.batchIdReg = -1 Тогда
				
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторПартии", ЭлементДанных.batchIdReg);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных.patProductId) = Тип("Структура") Тогда
		
		Если ЭлементДанных.patProductId.Свойство("id") Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторПАТ", ЭлементДанных.patProductId.id);
			ДанныеИмпортируемойПартии.Вставить("ДанныеПАТ",        ЭлементДанных.patProductId);
			
		ИначеЕсли ЭлементДанных.patProductId.Свойство("_id") Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторПАТ", ЭлементДанных.patProductId._id);
			ДанныеИмпортируемойПартии.Вставить("ДанныеПАТ",        ЭлементДанных.patProductId);
			
		КонецЕсли;
		
	Иначе
		
		Если Не ЭлементДанных.patProductId = 0
			И Не ЭлементДанных.patProductId = "-1"
			И Не ЭлементДанных.patProductId = -1 Тогда
				
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторПАТ", ЭлементДанных.patProductId);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных.contractorId) = Тип("Структура") Тогда
		
		Если ЭлементДанных.contractorId.Свойство("id") Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторОрганизации", ЭлементДанных.contractorId.id);
			ДанныеИмпортируемойПартии.Вставить("ДанныеОрганизации",        ЭлементДанных.contractorId);
			
		ИначеЕсли ЭлементДанных.contractorId.Свойство("_id") Тогда
			
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторОрганизации", ЭлементДанных.contractorId._id);
			ДанныеИмпортируемойПартии.Вставить("ДанныеОрганизации",        ЭлементДанных.contractorId);
			
		КонецЕсли;
		
	Иначе
		
		Если Не ЭлементДанных.contractorId = 0
			И Не ЭлементДанных.contractorId = "-1"
			И Не ЭлементДанных.contractorId = -1 Тогда
				
			ДанныеИмпортируемойПартии.Вставить("ИдентификаторОрганизации", ЭлементДанных.contractorId);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ДанныеИмпортируемойПартии.Вставить("Комментарий", ЭлементДанных.description);
	
	Возврат ДанныеИмпортируемойПартии;
	
КонецФункции

Процедура ОбработкаЗагрузкиПолученныхДанных(ЭлементОчереди, ПараметрыОбмена, ПолученныеДанные, ИзмененныеОбъекты) Экспорт
	
	Если ЭлементОчереди.Операция = ОперацияЗагрузкиКлассификатора() Тогда
		
		ВходящиеДанные = ИнтеграцияСАТУРНСлужебный.ОбработатьРезультатЗапросаСпискаОбъектов(ПолученныеДанные, ПараметрыОбмена);
		ИнтеграцияСАТУРНСлужебный.СсылкиПоИдентификаторам(ПараметрыОбмена, ИзмененныеОбъекты);
		
		ДатаИзменения = Дата(1, 1, 1);
		
		Попытка
			
			Для Каждого ЭлементДанных Из ВходящиеДанные Цикл
				
				ДанныеОбъекта   = ДанныеОбъекта(ЭлементДанных);
				СсылкаНаЭлемент = ЗагрузитьОбъект(ДанныеОбъекта, ПараметрыОбмена,,, ЭлементОчереди.ОрганизацияСАТУРН);
				
				ДатаИзменения = ИнтеграцияИС.ДатаИзСтрокиUNIX(ЭлементДанных.sys_changedAt);
				
				Если ЗначениеЗаполнено(СсылкаНаЭлемент) Тогда
					ИзмененныеОбъекты.Добавить(СсылкаНаЭлемент);
				КонецЕсли;
				
			КонецЦикла;
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
		
		ПараметрыЗапроса = ЭлементОчереди.РеквизитыИсходящегоСообщения.ПараметрыЗапроса;
		
		Если ПараметрыЗапроса.ОбновитьДатуСинхронизации Тогда
			
			Если ДатаИзменения > ПараметрыЗапроса.ДатаСинхронизации Тогда
				
				РегистрыСведений.СинхронизацияСтатусовДокументовСАТУРН.УстановитьДатуВыполненияСинхронизации(
					ЭлементОчереди.ОрганизацияСАТУРН,
					Перечисления.ВидыНастроекОбменаСАТУРН.ЗагрузкаИмпортируемыхПартий,
					ДатаИзменения);
				
			ИначеЕсли ЗначениеЗаполнено(ПараметрыЗапроса.ДатаОкончания)
				И ПараметрыЗапроса.ДатаОкончания > ПараметрыЗапроса.ДатаСинхронизации Тогда
				
				РегистрыСведений.СинхронизацияСтатусовДокументовСАТУРН.УстановитьДатуВыполненияСинхронизации(
					ЭлементОчереди.ОрганизацияСАТУРН,
					Перечисления.ВидыНастроекОбменаСАТУРН.ЗагрузкаИмпортируемыхПартий,
					ПараметрыЗапроса.ДатаОкончания);
				
			КонецЕсли;
			
		Иначе
			
			// Обновить дату выполнения обмена
			РегистрыСведений.СинхронизацияСтатусовДокументовСАТУРН.УстановитьДатуВыполненияСинхронизации(
				ЭлементОчереди.ОрганизацияСАТУРН,
				Перечисления.ВидыНастроекОбменаСАТУРН.ЗагрузкаИмпортируемыхПартий);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ОперацияЗагрузкиКлассификатора() Экспорт
	Возврат Перечисления.ВидыОперацийСАТУРН.ИмпортируемаяПартияЗапросКлассификатора;
КонецФункции

#КонецОбласти

#Область ПоискСсылок

Функция ЗагрузитьОбъект(ДанныеИмпортируемойПартии, ПараметрыОбмена, ДокументОбъект = Неопределено, ТребуетсяПоиск = Истина, ОрганизацияСАТУРН = Неопределено) Экспорт
	
	Если ДанныеИмпортируемойПартии = Неопределено Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	ЗаписьНового = Ложь;
	ЗаписьНового = Ложь;
	ИмяТаблицы   = Метаданные.Справочники.ИмпортируемаяПартияСАТУРН.ПолноеИмя();
	
	Если ДокументОбъект = Неопределено Тогда
		
		СправочникСсылка = Неопределено;
		Если ТребуетсяПоиск Тогда
			СправочникСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(
				ПараметрыОбмена, ИмяТаблицы, ДанныеИмпортируемойПартии.Идентификатор);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
			
			СправочникОбъект = СоздатьЭлемент();
			СправочникОбъект.Заполнить(Неопределено);
			
			ИдентификаторОбъекта = Новый УникальныйИдентификатор();
			СправочникСсылка = ПолучитьСсылку(ИдентификаторОбъекта);
			СправочникОбъект.УстановитьСсылкуНового(СправочникСсылка);
			
			ЗаписьНового = Истина;
			
		Иначе
			СправочникОбъект = СправочникСсылка.ПолучитьОбъект();
		КонецЕсли;
		
	Иначе
		СправочникСсылка = ДокументОбъект.Ссылка;
	КонецЕсли;
	
	Если Не ЗаписьНового Тогда
		СправочникОбъект.Заблокировать();
	КонецЕсли;
	
	СправочникОбъект.Идентификатор             = ДанныеИмпортируемойПартии.Идентификатор;
	СправочникОбъект.ДатаПолучения             = ДанныеИмпортируемойПартии.ДатаПолучения;
	СправочникОбъект.НомерТТНАРГУС             = ДанныеИмпортируемойПартии.НомерТТНАРГУС;
	СправочникОбъект.КоличествоВУпаковкеСАТУРН = ДанныеИмпортируемойПартии.КоличествоВУпаковкеСАТУРН;
	СправочникОбъект.КоличествоУпаковок        = ДанныеИмпортируемойПартии.КоличествоУпаковок;
	СправочникОбъект.ДатаВвоза                 = ДанныеИмпортируемойПартии.ДатаВвоза;
	СправочникОбъект.Маркировка                = ДанныеИмпортируемойПартии.Маркировка;
	СправочникОбъект.ИдентификаторПартии       = ДанныеИмпортируемойПартии.ИдентификаторПартии;
	СправочникОбъект.Наименование              = ДанныеИмпортируемойПартии.Наименование;
	СправочникОбъект.Статус                    = ДанныеИмпортируемойПартии.Статус;
	
	СправочникОбъект.ИдентификаторАРГУС                          = ДанныеИмпортируемойПартии.ИдентификаторАРГУС;
	СправочникОбъект.НаименованиеОтправителяАРГУС                = ДанныеИмпортируемойПартии.НаименованиеОтправителяАРГУС;
	СправочникОбъект.ИдентификаторПредприятияРастаможиванияАРГУС = ДанныеИмпортируемойПартии.ИдентификаторПредприятияРастаможиванияАРГУС;
	
	Если ЗначениеЗаполнено(ДанныеИмпортируемойПартии.ИдентификаторМестаХранения) Тогда
		
		МестоХранения = Справочники.МестаХраненияСАТУРН.МестоХранения(ДанныеИмпортируемойПартии.ИдентификаторМестаХранения, ПараметрыОбмена);
		СправочникОбъект.МестоХранения = МестоХранения;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеИмпортируемойПартии.ИдентификаторПАТ) Тогда
		
		ПАТ = Справочники.КлассификаторПАТСАТУРН.ПАТ(ДанныеИмпортируемойПартии.ИдентификаторПАТ, ПараметрыОбмена);
		СправочникОбъект.ПАТ = ПАТ;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеИмпортируемойПартии.ИдентификаторОрганизации) Тогда
		
		Организация = Справочники.КлассификаторОрганизацийСАТУРН.Организация(ДанныеИмпортируемойПартии.ИдентификаторОрганизации, ПараметрыОбмена);
		СправочникОбъект.ОрганизацияСАТУРН = Организация;
		
	Иначе
		СправочникОбъект.ОрганизацияСАТУРН  = ОрганизацияСАТУРН;
	КонецЕсли;
	
	СправочникОбъект.УпаковочнаяЕдиница = Справочники.КлючиЕдиницИзмеренияСАТУРН.КлючЕдиницы(
		ДанныеИмпортируемойПартии.УпаковочнаяЕдиница.Идентификатор,
		ПараметрыОбмена,
		ДанныеИмпортируемойПартии.УпаковочнаяЕдиница);
	
	СправочникОбъект.Записать();
	
	ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(
		ПараметрыОбмена,
		ИмяТаблицы,
		ДанныеИмпортируемойПартии.Идентификатор,
		СправочникОбъект.Ссылка);
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

#КонецОбласти

#Область Сообщения

// Сообщение к передаче JSON.
//
// Параметры:
//  СправочникСсылка - ДокументСсылка.ИмпортПродукцииСАТУРН - Ссылка на документ итмпорта.
//  ДальнейшееДействие - ПеречислениеСсылка.ДальнейшиеДействияПоВзаимодействиюСАТУРН - Дальнейшее действие.
//  ДополнительныеПараметры - Структура, Неопределено - Дополнительные параметры.
//
// Возвращаемое значение:
//  Массив Из См. ИнтеграцияСАТУРНСлужебный.СтруктураСообщенияJSON - Сообщения к передаче.
//
Функция СообщениеКПередачеJSON(СправочникСсылка, ДальнейшееДействие, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДальнейшееДействие = Перечисления.ДальнейшиеДействияПоВзаимодействиюСАТУРН.ВыполнитеОбмен Тогда
		
		СообщенияJSON = ЗагрузкаИмпортаПродукцииСАТУРН(ДополнительныеПараметры);
		
	КонецЕсли;
	
	Возврат СообщенияJSON;
	
КонецФункции

Функция ЗагрузкаИмпортаПродукцииСАТУРН(ДополнительныеПараметры)
	
	ПараметрыОбработкиДокумента = ДополнительныеПараметры.ПараметрыОбработкиДокумента;
	
	Операция      = ОперацияЗагрузкиКлассификатора();
	СообщенияJSON = Новый Массив;
	
	СообщениеJSON = ИнтеграцияСАТУРНСлужебный.СтруктураСообщенияJSON();
	СообщениеJSON.Документ            = ПустаяСсылка();
	СообщениеJSON.Версия              = 1;
	СообщениеJSON.Операция            = Операция;
	СообщениеJSON.Описание            = ИнтеграцияСАТУРНСлужебный.ОписаниеОперацииПередачиДанных(СообщениеJSON.Операция);
	СообщениеJSON.АргументыОперации   = Новый Структура;
	СообщениеJSON.ОрганизацияСАТУРН   = ПараметрыОбработкиДокумента.ОрганизацияСАТУРН;
	
	ПараметрыЗапроса = Новый Структура;
	ПараметрыЗапроса.Вставить("ОбновитьДатуСинхронизации", Ложь);
	ПараметрыЗапроса.Вставить("ДатаСинхронизации",         Дата(1, 1, 1));
	ПараметрыЗапроса.Вставить("ДатаОкончания",             Дата(1, 1, 1));
	
	Если ТипЗнч(ПараметрыОбработкиДокумента.ДополнительныеПараметры) = Тип("Структура") Тогда 
		
		ПараметрыЗапроса.ДатаСинхронизации = РегистрыСведений.СинхронизацияСтатусовДокументовСАТУРН.ДатаСинхронизации(
			ПараметрыОбработкиДокумента.ОрганизацияСАТУРН,
			Перечисления.ВидыНастроекОбменаСАТУРН.ЗагрузкаИмпортируемыхПартий);
		
		ПараметрыФормирования = Новый Структура;
		ПараметрыФормирования.Вставить("ДатаНачала",          Дата(1, 1, 1));
		ПараметрыФормирования.Вставить("ДатаОкончания",       Дата(1, 1, 1));
		ПараметрыФормирования.Вставить("ИдентификаторОтбора", Неопределено);
		ПараметрыФормирования.Вставить("Статус",              Неопределено);
		ЗаполнитьЗначенияСвойств(ПараметрыФормирования, ПараметрыОбработкиДокумента.ДополнительныеПараметры);
		
		ПараметрыЗапроса.ДатаОкончания = ПараметрыФормирования.ДатаОкончания;
		
		Если Не ЗначениеЗаполнено(ПараметрыЗапроса.ДатаСинхронизации)
			И Не ЗначениеЗаполнено(ПараметрыФормирования.ДатаНачала) Тогда
			Сутки = 86400;
			ПараметрыФормирования.ДатаНачала = НачалоДня(ТекущаяДатаСеанса()) - 30 * Сутки;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПараметрыФормирования.ИдентификаторОтбора)
			И Не ЗначениеЗаполнено(ПараметрыФормирования.Статус)
			И (ЗначениеЗаполнено(ПараметрыЗапроса.ДатаСинхронизации)
				И (Не ЗначениеЗаполнено(ПараметрыФормирования.ДатаНачала)
					Или ПараметрыЗапроса.ДатаСинхронизации > ПараметрыФормирования.ДатаНачала)
				Или Не ЗначениеЗаполнено(ПараметрыЗапроса.ДатаСинхронизации)
					И Не ЗначениеЗаполнено(ПараметрыФормирования.ДатаНачала)
					И Не ЗначениеЗаполнено(ПараметрыФормирования.ДатаОкончания)) Тогда
			ПараметрыЗапроса.ОбновитьДатуСинхронизации = Истина;
		КонецЕсли;
		
		МассивОтборов = Новый Массив;
		
		Если ЗначениеЗаполнено(ПараметрыФормирования.ДатаНачала) Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("column",    "dateOfImport");
			Отбор.Вставить("condition", ">=");
			Отбор.Вставить("value",
				Формат(ИнтеграцияИС.ДатаВСтрокуUNIX(ПараметрыФормирования.ДатаНачала), "ЧГ=0;"));
			МассивОтборов.Добавить(Отбор);
		ИначеЕсли Не ЗначениеЗаполнено(ПараметрыФормирования.ИдентификаторОтбора)
			И ЗначениеЗаполнено(ПараметрыЗапроса.ДатаСинхронизации) Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("column",    "sys_changedAt");
			Отбор.Вставить("condition", ">=");
			Отбор.Вставить("value",
				Формат(ИнтеграцияИС.ДатаВСтрокуUNIX(ПараметрыЗапроса.ДатаСинхронизации), "ЧГ=0;"));
			МассивОтборов.Добавить(Отбор);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПараметрыФормирования.ДатаОкончания) Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("column",    "dateOfImport");
			Отбор.Вставить("condition", "<=");
			Отбор.Вставить("value",
				Формат(ИнтеграцияИС.ДатаВСтрокуUNIX(ПараметрыФормирования.ДатаОкончания), "ЧГ=0;"));
			МассивОтборов.Добавить(Отбор);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПараметрыФормирования.ИдентификаторОтбора) Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("column",    "id");
			Отбор.Вставить("condition", "=");
			Отбор.Вставить("value",     ПараметрыФормирования.ИдентификаторОтбора);
			МассивОтборов.Добавить(Отбор);
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ПараметрыФормирования.Статус) Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("column",    "lcState");
			Отбор.Вставить("condition", "=");
			Отбор.Вставить("value",     ИнтерфейсСАТУРН.СтатусИмпортаПродукции(ПараметрыФормирования.Статус));
			МассивОтборов.Добавить(Отбор);
		ИначеЕсли Не ЗначениеЗаполнено(ПараметрыФормирования.ДатаНачала)
			И Не ЗначениеЗаполнено(ПараметрыФормирования.ИдентификаторОтбора)
			И Не ЗначениеЗаполнено(ПараметрыЗапроса.ДатаСинхронизации) Тогда
			Отбор = Новый Структура;
			Отбор.Вставить("column",    "lcState");
			Отбор.Вставить("condition", "=");
			Отбор.Вставить("value",
				ИнтерфейсСАТУРН.СтатусИмпортаПродукции(Перечисления.СтатусыОбработкиИмпортаПродукцииСАТУРН.Ввезено));
			МассивОтборов.Добавить(Отбор);
		КонецЕсли;
		
		СообщениеJSON.АргументыОперации.Вставить("filters", МассивОтборов);
		
	КонецЕсли;
	
	СообщениеJSON.ПараметрыЗапроса = ПараметрыЗапроса;
	
	СообщениеJSON.АргументыОперации.Вставить("getFullCards", 1);
	
	СообщенияJSON.Добавить(СообщениеJSON);
	
	Возврат СообщенияJSON;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецЕсли
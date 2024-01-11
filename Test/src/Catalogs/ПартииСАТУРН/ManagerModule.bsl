#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает текст запроса получения информации о сопоставлении ПАТ
//   номенклатуре, производителям, маркировке.
//
// Возвращаемое значение:
//   Строка - текст запроса
//
Функция ТекстЗапросаИнформацияОСопоставлении() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	СоответствиеНоменклатурыСАТУРН.Партия КАК Партия,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ СоответствиеНоменклатурыСАТУРН.Номенклатура) КАК Количество
	|ПОМЕСТИТЬ СопоставленоПозиций
	|ИЗ
	|	РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеНоменклатурыСАТУРН
	|ГДЕ
	|	СоответствиеНоменклатурыСАТУРН.Партия В (&Партия)
	|СГРУППИРОВАТЬ ПО
	|	СоответствиеНоменклатурыСАТУРН.Партия
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Партия
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Товары.Ссылка КАК Ссылка,
	|	ЕСТЬNULL(СопоставленоПозиций.Количество, 0) КАК Количество,
	|	СоответствиеНоменклатурыСАТУРН.Номенклатура КАК Номенклатура,
	|	СоответствиеНоменклатурыСАТУРН.Характеристика КАК Характеристика,
	|	ПРЕДСТАВЛЕНИЕ(СоответствиеНоменклатурыСАТУРН.Номенклатура) КАК НоменклатураПредставление
	|ИЗ
	|	Справочник.ПартииСАТУРН КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ СопоставленоПозиций КАК СопоставленоПозиций
	|		ПО (СопоставленоПозиций.Партия = Товары.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеНоменклатурыСАТУРН
	|		ПО Товары.Ссылка = СоответствиеНоменклатурыСАТУРН.Партия
	|		И (СопоставленоПозиций.Количество = 1
	|		ИЛИ СоответствиеНоменклатурыСАТУРН.Порядок = 1)
	|ГДЕ
	|	Товары.Ссылка В (&Партия)";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаВыбора" Тогда
	
		Если Параметры = Неопределено Тогда
			Параметры = Новый Структура();
		КонецЕсли;
		
		Параметры.Вставить("РежимВыбора", Истина);
		
		ВыбраннаяФорма       = "РегистрНакопления.ОстаткиПартийСАТУРН.Форма.ФормаОстатков";
		СтандартнаяОбработка = Ложь;
	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ДанныеОбъекта(ЭлементДанных) Экспорт
	
	ДанныеПартии = Новый Структура;
	
	ДанныеПартии.Вставить("GUID",          ЭлементДанных.sys_guid);
	ДанныеПартии.Вставить("Идентификатор", ЭлементДанных.id);
	ДанныеПартии.Вставить("Статус",        ИнтерфейсСАТУРН.Статус(ЭлементДанных.lcState));
	ДанныеПартии.Вставить("ДатаСоздания",  ИнтерфейсСАТУРН.ДатаИзСтрокиISO(ЭлементДанных.dateFrom));
	ДанныеПартии.Вставить("СрокГодности",  ИнтерфейсСАТУРН.ДатаИзСтрокиISO(ЭлементДанных.expirationDate));
	ДанныеПартии.Вставить("ТорговоеНаименование",  ЭлементДанных.itemMarkName);
	ДанныеПартии.Вставить("НомерПартии",           ЭлементДанных.batchCode);
	ДанныеПартии.Вставить("УпаковкаНаименование",  ЭлементДанных.pu_title);
	ДанныеПартии.Вставить("КратностьУпаковки",     ЭлементДанных.pu_kgWeight);
	ДанныеПартии.Вставить("ДатаПроизводства",      ИнтерфейсСАТУРН.ДатаИзСтрокиISO(ЭлементДанных.productionDate));
	ДанныеПартии.Вставить("УпаковочнаяЕдиница",    Справочники.КлючиЕдиницИзмеренияСАТУРН.ДанныеОбъекта(ЭлементДанных));
	ДанныеПартии.Вставить("ТипИзмеряемойВеличиныСАТУРН",
		ИнтерфейсСАТУРН.ТипИзмеряемойВеличины(ЭлементДанных.baseUnitType));
	
	// инициализация значений, которые могут отсутствовать в структуре данных
	ДанныеПартии.Вставить("Наименование",          "");
	ДанныеПартии.Вставить("Комментарий",           "");
	
	ДанныеПартии.Вставить("ДанныеПАТ",             Неопределено);
	ДанныеПартии.Вставить("ИдентификаторПАТ",      "");
	
	ДанныеПартии.Вставить("ДанныеРодительскойПартии",        Неопределено);
	ДанныеПартии.Вставить("ИдентификаторРодительскойПартии", "");
	
	Если ДанныеПартии.Свойство("name") Тогда
		ДанныеПартии.Вставить("Наименование",          ЭлементДанных.name);
	КонецЕсли;
	
	Если ДанныеПартии.Свойство("description") Тогда
		ДанныеПартии.Вставить("Комментарий",           ЭлементДанных.description);
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных.patProductId) = Тип("Структура") Тогда
		
		Если ЭлементДанных.patProductId.Свойство("id") Тогда
			
			ДанныеПартии.Вставить("ИдентификаторПАТ", ЭлементДанных.patProductId.id);
			ДанныеПартии.Вставить("ДанныеПАТ",        ЭлементДанных.patProductId);
			
		ИначеЕсли ЭлементДанных.patProductId.Свойство("_id") Тогда
			
			ДанныеПартии.Вставить("ИдентификаторПАТ", ЭлементДанных.patProductId._id);
			ДанныеПартии.Вставить("ДанныеПАТ",        ЭлементДанных.patProductId);
			
		КонецЕсли;
		
	Иначе
		
		ДанныеПартии.Вставить("ИдентификаторПАТ", ЭлементДанных.patProductId);
		
	КонецЕсли;
	
	Если ТипЗнч(ЭлементДанных.parentBatchId) = Тип("Структура") Тогда
		
		Если ЭлементДанных.parentBatchId.Свойство("id") Тогда
			
			ДанныеПартии.Вставить("ИдентификаторРодительскойПартии", ЭлементДанных.parentBatchId.id);
			ДанныеПартии.Вставить("ДанныеРодительскойПартии",        ЭлементДанных.parentBatchId);
			
		ИначеЕсли ЭлементДанных.parentBatchId.Свойство("_id") Тогда
			
			ДанныеПартии.Вставить("ИдентификаторРодительскойПартии", ЭлементДанных.parentBatchId._id);
			ДанныеПартии.Вставить("ДанныеРодительскойПартии",        ЭлементДанных.parentBatchId);
			
		КонецЕсли;
		
	Иначе
		
		Если Не ЭлементДанных.parentBatchId = "0"
			И Не ЭлементДанных.parentBatchId = "-1"
			И Не ЭлементДанных.parentBatchId = -1 Тогда
		
			ДанныеПартии.Вставить("ИдентификаторРодительскойПартии", ЭлементДанных.parentBatchId);
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ДанныеПартии;
	
КонецФункции

Процедура ОбработкаЗагрузкиПолученныхДанных(ЭлементОчереди, ПараметрыОбмена, ПолученныеДанные, ИзмененныеОбъекты) Экспорт
	
	Если ЭлементОчереди.Операция = ОперацияЗагрузкиКлассификатора() Тогда
		
		ВходящиеДанные = ИнтеграцияСАТУРНСлужебный.ОбработатьРезультатЗапросаСпискаОбъектов(ПолученныеДанные, ПараметрыОбмена);
		ИнтеграцияСАТУРНСлужебный.СсылкиПоИдентификаторам(ПараметрыОбмена, ИзмененныеОбъекты);
		
		Попытка
			
			Для Каждого ЭлементДанных Из ВходящиеДанные Цикл
				
				ДанныеОбъекта   = ДанныеОбъекта(ЭлементДанных);
				СсылкаНаЭлемент = ЗагрузитьОбъект(ДанныеОбъекта, ПараметрыОбмена,,, ЭлементОчереди.ОрганизацияСАТУРН);
				
				Если Не ЗначениеЗаполнено(СсылкаНаЭлемент) Тогда
					Продолжить;
				КонецЕсли;
				ИзмененныеОбъекты.Добавить(СсылкаНаЭлемент);
				
			КонецЦикла;
			
		Исключение
			ВызватьИсключение;
		КонецПопытки;
	
	КонецЕсли;
	
КонецПроцедуры

Функция ОперацияЗагрузкиКлассификатора() Экспорт
	Возврат Перечисления.ВидыОперацийСАТУРН.ПартияЗапросКлассификатора;
КонецФункции

#Область ПоискСсылок

Функция ПараметрыПолученияПартии() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ДобавлятьКЗагрузке", Истина);
	ВозвращаемоеЗначение.Вставить("ДанныеПартии",       Неопределено);
	ВозвращаемоеЗначение.Вставить("НовыеОбъекты",       Новый Соответствие());
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция Партия(Идентификатор, ПараметрыОбмена, ОрганизацияСАТУРН = Неопределено, ПараметрыПолучения = Неопределено, ДатаКонтроля = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	ИмяТаблицы       = Метаданные.Справочники.ПартииСАТУРН.ПолноеИмя();
	СправочникСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
	
	Если ПараметрыПолучения = Неопределено Тогда
		ПараметрыПолучения = ПараметрыПолученияПартии();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СправочникСсылка) Тогда
		ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
	Иначе
		
		Блокировка = Новый БлокировкаДанных();
		ЭлементБлокировки = Блокировка.Добавить(ИмяТаблицы);
		ЭлементБлокировки.УстановитьЗначение("Идентификатор", Идентификатор);
		
		ТранзакцияЗафиксирована = Истина;
		
		НачатьТранзакцию();
		
		Попытка
			
			Блокировка.Заблокировать();
			
			СправочникСсылка = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(ПараметрыОбмена, ИмяТаблицы, Идентификатор);
			
			Если Не ЗначениеЗаполнено(СправочникСсылка) Тогда
				
				ДанныеОбъекта = ИнтеграцияСАТУРНСлужебный.ДанныеОбъекта(Идентификатор, Метаданные.Справочники.ПартииСАТУРН, ПараметрыОбмена);
				Если ДанныеОбъекта = Неопределено Тогда
					
					СправочникСсылка = СоздатьПартию(Идентификатор, ПараметрыОбмена);
					
					ВыполнятьЗагрузку = Истина;
					Если ЗначениеЗаполнено(ДатаКонтроля)
						И ЗначениеЗаполнено(ПараметрыОбмена.ПараметрыОптимизации.ДатаОграниченияГлубиныДереваПартий)
						И ДатаКонтроля < ПараметрыОбмена.ПараметрыОптимизации.ДатаОграниченияГлубиныДереваПартий Тогда
						ВыполнятьЗагрузку = Ложь;
					КонецЕсли;
					Если ВыполнятьЗагрузку
						И ПараметрыПолучения.ДобавлятьКЗагрузке Тогда
						ИнтеграцияСАТУРНСлужебный.ДобавитьКЗагрузке(
							ПараметрыОбмена,
							ИмяТаблицы,
							Идентификатор,
							СправочникСсылка,
							ОрганизацияСАТУРН);
					КонецЕсли;
					ПараметрыПолучения.НовыеОбъекты.Вставить(СправочникСсылка, ВыполнятьЗагрузку);
					
				Иначе
					СправочникСсылка = ЗагрузитьОбъект(ДанныеОбъекта, ПараметрыОбмена,, Ложь, ОрганизацияСАТУРН);
				КонецЕсли;
				
			КонецЕсли;
			
			ЗафиксироватьТранзакцию();
			
		Исключение
			
			ОтменитьТранзакцию();
			
			ТранзакцияЗафиксирована = Ложь;
			
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка при создании Партии САТУРН с идентификатором %1:
				           |%2'"),
				Идентификатор,
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ТекстОшибкиПодробно = СтрШаблон(
				НСтр("ru = 'Ошибка при создании Партии САТУРН с идентификатором %1:
				           |%2'"),
				Идентификатор,
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ИнтеграцияИСВызовСервера.ЗаписатьОшибкуВЖурналРегистрации(
				ТекстОшибкиПодробно,
				НСтр("ru = 'Работа с Партиями САТУРН'", ОбщегоНазначения.КодОсновногоЯзыка()));
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
		Если ТранзакцияЗафиксирована Тогда
			ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(ПараметрыОбмена, ИмяТаблицы, Идентификатор, СправочникСсылка);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СправочникСсылка;
	
КонецФункции

Функция ЗагрузитьОбъект(ДанныеПартии, ПараметрыОбмена, СправочникОбъект = Неопределено, ТребуетсяПоиск = Истина, ОрганизацияСАТУРН = Неопределено, ПараметрыПолученияПартии = Неопределено) Экспорт
	
	ЗаписьНового       = Ложь;
	МетаданныеЭлемента = Метаданные.Справочники.ПартииСАТУРН;
	
	Если ДанныеПартии = Неопределено Или Не ЗначениеЗаполнено(ДанныеПартии.Идентификатор) Тогда
		Возврат ПустаяСсылка();
	КонецЕсли;
	
	Если СправочникОбъект = Неопределено Тогда
		
		СуществующийЭлемент = Неопределено;
		Если ТребуетсяПоиск Тогда
			СуществующийЭлемент = ИнтеграцияСАТУРНСлужебный.СсылкаПоИдентификатору(
				ПараметрыОбмена,
				МетаданныеЭлемента.ПолноеИмя(),
				ДанныеПартии.Идентификатор);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СуществующийЭлемент) Тогда
			
			СправочникОбъект = СоздатьЭлемент();
			СправочникОбъект.Заполнить(Неопределено);
			ИдентификаторОбъекта = Новый УникальныйИдентификатор();
			СправочникСсылка = ПолучитьСсылку(ИдентификаторОбъекта);
			СправочникОбъект.УстановитьСсылкуНового(СправочникСсылка);
			
			СправочникОбъект.Идентификатор = ДанныеПартии.Идентификатор;
			
			ЗаписьНового = Истина;
			
		Иначе
			СправочникОбъект = СуществующийЭлемент.ПолучитьОбъект();
		КонецЕсли;
		
	КонецЕсли;
	
	Если Не ЗаписьНового Тогда
		СправочникОбъект.Заблокировать();
	КонецЕсли;
	
	СправочникОбъект.Наименование                = ДанныеПартии.Наименование;
	СправочникОбъект.Статус                      = ДанныеПартии.Статус;
	СправочникОбъект.ДатаПроизводства            = ДанныеПартии.ДатаПроизводства;
	СправочникОбъект.СрокГодности                = ДанныеПартии.СрокГодности;
	СправочникОбъект.ДатаСоздания                = ДанныеПартии.ДатаСоздания;
	СправочникОбъект.НомерПартии                 = ДанныеПартии.НомерПартии;
	
	Если ЗначениеЗаполнено(ДанныеПартии.ТипИзмеряемойВеличиныСАТУРН) Тогда
		СправочникОбъект.ТипИзмеряемойВеличиныСАТУРН = ДанныеПартии.ТипИзмеряемойВеличиныСАТУРН;
		СправочникОбъект.ТипИзмеряемойВеличиныУстановленПользователем = Ложь;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеПартии.ИдентификаторПАТ) Тогда
		
		ПАТ = Справочники.КлассификаторПАТСАТУРН.ПАТ(
			ДанныеПартии.ИдентификаторПАТ,
			ПараметрыОбмена,
			ОрганизацияСАТУРН);
			
		СправочникОбъект.ПАТ = ПАТ;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДанныеПартии.ИдентификаторРодительскойПартии) Тогда
		
		РодительскаяПартия = Партия(
			ДанныеПартии.ИдентификаторРодительскойПартии,
			ПараметрыОбмена,
			ОрганизацияСАТУРН,
			ПараметрыПолученияПартии,
			СправочникОбъект.ДатаСоздания);
			
		СправочникОбъект.РодительскаяПартия = РодительскаяПартия;
		
	КонецЕсли;
	
	СправочникОбъект.УпаковочнаяЕдиница = Справочники.КлючиЕдиницИзмеренияСАТУРН.КлючЕдиницы(
		ДанныеПартии.УпаковочнаяЕдиница.Идентификатор,
		ПараметрыОбмена,
		ДанныеПартии.УпаковочнаяЕдиница);
	
	СправочникОбъект.ТребуетсяЗагрузка = Ложь;
	СправочникОбъект.Записать();
	
	ИнтеграцияСАТУРНСлужебный.ОбновитьСсылку(
		ПараметрыОбмена,
		МетаданныеЭлемента.ПолноеИмя(),
		ДанныеПартии.Идентификатор,
		СправочникОбъект.Ссылка);
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

Функция СоздатьПартию(Идентификатор, ПараметрыОбмена)
	
	СправочникОбъект = СоздатьЭлемент();
	СправочникОбъект.Идентификатор     = Идентификатор;
	СправочникОбъект.ТребуетсяЗагрузка = Истина;
	СправочникОбъект.Наименование      = НСтр("ru = '<Требуется загрузка>'");
	
	СправочникОбъект.Записать();
	
	Возврат СправочникОбъект.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СоответствиеПартий

Функция ТекстЗапросаИерархииПартий()
	
	СписокЗапросов = Новый СписокЗначений;
	
	СписокЗапросов.Добавить("
		|ВЫБРАТЬ
		|	ИсходныеДанные.Партия              КАК Партия,
		|	ИсходныеДанные.ИдентификаторСтроки КАК ИдентификаторСтроки
		|ПОМЕСТИТЬ ВТИсходныеДанные
		|ИЗ
		|	&ИсходныеДанные КАК ИсходныеДанные
		|;
		|
		|ВЫБРАТЬ
		|	ИсходныеДанные.ИдентификаторСтроки        КАК ИдентификаторСтроки,
		|	ИсходныеДанные.Партия                     КАК ПартияУровень0,
		|	0                                         КАК КоличествоУровень0,
		|	ИсходныеДанные.Партия.РодительскаяПартия  КАК ПартияУровень1,
		|	0                                         КАК КоличествоУровень1
		|ПОМЕСТИТЬ ТаблицаПартийУровень1
		|ИЗ
		|	ВТИсходныеДанные КАК ИсходныеДанные
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ПартияУровень1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаПартийУровень1.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|	ТаблицаПартийУровень1.ПартияУровень0      КАК ПартияУровень0,
		|	ТаблицаПартийУровень1.КоличествоУровень0  КАК КоличествоУровень0,
		|	ТаблицаПартийУровень1.ПартияУровень1      КАК ПартияУровень1,
		|	ТаблицаПартийУровень1.КоличествоУровень1  КАК КоличествоУровень1,
		|	ПредшествующаяПартия.РодительскаяПартия   КАК ПартияУровень2,
		|	0                                         КАК КоличествоУровень2
		|ПОМЕСТИТЬ ТаблицаПартийУровень2
		|ИЗ
		|	ТаблицаПартийУровень1 КАК ТаблицаПартийУровень1
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииСАТУРН КАК ПредшествующаяПартия
		|		ПО ТаблицаПартийУровень1.ПартияУровень1 = ПредшествующаяПартия.Ссылка
		|		
		|ИНДЕКСИРОВАТЬ ПО
		|	ПартияУровень2
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ТаблицаПартийУровень2.ИдентификаторСтроки КАК ИдентификаторСтроки,
		|	ТаблицаПартийУровень2.ПартияУровень0      КАК ПартияУровень0,
		|	ТаблицаПартийУровень2.КоличествоУровень0  КАК КоличествоУровень0,
		|	ТаблицаПартийУровень2.ПартияУровень1      КАК ПартияУровень1,
		|	ТаблицаПартийУровень2.КоличествоУровень1  КАК КоличествоУровень1,
		|	ТаблицаПартийУровень2.ПартияУровень2      КАК ПартияУровень2,
		|	ТаблицаПартийУровень2.КоличествоУровень2  КАК КоличествоУровень2,
		|	ПредшествующаяПартия.РодительскаяПартия   КАК ПартияУровень3,
		|	0                                         КАК КоличествоУровень3
		|ПОМЕСТИТЬ ТаблицаПартийУровень3
		|ИЗ
		|	ТаблицаПартийУровень2 КАК ТаблицаПартийУровень2
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПартииСАТУРН КАК ПредшествующаяПартия
		|		ПО ТаблицаПартийУровень2.ПартияУровень2 = ПредшествующаяПартия.Ссылка
		|		
		|ИНДЕКСИРОВАТЬ ПО
		|	ПартияУровень3
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИсходныеДанные.ИдентификаторСтроки         КАК ИдентификаторСтроки,
		|	ИсходныеДанные.ПартияУровень0              КАК ПартияУровень0,
		|	ИсходныеДанные.КоличествоУровень0          КАК КоличествоУровень0,
		|	ИсходныеДанные.ПартияУровень1              КАК ПартияУровень1,
		|	ИсходныеДанные.КоличествоУровень1          КАК КоличествоУровень1,
		|	ИсходныеДанные.ПартияУровень2              КАК ПартияУровень2,
		|	ИсходныеДанные.КоличествоУровень2          КАК КоличествоУровень2,
		|	ИсходныеДанные.ПартияУровень3              КАК ПартияУровень3,
		|	ИсходныеДанные.КоличествоУровень3          КАК КоличествоУровень3
		|ПОМЕСТИТЬ ПолнаяТаблицаУровней
		|ИЗ
		|	ТаблицаПартийУровень3 КАК ИсходныеДанные
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПартийУровень3 КАК ТаблицаПартийУровень1
		|		ПО ИсходныеДанные.ПартияУровень0 = ТаблицаПартийУровень1.ПартияУровень1
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПартийУровень3 КАК ТаблицаПартийУровень2
		|		ПО ИсходныеДанные.ПартияУровень0 = ТаблицаПартийУровень2.ПартияУровень2
		|		ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаПартийУровень3 КАК ТаблицаПартийУровень3
		|		ПО ИсходныеДанные.ПартияУровень0 = ТаблицаПартийУровень3.ПартияУровень3
		|ГДЕ
		|	ТаблицаПартийУровень1.ПартияУровень0 ЕСТЬ NULL
		|	И ТаблицаПартийУровень2.ПартияУровень0 ЕСТЬ NULL
		|	И ТаблицаПартийУровень3.ПартияУровень0 ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПолнаяТаблицаУровней.ПартияУровень0 КАК Партия
		|ПОМЕСТИТЬ ВсеПартии
		|ИЗ
		|	ПолнаяТаблицаУровней КАК ПолнаяТаблицаУровней
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПолнаяТаблицаУровней.ПартияУровень1
		|ИЗ
		|	ПолнаяТаблицаУровней КАК ПолнаяТаблицаУровней
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПолнаяТаблицаУровней.ПартияУровень2
		|ИЗ
		|	ПолнаяТаблицаУровней КАК ПолнаяТаблицаУровней
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ПолнаяТаблицаУровней.ПартияУровень3
		|ИЗ
		|	ПолнаяТаблицаУровней КАК ПолнаяТаблицаУровней
		|");
	
	СписокЗапросов.Добавить("
		|ВЫБРАТЬ
		|	ПолнаяТаблицаУровней.ИдентификаторСтроки         КАК ИдентификаторСтроки,
		|	ПолнаяТаблицаУровней.ПартияУровень0              КАК ПартияУровень0,
		|	ПолнаяТаблицаУровней.КоличествоУровень0          КАК КоличествоУровень0,
		|	ПолнаяТаблицаУровней.ПартияУровень0.ДатаСоздания КАК ПартияУровень0Дата,
		|	ПолнаяТаблицаУровней.ПартияУровень0.ПАТ          КАК ПартияУровень0ПАТ,
		|	ПолнаяТаблицаУровней.ПартияУровень1              КАК ПартияУровень1,
		|	ПолнаяТаблицаУровней.КоличествоУровень1          КАК КоличествоУровень1,
		|	ПолнаяТаблицаУровней.ПартияУровень1.ДатаСоздания КАК ПартияУровень1Дата,
		|	ПолнаяТаблицаУровней.ПартияУровень1.ПАТ          КАК ПартияУровень1ПАТ,
		|	ПолнаяТаблицаУровней.ПартияУровень2              КАК ПартияУровень2,
		|	ПолнаяТаблицаУровней.КоличествоУровень2          КАК КоличествоУровень2,
		|	ПолнаяТаблицаУровней.ПартияУровень2.ДатаСоздания КАК ПартияУровень2Дата,
		|	ПолнаяТаблицаУровней.ПартияУровень2.ПАТ          КАК ПартияУровень2ПАТ,
		|	ПолнаяТаблицаУровней.ПартияУровень3              КАК ПартияУровень3,
		|	ПолнаяТаблицаУровней.КоличествоУровень3          КАК КоличествоУровень3,
		|	ПолнаяТаблицаУровней.ПартияУровень3.ДатаСоздания КАК ПартияУровень3Дата,
		|	ПолнаяТаблицаУровней.ПартияУровень3.ПАТ          КАК ПартияУровень3ПАТ
		|ИЗ
		|	ПолнаяТаблицаУровней КАК ПолнаяТаблицаУровней
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПартияУровень0,
		|	ПартияУровень1,
		|	ПартияУровень2,
		|	ПартияУровень3
		|",
		"ТаблицаУровней");
	
	СписокЗапросов.Добавить("
		|ВЫБРАТЬ
		|	СоответствиеПартийУровень.Партия,
		|	СоответствиеПартийУровень.Номенклатура,
		|	СоответствиеПартийУровень.Характеристика,
		|	СоответствиеПартийУровень.Серия,
		|	СоответствиеПартийУровень.СтатусУказанияСерий,
		|	СоответствиеПартийУровень.Порядок
		|ИЗ
		|	ВсеПартии КАК ВсеПартии
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.СоответствиеНоменклатурыСАТУРН КАК СоответствиеПартийУровень
		|		ПО СоответствиеПартийУровень.Партия = ВсеПартии.Партия
		|ГДЕ
		|	НЕ СоответствиеПартийУровень.Партия В (&ДобавленныеПартии)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СоответствиеПартийУровень.Порядок Убыв
		|",
		"СоответствиеПартий");
	
	СписокЗапросов.Добавить("
		|УНИЧТОЖИТЬ ВТИсходныеДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ТаблицаПартийУровень1
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ТаблицаПартийУровень2
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ТаблицаПартийУровень3
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ПолнаяТаблицаУровней
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|УНИЧТОЖИТЬ ВсеПартии
		|");
	
	Возврат СписокЗапросов;
	
КонецФункции

Функция ПараметрыПостроенияДереваПартий() Экспорт
	
	ВозвращаемоеЗначение = Новый Структура();
	ВозвращаемоеЗначение.Вставить("ИсходныеПартии",         Новый Массив());
	ВозвращаемоеЗначение.Вставить("ТаблицаСопоставлений",   РегистрыСведений.СоответствиеНоменклатурыСАТУРН.СоздатьНаборЗаписей().Выгрузить());
	ВозвращаемоеЗначение.Вставить("ДоПервогоСопоставления", Ложь);
	ВозвращаемоеЗначение.Вставить("ДатаОграниченияГлубины", Дата(1, 1, 1));
	
	ВозвращаемоеЗначение.ТаблицаСопоставлений.Индексы.Добавить("Партия");
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

Функция ДеревоПартий(ПараметрыПостроения) Экспорт
	
	СтруктураПоискаСопоставления = Новый Структура("Партия");
	
	ДеревоПартий = Новый ДеревоЗначений();
	ДеревоПартий.Колонки.Добавить("Партия",                  Новый ОписаниеТипов("СправочникСсылка.ПартииСАТУРН"));
	ДеревоПартий.Колонки.Добавить("ПАТ",                     Новый ОписаниеТипов("СправочникСсылка.КлассификаторПАТСАТУРН"));
	ДеревоПартий.Колонки.Добавить("Количество",              ОбщегоНазначения.ОписаниеТипаЧисло(15, 3));
	ДеревоПартий.Колонки.Добавить("Номенклатура",            Метаданные.ОпределяемыеТипы.Номенклатура.Тип);
	ДеревоПартий.Колонки.Добавить("Характеристика",          Метаданные.ОпределяемыеТипы.ХарактеристикаНоменклатуры.Тип);
	ДеревоПартий.Колонки.Добавить("Серия",                   Метаданные.ОпределяемыеТипы.СерияНоменклатуры.Тип);
	ДеревоПартий.Колонки.Добавить("СтатусУказанияСерий",     ОбщегоНазначения.ОписаниеТипаЧисло(10));
	ДеревоПартий.Колонки.Добавить("КоличествоСопоставлений", ОбщегоНазначения.ОписаниеТипаЧисло(15));
	ДеревоПартий.Колонки.Добавить("Сопоставления",           Новый ОписаниеТипов("ТаблицаЗначений"));
	
	ДобавленныеПартии = Новый Массив();
	ИсходныеДанные = Новый ТаблицаЗначений();
	ИсходныеДанные.Колонки.Добавить("Партия",              ДеревоПартий.Колонки.Партия.ТипЗначения);
	ИсходныеДанные.Колонки.Добавить("ИдентификаторСтроки", ОбщегоНазначения.ОписаниеТипаСтрока(1024));
	
	Для Каждого Партия Из ОбщегоНазначенияКлиентСервер.СвернутьМассив(ПараметрыПостроения.ИсходныеПартии) Цикл
		НоваяСтрока = ИсходныеДанные.Добавить();
		НоваяСтрока.Партия = Партия;
	КонецЦикла;
	
	Запрос = Новый Запрос;
	СписокЗапросов = ТекстЗапросаИерархииПартий();
	
	СтрокиДереваПоХэшам = Новый Соответствие;
	КэшИдентификаторов  = Новый Соответствие();
	ПродолжатьПоиск     = Истина;
	УровнейВложенности  = 3;
	Пока ПродолжатьПоиск Цикл
		
		Запрос.УстановитьПараметр("ИсходныеДанные",    ИсходныеДанные);
		Запрос.УстановитьПараметр("ДобавленныеПартии", ДобавленныеПартии);
		РезультатЗапроса = ИнтеграцияИС.ВыполнитьПакетЗапросов(Запрос, СписокЗапросов);
	
		//@skip-warning
		ВыборкаТаблицаУровней = РезультатЗапроса["ТаблицаУровней"].Выбрать();
		
		//@skip-warning
		ВыборкаСоответствиеПартий = РезультатЗапроса["СоответствиеПартий"].Выбрать();
		
		Пока ВыборкаСоответствиеПартий.Следующий() Цикл
			ДобавленныеПартии.Добавить(ВыборкаСоответствиеПартий.Партия);
			НоваяСтрока = ПараметрыПостроения.ТаблицаСопоставлений.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаСоответствиеПартий);
		КонецЦикла;
		
		ИсходныеДанные.Очистить();
		
		Пока ВыборкаТаблицаУровней.Следующий() Цикл
			
			Для ТекущийУровень = 0 По УровнейВложенности Цикл
				
				ТекущаяПартия     = ВыборкаТаблицаУровней["ПартияУровень"     + ТекущийУровень];
				ТекущаяДатаПартии = ВыборкаТаблицаУровней["ПартияУровень"     + ТекущийУровень + "Дата"];
				ТекущаяПартияПАТ  = ВыборкаТаблицаУровней["ПартияУровень"     + ТекущийУровень + "ПАТ"];
				ТекущееКоличество = ВыборкаТаблицаУровней["КоличествоУровень" + ТекущийУровень];
				
				Если Не ЗначениеЗаполнено(ТекущаяПартия)
					Или (ЗначениеЗаполнено(ТекущаяДатаПартии)
						И ТекущаяДатаПартии < ПараметрыПостроения.ДатаОграниченияГлубины) Тогда
					Прервать;
				КонецЕсли;
				
				Если ТекущийУровень = 0
					И ЗначениеЗаполнено(ВыборкаТаблицаУровней.ИдентификаторСтроки) Тогда // Это продолжение поиска
					ХэшСуммаРодителя = ХэшСуммаИерархии(ВыборкаТаблицаУровней, ТекущийУровень, КэшИдентификаторов);
					СтрокиДереваПоХэшам[ХэшСуммаРодителя] = СтрокиДереваПоХэшам[ВыборкаТаблицаУровней.ИдентификаторСтроки];
					Продолжить;
				КонецЕсли;
				
				ХэшСуммаУровня = ХэшСуммаИерархии(ВыборкаТаблицаУровней, ТекущийУровень, КэшИдентификаторов);
				УзелУровня     = СтрокиДереваПоХэшам[ХэшСуммаУровня];
				Если УзелУровня <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				ХэшСуммаРодителя = ХэшСуммаИерархии(ВыборкаТаблицаУровней, ТекущийУровень - 1, КэшИдентификаторов);
				РодительскийУзел = СтрокиДереваПоХэшам[ХэшСуммаРодителя];
				Если РодительскийУзел = Неопределено Тогда
					РодительскийУзел = ДеревоПартий;
					СтрокиДереваПоХэшам[ХэшСуммаРодителя] = РодительскийУзел;
				КонецЕсли;
				
				СтруктураПоискаСопоставления.Партия = ТекущаяПартия;
				СтрокиСопоставления                       = ПараметрыПостроения.ТаблицаСопоставлений.Скопировать(СтруктураПоискаСопоставления);
				
				НоваяСтрока = РодительскийУзел.Строки.Добавить();
				НоваяСтрока.Партия                  = ТекущаяПартия;
				НоваяСтрока.ПАТ                     = ТекущаяПартияПАТ;
				НоваяСтрока.Количество              = ТекущееКоличество;
				НоваяСтрока.Сопоставления           = СтрокиСопоставления;
				НоваяСтрока.КоличествоСопоставлений = СтрокиСопоставления.Количество();
				
				СтрокиДереваПоХэшам[ХэшСуммаУровня] = НоваяСтрока;
				
				Если ПараметрыПостроения.ДоПервогоСопоставления
					И НоваяСтрока.КоличествоСопоставлений > 0 Тогда
					Прервать;
				КонецЕсли;
				
				Если ТекущийУровень = УровнейВложенности
					И (Не ПараметрыПостроения.ДоПервогоСопоставления
						Или ПараметрыПостроения.ДоПервогоСопоставления И НоваяСтрока.КоличествоСопоставлений = 0) Тогда
					НоваяСтрокаИсходныеДанные = ИсходныеДанные.Добавить();
					НоваяСтрокаИсходныеДанные.Партия              = ТекущаяПартия;
					НоваяСтрокаИсходныеДанные.ИдентификаторСтроки = ХэшСуммаУровня;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЦикла;
		
		ПродолжатьПоиск = ИсходныеДанные.Количество() > 0;
		
	КонецЦикла;
	
	Возврат ДеревоПартий;
	
КонецФункции

Функция ХэшСуммаИерархии(СтрокаДанных, УровеньРасчета, КэшИдентификаторов)
	
	ДанныеХэшСуммы = Новый Массив();
	ДанныеХэшСуммы.Добавить(СтрокаДанных.ИдентификаторСтроки);
	
	Для ТекущийУровень = 0 По УровеньРасчета Цикл
		
		ТекущаяПартия = СтрокаДанных["ПартияУровень" + ТекущийУровень];
		
		УникальныйИдентификатор = КэшИдентификаторов[ТекущаяПартия];
		Если УникальныйИдентификатор = Неопределено Тогда
			УникальныйИдентификатор = Строка(ТекущаяПартия.УникальныйИдентификатор());
			КэшИдентификаторов[ТекущаяПартия] = УникальныйИдентификатор;
		КонецЕсли;
		
		ДанныеХэшСуммы.Добавить(УникальныйИдентификатор);
		
	КонецЦикла;
	
	ХэшСуммаРодительскойСтроки = ИнтеграцияИС.ХэшСуммаСтроки(СтрСоединить(ДанныеХэшСуммы, "|"));
	
	Возврат ХэшСуммаРодительскойСтроки;
	
КонецФункции

Функция ЗаписатьСоответствиеПартийНоменклатуреПоРодительскимПартиям(Партии) Экспорт
	
	ЗаписатьСоответствие = Новый Массив();
	
	Если Партии.Количество() = 0 Тогда
		Возврат ЗаписатьСоответствие;
	КонецЕсли;
	
	ПараметрыПостроения = ПараметрыПостроенияДереваПартий();
	ПараметрыПостроения.ИсходныеПартии         = Партии;
	ПараметрыПостроения.ДоПервогоСопоставления = Истина;
	ПараметрыПостроения.ДатаОграниченияГлубины = ИнтеграцияСАТУРНСлужебный.ПараметрыОптимизации().ДатаОграниченияГлубиныДереваПартий;
	
	ДеревоПартий = ДеревоПартий(ПараметрыПостроения);
	
	Для Каждого СтрокаДерева Из ДеревоПартий.Строки Цикл
		РассчитатьСоответствеПоДеревуПартийРекурсивно(СтрокаДерева, ЗаписатьСоответствие);
	КонецЦикла;
	
	Если ЗаписатьСоответствие.Количество() Тогда
		
		ТаблицаБлокировки = Новый ТаблицаЗначений();
		ТаблицаБлокировки.Колонки.Добавить("Партия", Новый ОписаниеТипов("СправочникСсылка.ПартииСАТУРН"));
		Для Каждого СтрокаДерева Из ЗаписатьСоответствие Цикл
			НоваяСтрока = ТаблицаБлокировки.Добавить();
			НоваяСтрока.Партия = СтрокаДерева.Партия;
		КонецЦикла;
		
		Блокировка = Новый БлокировкаДанных();
		
		ЭлементБлокировки = Блокировка.Добавить(Метаданные.РегистрыСведений.СоответствиеНоменклатурыСАТУРН.ПолноеИмя());
		ЭлементБлокировки.ИсточникДанных = ТаблицаБлокировки;
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Партия", "Партия");
		
		Попытка
			
			Блокировка.Заблокировать();
			
			Для Каждого СтрокаДерева Из ЗаписатьСоответствие Цикл
				
				НаборЗаписей = РегистрыСведений.СоответствиеНоменклатурыСАТУРН.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Партия.Установить(СтрокаДерева.Партия);
				
				Для Каждого СтрокаСопоставления Из СтрокаДерева.Сопоставления Цикл
					НоваяСтрока = НаборЗаписей.Добавить();
					ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСопоставления);
					НоваяСтрока.Партия = СтрокаДерева.Партия;
					НоваяСтрока.ПАТ          = СтрокаДерева.ПАТ;
				КонецЦикла;
				
				НаборЗаписей.Записать();
				
			КонецЦикла;
			
		Исключение
			
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ТекстОшибки = СтрШаблон(
				НСтр("ru = 'Ошибка записи соответствия партий:
					       |%1'"),
				ОбработкаОшибок.КраткоеПредставлениеОшибки(ИнформацияОбОшибке));
			ТекстОшибкиПодбробно = СтрШаблон(
				НСтр("ru = 'Ошибка записи соответствия партий:
					       |%1'"),
				ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));
			
			ИнтеграцияСАТУРНСлужебный.ЗаписатьОшибкуВЖурналРегистрации(ТекстОшибкиПодбробно);
			
			ВызватьИсключение ТекстОшибки;
			
		КонецПопытки;
		
	КонецЕсли;
	
	Возврат ЗаписатьСоответствие;
	
КонецФункции

Процедура РассчитатьСоответствеПоДеревуПартийРекурсивно(УзелДерева, ЗаписатьСоответствие)
	
	ИменаКлючейПоиска = "Номенклатура,Характеристика,Серия";
	УзелДерева.Сопоставления.Индексы.Добавить(ИменаКлючейПоиска);
	
	ЭтоКонечныйУзел = (УзелДерева.Сопоставления.Количество() > 0);
	Для Каждого СтрокаДерева Из УзелДерева.Строки Цикл
		
		РассчитатьСоответствеПоДеревуПартийРекурсивно(СтрокаДерева, ЗаписатьСоответствие);
		
		Для Каждого СтрокаСопоставления Из СтрокаДерева.Сопоставления Цикл
			СтруктураПоиска = Новый Структура(ИменаКлючейПоиска);
			ЗаполнитьЗначенияСвойств(СтруктураПоиска, СтрокаСопоставления);
			ПоискСтрок = УзелДерева.Сопоставления.НайтиСтроки(СтруктураПоиска);
			Если ПоискСтрок.Количество() = 0 Тогда
				НоваяСтрока = УзелДерева.Сопоставления.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаСопоставления);
			КонецЕсли;
		КонецЦикла;
		
	КонецЦикла;
	
	УзелДерева.КоличествоСопоставлений = УзелДерева.Сопоставления.Количество();
	
	Если ЭтоКонечныйУзел Тогда
		Возврат;
	ИначеЕсли УзелДерева.КоличествоСопоставлений > 1 Тогда
		
		ИменаКлючейПоиска = "Номенклатура,Характеристика";
		УзелДерева.Сопоставления.Индексы.Добавить(ИменаКлючейПоиска);
		
		СтруктураПоиска = Новый Структура(ИменаКлючейПоиска);
		ЗаполнитьЗначенияСвойств(СтруктураПоиска, УзелДерева.Сопоставления[0]);
		ПоискСтрок = УзелДерева.Сопоставления.НайтиСтроки(СтруктураПоиска);
		
		Если ПоискСтрок.Количество() = УзелДерева.Сопоставления.Количество() Тогда
			УзелДерева.Сопоставления.Очистить();
			НоваяСтрока = УзелДерева.Сопоставления.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтруктураПоиска);
			УзелДерева.КоличествоСопоставлений = УзелДерева.Сопоставления.Количество();
		КонецЕсли;
		
	КонецЕсли;
	
	Если УзелДерева.КоличествоСопоставлений = 1 Тогда
		ЗаписатьСоответствие.Добавить(УзелДерева);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

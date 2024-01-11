#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает структуру состояния настроек интеграции Объекта.
//
// Параметры:
//  Объект - Ссылка - Объект, для которого нужно получить состояние.
// 
// Возвращаемое значение:
//   - Структура, Неопределено - 
//         * Состояние - ПеречислениеСсылка.СостоянияОбъектовИнтеграцииCRM - состояние интеграции.
//         * Идентификатор - Строка (50) - Идентификатор объекта.
//         * НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграцииCRM - Ссылка на настройки интеграции CRM.
//         * ТекстОшибки - Строка - Текст ошибки, присланный CRM.
//
Функция СостояниеИнтеграцииОбъекта(Ссылка, УчетнаяСистема) Экспорт
	
	Если Не ЗначениеЗаполнено(Ссылка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОбъектыИнтеграцииCRM.Состояние КАК Состояние,
	|	ОбъектыИнтеграцииCRM.Идентификатор КАК Идентификатор,
	|	ОбъектыИнтеграцииCRM.НастройкаИнтеграции КАК НастройкаИнтеграции,
	|	ОбъектыИнтеграцииCRM.ТекстОшибки КАК ТекстОшибки
	|ИЗ
	|	РегистрСведений.ОбъектыИнтеграцииCRM КАК ОбъектыИнтеграцииCRM
	|ГДЕ
	|	ОбъектыИнтеграцииCRM.Объект = &Объект
	|	И ОбъектыИнтеграцииCRM.НастройкаИнтеграции = &НастройкаИнтеграции";
	
	Запрос.УстановитьПараметр("Объект", Ссылка);
	Запрос.УстановитьПараметр("НастройкаИнтеграции", УчетнаяСистема);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	СостояниеИнтеграции = НовыйСостояниеИнтеграции();
	ЗаполнитьЗначенияСвойств(СостояниеИнтеграции, Выборка);
	
	Возврат СостояниеИнтеграции;
	
КонецФункции

// Возвращает объект по идентификатору
// 
// Параметры:
//  Идентификатор - Строка (50) - Идентификатор объекта из внешней системы.
// 
// Возвращаемое значение:
//   - Ссылка - Объект, соответствующий идентификатору в ИБ.
//
Функция ОбъектПоИдентификатору(Идентификатор) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОбъектыИнтеграцииCRM.Объект КАК Объект
	|ИЗ
	|	РегистрСведений.ОбъектыИнтеграцииCRM КАК ОбъектыИнтеграцииCRM
	|ГДЕ
	|	ОбъектыИнтеграцииCRM.Идентификатор = &Идентификатор";
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Объект;
	
КонецФункции

// Устанавливает для объекта интеграции состояние: Синхронизировано.
//
// Параметры:
//  Объект            - Ссылка - Объект, который приняли из CRM.
//  НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграцииCRM - Настройка интеграции, к которой относится объект.
//  Идентификатор       - Строка - Идентификатор объекта, для которого нужно установить состояние.
//
Процедура УстановитьСостояниеОбъектСинхронизировано(Объект, НастройкаИнтеграции, Идентификатор) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Объект) ИЛИ НЕ ЗначениеЗаполнено(НастройкаИнтеграции) Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеИнтеграции = НовыйСостояниеИнтеграции();
	СостояниеИнтеграции.НастройкаИнтеграции = НастройкаИнтеграции;
	СостояниеИнтеграции.Идентификатор = Идентификатор;
	СостояниеИнтеграции.Состояние = Перечисления.СостоянияОбъектовИнтеграцииCRM.Синхронизировано;
	
	ЗаписатьСостояниеИнтеграцииCRM(Объект, СостояниеИнтеграции);
	
	ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Информация, Объект.Метаданные(), Объект, НСтр("ru = 'Объект синхронизирован с CRM системой'"));
	
КонецПроцедуры

// Устанавливает для объекта интеграции состояние: ошибка передачи.
//
// Параметры:
//  Объект    - Ссылка - Объект, для которого нужно установить состояние.
//  ТекстОшибки - Строка - Текст ошибки передачи в банк. Формируется CRM.
//
Процедура УстановитьСостояниеОшибкаПередачи(Объект, НастройкаИнтеграции, ТекстОшибки) Экспорт
	
	СостояниеИнтеграции = СостояниеИнтеграцииОбъекта(Объект, НастройкаИнтеграции);
	
	Если СостояниеИнтеграции = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СостояниеИнтеграции.Состояние   = Перечисления.СостоянияОбъектовИнтеграцииCRM.ОшибкаПриОтправке;
	СостояниеИнтеграции.ТекстОшибки = ТекстОшибки;
	
	ЗаписатьСостояниеИнтеграцииCRM(Объект, СостояниеИнтеграции);
	
	ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
		УровеньЖурналаРегистрации.Ошибка, Объект.Метаданные(), Объект, ТекстОшибки);
	
КонецПроцедуры

#Область Отправка

// Формирует хеш объекта до момента записи для дальнейшего сравнения.
// Вызывается в обработчике ПередЗаписью.
//
// Параметры:
//  Объект - ОпределяемыйТип.ОбъектыСинхронизацииCRM - Изменяемый объект.
//
Процедура ПередЗаписьюОбъекта(Объект) Экспорт
	
	Если НЕ ИнтеграцияCRMПовтИсп.ИнтеграцияВИнформационнойБазеВключена() Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ОбъектСинхронизируетсяCRM(Объект.Ссылка) Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДополнительныеСвойства.Вставить("ИнтеграцияCRM", Новый Структура);
	Объект.ДополнительныеСвойства.ИнтеграцияCRM.Вставить("ХешОбъектаДоЗаписи", ХешОбъекта(Объект.Ссылка.ПолучитьОбъект()));
	
КонецПроцедуры

// Определяет наличие изменений в объекте и регистрирует объект к отправке во внешнюю систему.
// Вызывается в обработчике ПриЗаписи.
//
// Параметры:
//  Объект - ОпределяемыйТип.ОбъектыСинхронизацииCRM - Изменяемый объект.
//
Процедура ПриЗаписиОбъекта(Объект) Экспорт
	
	Если НЕ Объект.ДополнительныеСвойства.Свойство("ИнтеграцияCRM") Тогда
		Возврат;
	КонецЕсли;
	
	МетаданныеОбъекта = Объект.Ссылка.Метаданные();
	
	НужноОтправить = ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) И Объект.Проведен ИЛИ ОбщегоНазначения.ЭтоСправочник(МетаданныеОбъекта);
	НужноОтменитьОтправку = ОбщегоНазначения.ЭтоДокумент(МетаданныеОбъекта) И НЕ Объект.Проведен;
	
	Если НужноОтправить Тогда
		ХешОбъектаДоЗаписи    = Объект.ДополнительныеСвойства.ИнтеграцияCRM.ХешОбъектаДоЗаписи;
		ХешОбъектаПослеЗаписи = ХешОбъекта(Объект);
		НужноОтправить = ХешОбъектаПослеЗаписи <> ХешОбъектаДоЗаписи;
	КонецЕсли;
	
	Если НужноОтправить Тогда
		ВыполнитьРегистрациюКОтправке(Объект.Ссылка);
	КонецЕсли;
	
	Если НужноОтменитьОтправку Тогда
		ОтменитьОтправкуОбъекта(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

// Формирует данные для отправки и посылает оповещение во внешнюю систему.
//
// Параметры:
//  ОбъектыДляОповещения - ОпределяемыйТип.ОбъектыСинхронизацииCRM, Массив - Измененный объект.
//
Процедура ПослеЗаписиОбъекта(ОбъектыДляОповещения) Экспорт
	
	Если НЕ ИнтеграцияCRMПовтИсп.ИнтеграцияВИнформационнойБазеВключена() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ОбъектыДляОповещения) = Тип("Массив") Тогда
		МассивОбъектовДляОповещения = ОбъектыДляОповещения;
	Иначе
		МассивОбъектовДляОповещения = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(ОбъектыДляОповещения);
	КонецЕсли;
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ОбъектыДляОповещения", МассивОбъектовДляОповещения);
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(Новый УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0;
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Отправка оповещения по измененным объектам в CRM.'");
	
	ДлительныеОперации.ВыполнитьВФоне(
		"РегистрыСведений.ОбъектыИнтеграцииCRM.ЗаполнитьДвоичныеДанныеИОповеститьОбИзменениях",
		ПараметрыПроцедуры,
		ПараметрыВыполнения);
	
КонецПроцедуры

Функция ДвоичныеДанныеОбъектаДляОтправки(Объект, НастройкаИнтеграции, Обработчик) Экспорт
	
	Если Обработчик = ОбработчикДанныхEnterpriseData() Тогда
		Возврат ДвоичныеДанныеДляОтправкиEnterpriseData(Объект, НастройкаИнтеграции);
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#Область Загрузка

// Возвращает структуру состояния настроек интеграции по идентификатору.
//
// Параметры:
//  Идентификатор - Строка (50) - Идентификатор объекта из внешней системы.
// 
// Возвращаемое значение:
//   - Структура, Неопределено - 
//         * Объект - Ссылка - Объект, соответствующий идентификатору в ИБ.
//         * Состояние - ПеречислениеСсылка.СостоянияОбъектовИнтеграцииCRM - состояние интеграции.
//         * НастройкаИнтеграции - СправочникСсылка.НастройкиИнтеграцииCRM - Ссылка на настройки интеграции CRM.
//         * ТекстОшибки - Строка - Текст ошибки, присланный CRM.
//
Функция СостояниеИнтеграцииПоИдентификатору(Идентификатор)
	
	Если Не ЗначениеЗаполнено(Идентификатор) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ОбъектыИнтеграцииCRM.Состояние КАК Состояние,
	|	ОбъектыИнтеграцииCRM.Объект КАК Объект,
	|	ОбъектыИнтеграцииCRM.НастройкаИнтеграции КАК НастройкаИнтеграции,
	|	ОбъектыИнтеграцииCRM.ТекстОшибки КАК ТекстОшибки
	|ИЗ
	|	РегистрСведений.ОбъектыИнтеграцииCRM КАК ОбъектыИнтеграцииCRM
	|ГДЕ
	|	ОбъектыИнтеграцииCRM.Идентификатор = &Идентификатор";
	РезультатЗапроса = Запрос.Выполнить();
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	СостояниеИнтеграции = НовыйСостояниеИнтеграции();
	ЗаполнитьЗначенияСвойств(СостояниеИнтеграции, Выборка);
	
	Возврат СостояниеИнтеграции;
	
КонецФункции

Процедура ОбработатьДанные(УчетнаяСистема, ИдентификаторОбъекта, ПотокДанных, Обработчик, КодВозврата, Ошибка, СообщениеОбОшибке) Экспорт
	
	Если НРег(Обработчик) = ОбработчикДанныхEnterpriseData() Тогда
		
		СостояниеИнтеграции = СостояниеИнтеграцииПоИдентификатору(ИдентификаторОбъекта);
		Если СостояниеИнтеграции <> Неопределено
			И СостояниеИнтеграции.Состояние = Перечисления.СостоянияОбъектовИнтеграцииCRM.ПодготовленоКОтправке Тогда
			Ошибка = Истина;
			СообщениеОбОшибке = СтрШаблон(НСтр("ru='Для объекта с идентификатором %1 зарегистрированы изменения.
				|Сначала следует подтвердить получение изменений в CRM'"), ИдентификаторОбъекта);
		Иначе
			ЗагруженныеОбъекты = ЗагрузитьСообщениеEnterpriseData(ПотокДанных, Ошибка, СообщениеОбОшибке);
			ЗаписатьИдентификаторЗагруженногоОбъекта(ЗагруженныеОбъекты, УчетнаяСистема, ИдентификаторОбъекта);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Ошибка Тогда
		КодВозврата = ИнтеграцияОбъектовОбластейДанныхСловарь.КодВозвратаОшибкаДанных();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВыполнениеКоманд

// Регистрирует всю имеющуюся номенклатуру в отправке во внешнюю систему.
// См. Справочники.НастройкиИнтеграцииCRM.ВыполнитьКоманду()
//
// Параметры:
//  УчетнаяСистема - СправочникСсылка.НастройкиИнтеграцииCRM
//
Процедура ДобавитьНоменклатуруКОтправке(УчетнаяСистема) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Номенклатура.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Номенклатура КАК Номенклатура
	|ГДЕ
	|	Номенклатура.ЭтоГруппа = ЛОЖЬ";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СостояниеИнтеграции = СостояниеИнтеграцииОбъекта(Выборка.Ссылка, УчетнаяСистема);
		Если СостояниеИнтеграции = Неопределено Тогда
			СостояниеИнтеграции = НовыйСостояниеИнтеграции();
			СостояниеИнтеграции.НастройкаИнтеграции = УчетнаяСистема;
		КонецЕсли;
		СостояниеИнтеграции.Состояние = Перечисления.СостоянияОбъектовИнтеграцииCRM.ПодготовленоКОтправке;
		
		ЗаписатьСостояниеИнтеграцииCRM(Выборка.Ссылка, СостояниеИнтеграции);
		ИнтеграцияОбъектовОбластейДанных.ДобавитьОбъектКОтправке(
			УчетнаяСистема,
			СостояниеИнтеграции.Идентификатор,
			ОбработчикДанныхEnterpriseData());
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаписатьСостояниеИнтеграцииCRM(Объект, СостояниеИнтеграции)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Набор = РегистрыСведений.ОбъектыИнтеграцииCRM.СоздатьНаборЗаписей();
	Набор.Отбор.НастройкаИнтеграции.Установить(СостояниеИнтеграции.НастройкаИнтеграции);
	Набор.Отбор.Объект.Установить(Объект);
	
	Запись = Набор.Добавить();
	ЗаполнитьЗначенияСвойств(Запись, СостояниеИнтеграции);
	Запись.Объект = Объект;
	Запись.Дата   = ТекущаяДатаСеанса();
	
	Набор.Записать();
	
КонецПроцедуры

Процедура ЗаполнитьДвоичныеДанныеИОповеститьОбИзменениях(ПараметрыЗадания, АдресХранилища) Экспорт
	
	ОбъектыДляОповещения = ПараметрыЗадания.ОбъектыДляОповещения;
	Для Каждого ОбъектДляОповещения Из ОбъектыДляОповещения Цикл
		
		УчетныеСистемыОбъекта = УчетныеСистемыДляСинхронизацииОбъекта(ОбъектДляОповещения);
		Для каждого УчетнаяСистема Из УчетныеСистемыОбъекта Цикл
			
			СостояниеИнтеграции = СостояниеИнтеграцииОбъекта(ОбъектДляОповещения, УчетнаяСистема);
			Если СостояниеИнтеграции = Неопределено Тогда
				СостояниеИнтеграции = НовыйСостояниеИнтеграции();
				СостояниеИнтеграции.НастройкаИнтеграции = УчетнаяСистема;
			КонецЕсли;
			
			СостояниеИнтеграции.Состояние = Перечисления.СостоянияОбъектовИнтеграцииCRM.ПодготовленоКОтправке;
			
			Обработчик = ОбработчикДанныхEnterpriseData();
			
			ДвоичныеДанныеОбъектаДляОтправки = ДвоичныеДанныеОбъектаДляОтправки(
				ОбъектДляОповещения,
				СостояниеИнтеграции.НастройкаИнтеграции,
				Обработчик);
				
			ИнтеграцияОбъектовОбластейДанных.ДобавитьОбъектКОтправке(
				СостояниеИнтеграции.НастройкаИнтеграции,
				СостояниеИнтеграции.Идентификатор,
				Обработчик,
				ДвоичныеДанныеОбъектаДляОтправки);
			
			ИнтеграцияОбъектовОбластейДанных.ОповеститьОбИзмененииОбъекта(
				СостояниеИнтеграции.НастройкаИнтеграции, СостояниеИнтеграции.Идентификатор);
				
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

Функция НовыйСостояниеИнтеграции()
	
	СостояниеИнтеграции = Новый Структура;
	СостояниеИнтеграции.Вставить("Идентификатор",       Строка(Новый УникальныйИдентификатор()));
	СостояниеИнтеграции.Вставить("НастройкаИнтеграции", Справочники.НастройкиИнтеграцииCRM.ПустаяСсылка());
	СостояниеИнтеграции.Вставить("Состояние",           Перечисления.СостоянияОбъектовИнтеграцииCRM.ПустаяСсылка());
	СостояниеИнтеграции.Вставить("ТекстОшибки",         "");
	
	Возврат СостояниеИнтеграции;
	
КонецФункции

Функция ТипОбъектаСинхронизируетсяCRM(ОбъектСсылка)
	
	Возврат Метаданные.ОпределяемыеТипы.ОбъектыСинхронизацииCRM.Тип.СодержитТип(ТипЗнч(ОбъектСсылка));
	
КонецФункции

Функция ОбъектСинхронизируетсяCRM(ОбъектСсылка)
	
	Возврат УчетныеСистемыДляСинхронизацииОбъекта(ОбъектСсылка).Количество() <> 0; 
	
КонецФункции

Функция УчетныеСистемыДляСинхронизацииОбъекта(ОбъектСсылка)
	
	МетаданныеОбъекта = ОбъектСсылка.Метаданные();
	
	ДвусторонняяСинхронизацияОбъектов = Новый Массив;
	ДвусторонняяСинхронизацияОбъектов.Добавить(Метаданные.Справочники.Номенклатура);
	ДвусторонняяСинхронизацияОбъектов.Добавить(Метаданные.Справочники.ХарактеристикиНоменклатуры);
	
	Если ДвусторонняяСинхронизацияОбъектов.Найти(МетаданныеОбъекта) <> Неопределено Тогда
		Возврат СписокВсехУчетныхСистем();
	КонецЕсли;
	
	ОдносторонняяСинхронизацияОбъектов = Новый Массив;
	ОдносторонняяСинхронизацияОбъектов.Добавить(Метаданные.Документы.ЗаказПокупателя);
	
	Если ОдносторонняяСинхронизацияОбъектов.Найти(МетаданныеОбъекта) = Неопределено Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ОбъектыИнтеграцииCRM.НастройкаИнтеграции КАК НастройкаИнтеграции
	|ИЗ
	|	РегистрСведений.ОбъектыИнтеграцииCRM КАК ОбъектыИнтеграцииCRM
	|ГДЕ
	|	ОбъектыИнтеграцииCRM.Объект = &ОбъектСсылка";
	Запрос.УстановитьПараметр("ОбъектСсылка", ОбъектСсылка);
	
	УчетныеСистемыДляСинхронизацииОбъекта = Новый Массив;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		УчетныеСистемыДляСинхронизацииОбъекта.Добавить(Выборка.НастройкаИнтеграции);
	КонецЦикла;
	
	Возврат УчетныеСистемыДляСинхронизацииОбъекта;
	
КонецФункции

Функция СписокВсехУчетныхСистем()
	
	СписокУчетныхСистем = Новый Массив;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НастройкиИнтеграцииCRM.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.НастройкиИнтеграцииCRM КАК НастройкиИнтеграцииCRM";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СписокУчетныхСистем.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Возврат СписокУчетныхСистем;
	
КонецФункции

Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Интеграция с CRM'", ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

Функция ДанныеОплатыЗаказа(Заказ)
	
	НаборЗаписей = РегистрыСведений.ФактОплатыЗаказов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.СчетНаОплату.Установить(Заказ);
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей;
	
КонецФункции

Функция ДанныеОтгрузкиЗаказа(Заказ)
	
	НаборЗаписей = РегистрыСведений.ГрафикВыполненияЗаказов.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Заказ.Установить(Заказ);
	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей;
	
КонецФункции

#Область СлужебныеПроцедурыИФункцииОтправки

Процедура ВыполнитьРегистрациюКОтправке(Объект, Знач СостояниеИнтеграции = Неопределено)
	
	СостоянияИнтеграции = Новый Массив;
	
	Если СостояниеИнтеграции <> Неопределено Тогда
		СостоянияИнтеграции.Добавить(СостояниеИнтеграции);
	Иначе
		Для каждого УчетнаяСистема Из УчетныеСистемыДляСинхронизацииОбъекта(Объект) Цикл
			СостояниеИнтеграции = СостояниеИнтеграцииОбъекта(Объект, УчетнаяСистема);
			Если СостояниеИнтеграции = Неопределено Тогда
				СостояниеИнтеграции = НовыйСостояниеИнтеграции();
				СостояниеИнтеграции.НастройкаИнтеграции = УчетнаяСистема;
			КонецЕсли;
			СостояниеИнтеграции.Состояние = Перечисления.СостоянияОбъектовИнтеграцииCRM.ПодготовленоКОтправке;
			
			СостоянияИнтеграции.Добавить(СостояниеИнтеграции);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого СостояниеИнтеграции Из СостоянияИнтеграции Цикл
		ЗаписатьСостояниеИнтеграцииCRM(Объект, СостояниеИнтеграции);
		ИнтеграцияОбъектовОбластейДанных.ДобавитьОбъектКОтправке(
			СостояниеИнтеграции.НастройкаИнтеграции,
			СостояниеИнтеграции.Идентификатор,
			ОбработчикДанныхEnterpriseData());
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтменитьОтправкуОбъекта(Объект)
	
	Для каждого УчетнаяСистема Из УчетныеСистемыДляСинхронизацииОбъекта(Объект) Цикл
		СостояниеИнтеграции = СостояниеИнтеграцииОбъекта(Объект, УчетнаяСистема);
		Если СостояниеИнтеграции = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СостояниеИнтеграции.Состояние = Неопределено;
		
		ЗаписатьСостояниеИнтеграцииCRM(Объект.Ссылка, СостояниеИнтеграции);
		ИнтеграцияОбъектовОбластейДанных.УдалитьОбъектКОтправке(
			СостояниеИнтеграции.НастройкаИнтеграции,
			СостояниеИнтеграции.Идентификатор);
	КонецЦикла;
	
КонецПроцедуры

Функция ХешОбъекта(Объект)
	
	ЗаписьXML = Новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку();
	ЗаписатьXML(ЗаписьXML, Объект, НазначениеТипаXML.Явное);
	
	Хеширование = Новый ХешированиеДанных(ХешФункция.CRC32);
	Хеширование.Добавить(ЗаписьXML.Закрыть());
	Возврат Хеширование.ХешСумма;
	
КонецФункции

Функция ОбработчикДанныхEnterpriseData()
	
	Возврат "enterprise_data";
	
КонецФункции

#Область ВыгрузкаEnterpriseData

Функция ДвоичныеДанныеДляОтправкиEnterpriseData(Объект, НастройкиИнтеграции)
	
	Обработка = Обработки.ВыгрузкаЗагрузкаEnterpriseData.Создать();
	Обработка.ВерсияФормата = ВерсияФорматаEnterpriseData(НастройкиИнтеграции);
	Обработка.СписокДополнениеКВыгрузке.Добавить(Объект);
	
	Если ТипЗнч(Объект) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
		Обработка.СписокДополнениеКВыгрузке.Добавить(ДанныеОплатыЗаказа(Объект));
		Обработка.СписокДополнениеКВыгрузке.Добавить(ДанныеОтгрузкиЗаказа(Объект));
	КонецЕсли;
	
	РезультатВыгрузки = Обработка.ВыгрузитьДанныеВXML();
	Если РезультатВыгрузки.ЕстьОшибки Тогда
		// Запишем в журнал регистрации ошибку, но саму отправку не блокируем,
		// чтобы не тормозить отправку остальных объектов.
		ЗаписьЖурналаРегистрации(ИмяСобытияЖурналаРегистрации(),
			УровеньЖурналаРегистрации.Ошибка, Объект.Метаданные(), Объект, РезультатВыгрузки.ТекстОшибки);
	КонецЕсли;
	ОбъектДляВыгрузки = Новый ТекстовыйДокумент;
	ОбъектДляВыгрузки.УстановитьТекст(РезультатВыгрузки.ТекстВыгрузки);
	
	Поток = Новый ПотокВПамяти;
	ОбъектДляВыгрузки.Записать(Поток, "UTF-8");
	
	Возврат Поток.ЗакрытьИПолучитьДвоичныеДанные();
	
КонецФункции

Функция ВерсияФорматаEnterpriseData(НастройкиИнтеграции)
	
	ВерсияФормата = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(НастройкиИнтеграции, "ВерсияФормата");
	Если ЗначениеЗаполнено(ВерсияФормата) Тогда
		Возврат ВерсияФормата;
	Иначе
		Возврат "1.6";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ЗагрузкаEnterpriseData

Функция ЗагрузитьСообщениеEnterpriseData(ПотокДанных, Ошибка, СообщениеОбОшибке)
	
	Обработка = Обработки.ВыгрузкаЗагрузкаEnterpriseData.Создать();
	
	ЧтениеXML = Новый ЧтениеXML();
	ЧтениеXML.ОткрытьПоток(ПотокДанных);
	
	РезультатЗагрузки = Обработка.ЗагрузитьДанныеИзXML(ЧтениеXML);// Этот вариант API подсистемы ОбменДанными не умеет проводить документы
	
	Если НЕ РезультатЗагрузки.ЕстьОшибки Тогда
		ПровестиЗагруженныеДокументы(РезультатЗагрузки.ЗагруженныеОбъекты);
	КонецЕсли;
	
	Ошибка = РезультатЗагрузки.ЕстьОшибки;
	СообщениеОбОшибке = РезультатЗагрузки.ТекстОшибки;
	
	Возврат РезультатЗагрузки.ЗагруженныеОбъекты;
	
КонецФункции

Процедура ПровестиЗагруженныеДокументы(ЗагруженныеОбъекты)
	
	Для Каждого Ссылка Из ЗагруженныеОбъекты Цикл
		
		МетаданныеДокумента = Ссылка.Метаданные();
		
		Если Не ОбщегоНазначения.ЭтоДокумент(МетаданныеДокумента) Тогда
			Продолжить;
		КонецЕсли;
		
		Если МетаданныеДокумента.Проведение <> Метаданные.СвойстваОбъектов.Проведение.Разрешить Тогда
			Продолжить;
		КонецЕсли;
		
		Объект = Ссылка.ПолучитьОбъект();
		Если Объект = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Попытка
			Объект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			
			ШаблонТекстаОшибки = НСтр("ru = 'Загруженный документ не проведен.
	                                   |%1'", Метаданные.ОсновнойЯзык.КодЯзыка);
			
			ТекстОшибки = СтрШаблон(ШаблонТекстаОшибки, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ИмяСобытияЖурналаРегистрации(),
				УровеньЖурналаРегистрации.Предупреждение,
				МетаданныеДокумента,
				Ссылка,
				ТекстОшибки);
				
		КонецПопытки;
			
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаписатьИдентификаторЗагруженногоОбъекта(ЗагруженныеОбъекты, УчетнаяСистема, ИдентификаторОбъекта)
	
	Для каждого ЗагруженныйОбъект Из ЗагруженныеОбъекты Цикл
		Если НЕ ТипОбъектаСинхронизируетсяCRM(ЗагруженныйОбъект) Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(ЗагруженныйОбъект) = Тип("ДокументСсылка.ЗаказПокупателя") Тогда
			СостояниеИнтеграции = НовыйСостояниеИнтеграции();
			СостояниеИнтеграции.Идентификатор = ИдентификаторОбъекта;
			СостояниеИнтеграции.НастройкаИнтеграции = УчетнаяСистема;
			ВыполнитьРегистрациюКОтправке(ЗагруженныйОбъект, СостояниеИнтеграции);
		Иначе
			УстановитьСостояниеОбъектСинхронизировано(ЗагруженныйОбъект, УчетнаяСистема, ИдентификаторОбъекта);
			// При загрузке через EnterpriseData может измениться хеш документа и он зарегистрируется на отправку.
			// Поэтому очистим только что загруженный документ из объектов к отправке.
			ИнтеграцияОбъектовОбластейДанных.УдалитьОбъектКОтправке(УчетнаяСистема, ИдентификаторОбъекта);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли

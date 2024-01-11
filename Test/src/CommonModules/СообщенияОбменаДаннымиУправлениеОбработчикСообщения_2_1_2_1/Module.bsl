///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Пространство имен версии интерфейса сообщений.
//
// Возвращаемое значение:
//   Строка - пространство имен.
//
Функция Пакет() Экспорт
	
	Возврат "http://www.1c.ru/SaaS/Exchange/Manage";
	
КонецФункции

// Версия интерфейса сообщений, обслуживаемая обработчиком.
//
// Возвращаемое значение:
//   Строка - версия интерфейса сообщений.
//
Функция Версия() Экспорт
	
	Возврат "2.1.2.1";
	
КонецФункции

// Базовый тип для сообщений версии.
//
// Возвращаемое значение:
//   ТипОбъектаXDTO - базовый тип тела сообщения.
//
Функция БазовыйТип() Экспорт
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		ВызватьИсключение НСтр("ru = 'Отсутствует менеджер сервиса.'");
	КонецЕсли;
	
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Возврат МодульСообщенияВМоделиСервиса.ТипТело();
	
КонецФункции

// Выполняет обработку входящих сообщений модели сервиса
//
// Параметры:
//   Сообщение   - ОбъектXDTO - входящее сообщение.
//   Отправитель - ПланОбменаСсылка.ОбменСообщениями - узел плана обмена, соответствующий отправителю сообщения.
//   СообщениеОбработано - Булево - флаг успешной обработки сообщения. Значение данного параметра необходимо
//                         установить равным Истина в том случае, если сообщение было успешно прочитано в данном обработчике.
//
Процедура ОбработатьСообщениеМоделиСервиса(Знач Сообщение, Знач Отправитель, СообщениеОбработано) Экспорт
	
	СообщениеОбработано = Истина;
	
	Словарь = СообщенияОбменаДаннымиУправлениеИнтерфейс;
	ТипСообщения = Сообщение.Body.Тип();
	
	Если ТипСообщения = Словарь.СообщениеНастроитьОбменШаг1(Пакет()) Тогда
		
		НастроитьОбменШаг1(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеНастроитьОбменШаг2(Пакет()) Тогда
		
		НастроитьОбменШаг2(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеЗагрузитьСообщениеОбмена(Пакет()) Тогда
		
		ЗагрузитьСообщениеОбмена(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучитьДанныеКорреспондента(Пакет()) Тогда
		
		ПолучитьДанныеКорреспондента(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучитьОбщиеДанныеУзловКорреспондента(Пакет()) Тогда
		
		ПолучитьОбщиеДанныеУзловКорреспондента(Сообщение, Отправитель);
		
	ИначеЕсли ТипСообщения = Словарь.СообщениеПолучитьПараметрыУчетаКорреспондента(Пакет()) Тогда
		
		ПолучитьПараметрыУчетаКорреспондента(Сообщение, Отправитель);
		
	Иначе
		
		СообщениеОбработано = Ложь;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура НастроитьОбменШаг1(Сообщение, Отправитель)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Если Сообщение.Установлено("AdditionalInfo") Тогда
		ДополнительныеСвойства = СериализаторXDTO.ПрочитатьXDTO(Сообщение.AdditionalInfo);
		Если ДополнительныеСвойства.Свойство("Интерфейс")
			И ДополнительныеСвойства.Интерфейс = "3.0.1.1" Тогда
			СообщенияОбменаДаннымиУправлениеОбработчикСообщения_3_0_1_1.НастроитьОбменШаг1(Сообщение, Отправитель);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Тело = Сообщение.Body;
	
	Корреспондент = Неопределено;
	
	НачатьТранзакцию();
	Попытка
		
		КодЭтогоУзла       = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПланыОбмена[Тело.ExchangePlan].ЭтотУзел(), "Код");
		ПсевдонимЭтогоУзла = "";
		
		Если Не ПустаяСтрока(КодЭтогоУзла)
			И КодЭтогоУзла <> Тело.Code Тогда
			
			ПсевдонимЭтогоУзла = ОбменДаннымиВМоделиСервиса.КодУзлаПланаОбменаВСервисе(МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса());
		
			Если ПсевдонимЭтогоУзла <> Тело.Code Тогда
				СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ожидаемый код предопределенного узла в этом приложении ""%1""
					|не соответствует фактическому ""%2"" или псевдониму ""%3"". План обмена: %4.'"),
					Тело.Code, КодЭтогоУзла, ПсевдонимЭтогоУзла, Тело.ExchangePlan);
				ВызватьИсключение СтрокаСообщения;
			КонецЕсли;
			
		КонецЕсли;
		
		КонечнаяТочкаКорреспондента = ОбменДаннымиВМоделиСервиса.МенеджерПланаОбменаКонечныхТочек().НайтиПоКоду(Тело.EndPoint);
		
		Если КонечнаяТочкаКорреспондента.Пустая() Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не найдена конечная точка корреспондента с кодом ""%1"".'"),
				Тело.EndPoint);
		КонецЕсли;
		
		Префикс = "";
		Если Сообщение.Установлено("AdditionalInfo") Тогда
			Префикс = СериализаторXDTO.ПрочитатьXDTO(Сообщение.AdditionalInfo).Префикс;
		КонецЕсли;
		
		НастройкаОтборовНаУзле = СериализаторXDTO.ПрочитатьXDTO(Тело.FilterSettings);
		
		// {Обработчик: ПриПолученииДанныхОтправителя} Начало
		Если ОбменДаннымиСервер.ЕстьАлгоритмМенеджераПланаОбмена("ПриПолученииДанныхОтправителя", Тело.ExchangePlan) Тогда
			ПланыОбмена[Тело.ExchangePlan].ПриПолученииДанныхОтправителя(НастройкаОтборовНаУзле, Ложь);
		КонецЕсли;
		// {Обработчик: ПриПолученииДанныхОтправителя} Окончание
		
		// Создаем настройку обмена
		НастройкиПодключения = Новый Структура;
		НастройкиПодключения.Вставить("ИмяПланаОбмена",              Тело.ExchangePlan);
		НастройкиПодключения.Вставить("КодКорреспондента",           Тело.CorrespondentCode);
		НастройкиПодключения.Вставить("НаименованиеКорреспондента",  Тело.CorrespondentName);
		НастройкиПодключения.Вставить("КонечнаяТочкаКорреспондента", КонечнаяТочкаКорреспондента);
		НастройкиПодключения.Вставить("Настройки",                   НастройкаОтборовНаУзле);
		НастройкиПодключения.Вставить("Префикс",                     Префикс);
		НастройкиПодключения.Вставить("Корреспондент"); // выходной параметр
		
		ОбменДаннымиВМоделиСервиса.СоздатьНастройкуОбмена(
			НастройкиПодключения,
			Истина,
			,
			ПсевдонимЭтогоУзла);
			
		Корреспондент = НастройкиПодключения.Корреспондент;
		
		// Регистрируем справочники к выгрузке
		ОбменДаннымиСервер.ЗарегистрироватьТолькоСправочникиДляНачальнойВыгрузки(Корреспондент);
		
		// Выполняем выгрузку данных
		Отказ = Ложь;
		ОбменДаннымиВМоделиСервиса.ВыполнитьВыгрузкуДанных(Отказ, Корреспондент);
		Если Отказ Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Возникли ошибки в процессе выгрузки справочников для корреспондента %1.'"),
				Строка(Корреспондент));
		КонецЕсли;
		
		// Отправляем ответное сообщение об успешной операции
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеНастройкаОбменаШаг1УспешноЗавершена());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ОбменДаннымиВМоделиСервиса.УдалитьУзелПланаОбмена(Корреспондент);
		
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		НачатьТранзакцию();
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаНастройкиОбменаШаг1());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Процедура НастроитьОбменШаг2(Сообщение, Отправитель)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Тело = Сообщение.Body;
	
	НачатьТранзакцию();
	Попытка
		
		Корреспондент = КорреспондентОбмена(Тело.ExchangePlan, Тело.CorrespondentCode);
		
		// Обновляем настройку обмена
		ОбменДаннымиВМоделиСервиса.ОбновитьНастройкуОбмена(Корреспондент,
			ОбменДаннымиСервер.ПолучитьЗначенияНастройкиОтборов(СериализаторXDTO.ПрочитатьXDTO(Тело.AdditionalSettings)));
		
		// Регистрируем все данные к выгрузке, кроме справочников
		ОбменДаннымиСервер.ЗарегистрироватьВсеДанныеКромеСправочниковДляНачальнойВыгрузки(Корреспондент);
		
		// Отправляем ответное сообщение об успешной операции
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеНастройкаОбменаШаг2УспешноЗавершена());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаНастройкиОбменаШаг2());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Процедура ЗагрузитьСообщениеОбмена(Сообщение, Отправитель)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Если Сообщение.Установлено("AdditionalInfo") Тогда
		ДополнительныеСвойства = СериализаторXDTO.ПрочитатьXDTO(Сообщение.AdditionalInfo);
		Если ДополнительныеСвойства.Свойство("Интерфейс")
			И ДополнительныеСвойства.Интерфейс = "3.0.1.1" Тогда
			СообщенияОбменаДаннымиУправлениеОбработчикСообщения_3_0_1_1.ЗагрузитьСообщениеОбмена(Сообщение, Отправитель);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Тело = Сообщение.Body;
	
	ОтветноеСообщение = Неопределено;
	Попытка
		
		Корреспондент = КорреспондентОбмена(Тело.ExchangePlan, Тело.CorrespondentCode);
		
		// Загружаем сообщение обмена
		Отказ = Ложь;
		ОбменДаннымиВМоделиСервиса.ВыполнитьЗагрузкуДанных(Отказ, Корреспондент);
		Если Отказ Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Возникли ошибки в процессе загрузки справочников от корреспондента %1.'"),
				Строка(Корреспондент));
		КонецЕсли;
		
		// Отправляем ответное сообщение об успешной операции
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеЗагрузкаСообщенияОбменаУспешноЗавершена());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
	Исключение
		
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаЗагрузкиСообщенияОбмена());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
	КонецПопытки;
	
	Если Не ОтветноеСообщение = Неопределено Тогда
		НачатьТранзакцию();
		Попытка
			МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			ВызватьИсключение;
		КонецПопытки;
		МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	КонецЕсли;
	
КонецПроцедуры

Процедура ПолучитьДанныеКорреспондента(Сообщение, Отправитель)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Тело = Сообщение.Body;
	
	НачатьТранзакцию();
	Попытка
		
		ДанныеКорреспондента = ОбменДаннымиСервер.ДанныеТаблицКорреспондента(
			СериализаторXDTO.ПрочитатьXDTO(Тело.Tables), Тело.ExchangePlan);
		
		// Отправляем ответное сообщение об успешной операции
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеПолучениеДанныхКорреспондентаУспешноЗавершено());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.Data = Новый ХранилищеЗначения(ДанныеКорреспондента);
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПолученияДанныхКорреспондента());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Процедура ПолучитьОбщиеДанныеУзловКорреспондента(Сообщение, Отправитель)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Если Сообщение.Установлено("AdditionalInfo") Тогда
		ДополнительныеСвойства = СериализаторXDTO.ПрочитатьXDTO(Сообщение.AdditionalInfo);
		Если ДополнительныеСвойства.Свойство("Интерфейс")
			И ДополнительныеСвойства.Интерфейс = "3.0.1.1" Тогда
			СообщенияОбменаДаннымиУправлениеОбработчикСообщения_3_0_1_1.ПолучитьОбщиеДанныеУзловКорреспондента(Сообщение, Отправитель);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Тело = Сообщение.Body;
	
	НачатьТранзакцию();
	Попытка
		
		ДанныеКорреспондента = ОбменДаннымиСервер.ДанныеДляТабличныхЧастейУзловЭтойИнформационнойБазы(Тело.ExchangePlan);
		
		// Отправляем ответное сообщение об успешной операции
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеПолучениеОбщихДанныхУзловКорреспондентаУспешноЗавершено());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.Data = Новый ХранилищеЗначения(ДанныеКорреспондента);
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПолученияОбщихДанныхУзловКорреспондента());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Процедура ПолучитьПараметрыУчетаКорреспондента(Сообщение, Отправитель)
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("ТехнологияСервиса") Тогда
		Возврат;
	КонецЕсли;
		
	МодульРаботаВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("РаботаВМоделиСервиса");
	МодульСообщенияВМоделиСервиса = ОбщегоНазначения.ОбщийМодуль("СообщенияВМоделиСервиса");
	
	Если Сообщение.Установлено("AdditionalInfo") Тогда
		ДополнительныеСвойства = СериализаторXDTO.ПрочитатьXDTO(Сообщение.AdditionalInfo);
		Если ДополнительныеСвойства.Свойство("Интерфейс")
			И ДополнительныеСвойства.Интерфейс = "3.0.1.1" Тогда
			СообщенияОбменаДаннымиУправлениеОбработчикСообщения_3_0_1_1.ПолучитьПараметрыУчетаКорреспондента(Сообщение, Отправитель);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	
	Тело = Сообщение.Body;
	
	НачатьТранзакцию();
	Попытка
		
		Корреспондент = КорреспондентОбмена(Тело.ExchangePlan, Тело.CorrespondentCode);
		
		Отказ = Ложь;
		ПредставлениеОшибки = "";
		
		ДанныеКорреспондента = Новый Структура;
		
		Если ОбменДаннымиСервер.ЕстьАлгоритмМенеджераПланаОбмена("ОбработчикПроверкиПараметровУчета", Тело.ExchangePlan) Тогда
			ПланыОбмена[Тело.ExchangePlan].ОбработчикПроверкиПараметровУчета(Отказ, Корреспондент, ПредставлениеОшибки);
		КонецЕсли;
		
		ДанныеКорреспондента.Вставить("ПараметрыУчетаЗаданы", Не Отказ);
		ДанныеКорреспондента.Вставить("ПредставлениеОшибки",  ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об успешной операции
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеПолучениеПараметровУчетаКорреспондентаУспешноЗавершено());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.Data = Новый ХранилищеЗначения(ДанныеКорреспондента);
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ПредставлениеОшибки = ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		
		ЗаписьЖурналаРегистрации(ОбменДаннымиВМоделиСервиса.СобытиеЖурналаРегистрацииНастройкаСинхронизацииДанных(),
			УровеньЖурналаРегистрации.Ошибка,,, ПредставлениеОшибки);
		
		// Отправляем ответное сообщение об ошибке
		ОтветноеСообщение = МодульСообщенияВМоделиСервиса.НовоеСообщение(
			СообщенияОбменаДаннымиКонтрольИнтерфейс.СообщениеОшибкаПолученияПараметровУчетаКорреспондента());
		ОтветноеСообщение.Body.Zone = МодульРаботаВМоделиСервиса.ЗначениеРазделителяСеанса();
		ОтветноеСообщение.Body.CorrespondentZone = Тело.CorrespondentZone;
		ОтветноеСообщение.Body.SessionId = Тело.SessionId;
		
		ОтветноеСообщение.Body.ErrorDescription = ПредставлениеОшибки;
		
		НачатьТранзакцию();
		МодульСообщенияВМоделиСервиса.ОтправитьСообщение(ОтветноеСообщение, Отправитель, Истина);
		ЗафиксироватьТранзакцию();
	КонецПопытки;
	
	МодульСообщенияВМоделиСервиса.ДоставитьБыстрыеСообщения();
	
КонецПроцедуры

Функция КорреспондентОбмена(Знач ИмяПланаОбмена, Знач Код)
	
	Результат = ПланыОбмена[ИмяПланаОбмена].НайтиПоКоду(Код);
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не найден узел плана обмена; имя плана обмена %1; код узла %2.'"), ИмяПланаОбмена, Код);
		ВызватьИсключение СтрокаСообщения;
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

#КонецОбласти

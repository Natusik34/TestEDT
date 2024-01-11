
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НовоеПодключение = Истина;
	Если Параметры.Свойство("УчетнаяЗаписьВнешнегоКалендаря") И Параметры.Свойство("ВнешнийСервис") Тогда
		НовоеПодключение = Ложь;
		Если Параметры.ВнешнийСервис = Перечисления.ТипыСинхронизацииКалендарей.Google Тогда
			ВнешнийСервисТекущий = Параметры.ВнешнийСервис;
			ОбновитьФорму(20);
		Иначе
			УчетнаяЗаписьВнешнегоКалендаря = Параметры.УчетнаяЗаписьВнешнегоКалендаря;
			Если Не УчетнаяЗаписьВнешнегоКалендаря.Пустая() Тогда
				ВнешнийСервисТекущий = УчетнаяЗаписьВнешнегоКалендаря.Провайдер;
				Сервер = УчетнаяЗаписьВнешнегоКалендаря.Сервер;
				Логин = УчетнаяЗаписьВнешнегоКалендаря.Наименование;
				КаталогКалендарей = УчетнаяЗаписьВнешнегоКалендаря.КаталогКалендарей;
				УстановитьПривилегированныйРежим(Истина);
				Пароль = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(УчетнаяЗаписьВнешнегоКалендаря.Ссылка, "Пароль");
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли;
			ОбновитьФорму(10);
		КонецЕсли;
	Иначе
		УчетнаяЗаписьВнешнегоКалендаря = Справочники.УчетныеЗаписиВнешнихКалендарей.ПустаяСсылка();
		ОбновитьФорму(0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ОбновитьСтатусСеансовыхДанныхGoogle" Тогда
		ЗаполнитьСтатусСеансовыхДанныхGoogle();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Оповестить("ОбменСКалендарями_ОбновитьСписокПодключенийВнешнихКалендарей");
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура ТаблицаНастройкаСинхронизацииDAVКалендарьНаименованиеПриИзменении(Элемент)
	ТекущаяСтрока = ТаблицаНастройкаСинхронизации.Получить(Элемент.Родитель.ТекущаяСтрока);
	ТекущаяСтрока.КалендарьСотрудникаНаименование = Элемент.ТекстРедактирования;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаНастройкаСинхронизацииКалендарьСотрудникаНаименованиеПриИзменении(Элемент)
	ТекущаяСтрока = ТаблицаНастройкаСинхронизации.Получить(Элемент.Родитель.ТекущаяСтрока);
	ТекущаяСтрока.DAVКалендарьНаименование = Элемент.ТекстРедактирования;
КонецПроцедуры

&НаСервере
Процедура СервисDAVПриИзмененииНаСервере()
	
	Если ВнешнийСервисТекущий <> Неопределено Тогда
		Сервер = Неопределено;
		Если ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.iCloud Тогда
			Сервер = "caldav.icloud.com";
		КонецЕсли;
		Если ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.Яндекс Тогда
			Сервер = "caldav.yandex.ru";
		КонецЕсли;
		Если ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.mailru Тогда
			Сервер = "calendar.mail.ru";
		КонецЕсли;
		ОбновитьФорму(10);
	КонецЕсли;
	ПроверкаЗаполненияПолейDAV();
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Логин = Текст;
	ПроверкаЗаполненияПолейDAV();
КонецПроцедуры

&НаКлиенте
Процедура ПарольИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	Пароль = Текст;
	ПроверкаЗаполненияПолейDAV();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаЯндексСервисПриИзменении(Элемент)
	НастроитьЯндекс();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаMailRuСервисПриИзменении(Элемент)
	НастроитьMailRu();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаICloudСервисПриИзменении(Элемент)
	НастроитьICloud();
КонецПроцедуры

&НаКлиенте
Процедура КнопкаGoogleСервисПриИзменении(Элемент)
	НастроитьGoogle();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	ДалееНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	
	Если ТекущийШагСценария = 10 И НовоеПодключение Тогда
		ОбновитьФорму(0);
	ИначеЕсли ТекущийШагСценария = 11 Тогда
		ОбновитьФорму(10);
	ИначеЕсли ТекущийШагСценария = 12 Тогда
		ОбновитьФорму(11);
	ИначеЕсли ТекущийШагСценария = 22 Тогда
		ОбновитьФорму(21);
	ИначеЕсли ТекущийШагСценария = 21 Тогда
		ОбновитьФорму(20);
	ИначеЕсли ТекущийШагСценария = 20 И НовоеПодключение Тогда
		ОбновитьФорму(0);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	Оповестить("Календарь_ОбновитьСписокДоступныхКалендарей");
	Если ТекущийШагСценария = 12 ИЛИ ТекущийШагСценария = 21 Тогда
		Оповестить("ОбменСКалендарями_ОбновитьСписокПодключенийВнешнихКалендарей");
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьЯндексСервис(Команда)
	НастроитьЯндекс();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьMailRuСервис(Команда)
	НастроитьMailRu();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьICloudСервис(Команда)
	НастроитьICloud();
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьGoogleСервис(Команда)
	НастроитьGoogle();
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьGoogleАккаунт(Команда)
	
	Если ПроверитьОбновитьИдентификацияПриложенияGoogle() Тогда
		Оповещение = Новый ОписаниеОповещения("СеансовыеДанныеСGoogleЗавершение",ЭтотОбъект);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ОбластьДоступа", ПредопределенноеЗначение("Перечисление.ОбластиДоступаGoogle.Календарь"));
		ПараметрыФормы.Вставить("ВыполнитьСинхронизацию", Ложь);
		ОткрытьФорму("Обработка.ОбменСGoogle.Форма.ВыполнитьОбменСGoogle", ПараметрыФормы,,,,,Оповещение);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПерейтиКНастройкеКалендарейDAV()
	
	УчетнаяЗаписьВнешнегоКалендаря = Справочники.УчетныеЗаписиВнешнихКалендарей.НайтиПоКлючевымПолям(Логин, ВнешнийСервисТекущий);
	
	Если НовоеПодключение И Не УчетнаяЗаписьВнешнегоКалендаря.Пустая() Тогда
		ТекстСообщенияПодключениеСуществует =НСтр("ru = 'Подключение для внешнего сервиса %1 (%2) уже существует.'");
		ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстСообщенияПодключениеСуществует, ВнешнийСервисТекущий, Логин));
		Возврат;
	Иначе
		ПроверитьСтатусПодключения(УчетнаяЗаписьВнешнегоКалендаря);
		Если СтатусПодключения = 207 Тогда
			ОбновитьФорму(11);
		Иначе
			ТекстСообщенияСтатусПодключения = НСтр("ru = 'Отсутствует подключение. Статус %1'");
			ОбщегоНазначения.СообщитьПользователю(СтрШаблон(ТекстСообщенияСтатусПодключения, СтатусПодключения));
		КонецЕсли;
	КонецЕсли
	
КонецПроцедуры

&НаСервере
Процедура ДалееНаСервере()
	
	Если ТекущийШагСценария = 0 Тогда
		СервисDAVПриИзмененииНаСервере();
		Если ЗначениеЗаполнено(ВнешнийСервисТекущий) Тогда
			Если ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.Google Тогда
				ОбновитьФорму(20);
			Иначе
				ОбновитьФорму(10);
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТекущийШагСценария = 10 Тогда
		ПерейтиКНастройкеКалендарейDAV();
	ИначеЕсли ТекущийШагСценария = 11 Тогда
		ПерейтиКЗавершениюНастройкиКалендарейDAV();
	ИначеЕсли ТекущийШагСценария = 20 Тогда
		Если ПроверитьОбновитьИдентификацияПриложенияGoogle() Тогда
			ОбновитьФорму(21);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьСтатусПодключения(УчетнаяЗаписьВнешнегоКалендаря)
	
	ДанныеАвторизации = Справочники.УчетныеЗаписиВнешнихКалендарей.ДанныеАвторизации(УчетнаяЗаписьВнешнегоКалендаря);
	Если Не ЗначениеЗаполнено(ДанныеАвторизации) Тогда
		ДанныеАвторизации = Новый Структура;
		ДанныеАвторизации.Вставить("Сервер", Сервер);
		ДанныеАвторизации.Вставить("Логин", Логин);
		ДанныеАвторизации.Вставить("Пароль", Пароль);
		ДанныеАвторизации.Вставить("КорневойКаталог", "");
		ДанныеАвторизации.Вставить("КаталогКалендарей", "");
	КонецЕсли;
	
	Если ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.mailru Тогда
		ДанныеАвторизации.КорневойКаталог = СтрШаблон("principals/%1/%2/", Прав(Логин, СтрДлина(Логин) - Найти(Логин, "@") ), Лев(Логин, СтрНайти(Логин, "@") - 1));
	КонецЕсли;
	ДанныеАвторизации.КаталогКалендарей = СинхронизацияDAV.КаталогКалендарейНаСервереDAV(ДанныеАвторизации, СтатусПодключения);
	
КонецПроцедуры

&НаСервере
Процедура ПерейтиКЗавершениюНастройкиКалендарейDAV()
	СохранитьНастройкиDAV();
	ОбновитьФорму(12);
КонецПроцедуры

&НаСервере
Процедура ОбновитьФорму(ШагСценария = Неопределено)
	
	// Новое подключение
	Если ШагСценария = 0 Тогда
		Элементы.СтраницыНастройкаСинхронизации.ТекущаяСтраница = Элементы.СтраницаНовоеПодключение;
		Логин = "";
		Пароль = "";
		ОбновитьВыбор();
	Иначе
	КонецЕсли;
	
	// Сценарий - настройка DAV. Шаг - настройка подключения к приложению Календарь
	Если ШагСценария = 10 Тогда
		Элементы.СтраницыНастройкаСинхронизации.ТекущаяСтраница = Элементы.СтраницаУчетнаяЗапись;
		Элементы.СтраницыВариантыАвторизации.ТекущаяСтраница = Элементы.СтраницаНастройкиDAV;
		Элементы.СтраницыШагиНастройкиDAV.ТекущаяСтраница = Элементы.СтраницаАвторизацииDAV;
		ЭтаФорма.Заголовок = СтрШаблон(НСтр("ru = 'Настройка обмена с %1'"), ВнешнийСервисТекущий);
		Элементы.ДекорацияИнструкцияDAV2.Заголовок = ПолучитьТекстИСсылкуНаИнструкцию(ВнешнийСервисТекущий);
		ТекстСообщенияЗаголовокФормыНастройки = НСтр("ru = 'Выберите календари %1, которые необходимо синхронизировать.'");
		ТекстСообщенияСправка1 = НСтр("ru = 'При включении будет выполняться автоматическая двусторонняя синхронизация с календарем %1.'");
		ТекстСообщенияСправка2 = НСтр("ru = 'Синхронизация происходит только для календарей с включенным признаком ""Синхронизировать с %1"".'");
		Элементы.ДекорацияИнструкцияКалендариDAV.Заголовок = СтрШаблон(ТекстСообщенияЗаголовокФормыНастройки, ВнешнийСервисТекущий);
		Элементы.ДекорацияТекстСправка1.Заголовок = СтрШаблон(ТекстСообщенияСправка1, ВнешнийСервисТекущий);
		Элементы.ДекорацияТекстСправка2.Заголовок = СтрШаблон(ТекстСообщенияСправка2, ВнешнийСервисТекущий);
		ПроверкаЗаполненияПолейDAV();
	КонецЕсли;
	
	// Сценарий - настройка DAV. Шаг - настройка карты синхронизации для DAV календарей
	Если ШагСценария = 11 Тогда
		Элементы.СтраницыШагиНастройкиDAV.ТекущаяСтраница = Элементы.СтраницаКалендари;
		ЗагрузитьДанныеСинхронизацииКалендарей();
	КонецЕсли;
	
	// Сценарий - настройка DAV. Шаг - завершение настройки синхронизации для DAV календарей
	Если ШагСценария = 12 Тогда
		Элементы.СтраницыШагиНастройкиDAV.ТекущаяСтраница = Элементы.СтраницаЗавершениеНастройки;
	КонецЕсли;
	
	// Сценарий - настройка Google. Шаг - настройка подключения к Google API
	Если ШагСценария = 20 Тогда
		ЭтаФорма.Заголовок = СтрШаблон(НСтр("ru = 'Настройка обмена с %1'"), ВнешнийСервисТекущий);
		Элементы.СтраницыНастройкаСинхронизации.ТекущаяСтраница = Элементы.СтраницаУчетнаяЗапись;
		Элементы.СтраницыВариантыАвторизации.ТекущаяСтраница = Элементы.СтраницаНастройкиGoogle;
		Элементы.СтраницыШагиНастройкиGoogle.ТекущаяСтраница = Элементы.СтраницаДеталиАвторизацииGoogle;
		ПолучитьСеансовыеДанныеGoogle();
		ЗаполнитьСтатусСеансовыхДанныхGoogle();
	КонецЕсли;
	
	// Сценарий - настройка Google. Шаг подключения Google аккаунта
	Если ШагСценария = 21 Тогда
		Элементы.СтраницыШагиНастройкиGoogle.ТекущаяСтраница = Элементы.СтраницаВходВGoogle;
	КонецЕсли;
	
	ОбновитьКоманднуюПанель(ШагСценария);
	ТекущийШагСценария = ШагСценария;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьКоманднуюПанель(ШагСценария)
	
	Если ШагСценария = 0 Тогда
		Элементы.КнопкаНазад.Видимость = Ложь;
		Элементы.КнопкаДалее.Видимость = Истина;
		Элементы.КнопкаДалее.КнопкаПоУмолчанию  = Истина;
		Элементы.КнопкаЗакрыть.Видимость = Ложь;
	ИначеЕсли ШагСценария = 10 Тогда
		Элементы.КнопкаНазад.Видимость = ?(НовоеПодключение, Истина, Ложь);
		Элементы.КнопкаДалее.Видимость = Истина;
		Элементы.КнопкаДалее.КнопкаПоУмолчанию  = Истина;
		Элементы.КнопкаЗакрыть.Видимость = Ложь;
	ИначеЕсли ШагСценария = 11 Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Истина;
		Элементы.КнопкаДалее.КнопкаПоУмолчанию  = Истина;
		Элементы.КнопкаЗакрыть.Видимость = Ложь;
	ИначеЕсли ШагСценария = 12 Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Ложь;
		Элементы.КнопкаЗакрыть.Видимость = Истина;
		Элементы.КнопкаЗакрыть.КнопкаПоУмолчанию = Истина;
	ИначеЕсли ШагСценария = 20 Тогда
		Элементы.КнопкаНазад.Видимость = ?(НовоеПодключение, Истина, Ложь);
		Элементы.КнопкаДалее.Видимость = Истина;
		Элементы.КнопкаДалее.КнопкаПоУмолчанию  = Истина;
		Элементы.КнопкаЗакрыть.Видимость = Ложь;
	ИначеЕсли ШагСценария = 21 Тогда
		Элементы.КнопкаНазад.Видимость = Истина;
		Элементы.КнопкаДалее.Видимость = Ложь;
		Элементы.КнопкаЗакрыть.Видимость = Истина;
		Элементы.КнопкаЗакрыть.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТекстИСсылкуНаИнструкцию(ВнешнийСервис)
	
	Если ВнешнийСервис = Перечисления.ТипыСинхронизацииКалендарей.Яндекс Тогда
		ИнструкцияАдрес = "https://its.1c.ru/db/metod81#content:8067:hdoc";
	ИначеЕсли ВнешнийСервис = Перечисления.ТипыСинхронизацииКалендарей.mailru Тогда
		ИнструкцияАдрес = "https://its.1c.ru/db/metod81#content:8068:hdoc";
	ИначеЕсли ВнешнийСервис = Перечисления.ТипыСинхронизацииКалендарей.iCloud Тогда
		ИнструкцияАдрес = "https://its.1c.ru/db/metod81#content:8066:hdoc";
	КонецЕсли;
	
	Ссылка = СтрШаблон(НСтр("ru = '<a href=""%1"" style=""font-weight:bold"">инструкцию</a>'"), ИнструкцияАдрес);
	ТекстСообщения = СтрШаблон(НСтр("ru = 'Изучите %1, для получения пароля к календарям %2 и укажите его в поле ""Пароль"".'"), Ссылка, ВнешнийСервис);
	
	Возврат СтроковыеФункции.ФорматированнаяСтрока(ТекстСообщения);
	
КонецФункции

&НаСервере
Процедура ЗагрузитьДанныеСинхронизацииКалендарей()
	
	ТаблицаНастройкаСинхронизации.Очистить();
	
	Если ДанныеАвторизации.КаталогКалендарей = "" Тогда
		ДанныеАвторизации.КаталогКалендарей = СинхронизацияDAV.КаталогКалендарейНаСервереDAV(ДанныеАвторизации);
	КонецЕсли;
	
	СписокКалендарейDAV = СинхронизацияDAV.СписокКалендарейНаСервереDAV(ДанныеАвторизации);
	СотрудникиПользователя = РегистрыСведений.СотрудникиПользователя.ПолучитьСотрудниковПользователя(Пользователи.ТекущийПользователь());
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	СписокКалендарейDAV.Идентификатор КАК Идентификатор,
	|	СписокКалендарейDAV.Наименование КАК Наименование,
	|	СписокКалендарейDAV.ТипСервиса КАК ТипСервиса,
	|	СписокКалендарейDAV.ТипКалендаря КАК ТипКалендаря
	|ПОМЕСТИТЬ СписокВнешнихКалендарей
	|ИЗ
	|	&СписокКалендарейDAV КАК СписокКалендарейDAV
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиСинхронизацииСВнешнимиКалендарями.КодВнешнегоКалендаря КАК КодВнешнегоКалендаря,
	|	НастройкиСинхронизацииСВнешнимиКалендарями.КалендарьDAVНаименование КАК КалендарьDAVНаименование,
	|	НастройкиСинхронизацииСВнешнимиКалендарями.КалендарьСотрудника КАК КалендарьСотрудника,
	|	НастройкиСинхронизацииСВнешнимиКалендарями.УчетнаяЗаписьВнешнегоКалендаря КАК УчетнаяЗаписьВнешнегоКалендаря,
	|	НастройкиСинхронизацииСВнешнимиКалендарями.Статус КАК Статус,
	|	НастройкиСинхронизацииСВнешнимиКалендарями.КалендарьСотрудника.Наименование КАК КалендарьСотрудникаНаименование
	|ПОМЕСТИТЬ ЗарегистрированныеСинхронизацииПоУчетнойЗаписи
	|ИЗ
	|	РегистрСведений.НастройкиСинхронизацииСВнешнимиКалендарями КАК НастройкиСинхронизацииСВнешнимиКалендарями
	|ГДЕ
	|	НастройкиСинхронизацииСВнешнимиКалендарями.УчетнаяЗаписьВнешнегоКалендаря = &УчетнаяЗаписьВнешнегоКалендаря
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СписокВнешнихКалендарей.Идентификатор КАК КодВнешнегоКалендаря,
	|	СписокВнешнихКалендарей.Наименование КАК DAVКалендарьНаименование,
	|	СписокВнешнихКалендарей.ТипСервиса КАК ТипСервиса,
	|	СписокВнешнихКалендарей.ТипКалендаря КАК ТипКалендаря,
	|	ВЫБОР
	|		КОГДА СписокВнешнихКалендарей.ТипКалендаря ПОДОБНО ""VTODO""
	|			ТОГДА ПОДСТРОКА(СписокВнешнихКалендарей.Наименование, 1, 255) + &СписокЗадачТекст
	|		ИНАЧЕ СписокВнешнихКалендарей.Наименование
	|	КОНЕЦ КАК DAVКалендарьНаименованиеОписание,
	|	ЗарегистрированныеСинхронизацииПоУчетнойЗаписи.КалендарьСотрудника,
	|	ЗарегистрированныеСинхронизацииПоУчетнойЗаписи.КалендарьСотрудникаНаименование,
	|	ЗарегистрированныеСинхронизацииПоУчетнойЗаписи.УчетнаяЗаписьВнешнегоКалендаря КАК УчетнаяЗаписьВнешнегоКалендаря,
	|	ЗарегистрированныеСинхронизацииПоУчетнойЗаписи.Статус КАК Статус
	|ПОМЕСТИТЬ КартаСинхронизации
	|ИЗ
	|	СписокВнешнихКалендарей
	|	ЛЕВОЕ СОЕДИНЕНИЕ ЗарегистрированныеСинхронизацииПоУчетнойЗаписи
	|	ПО СписокВнешнихКалендарей.Идентификатор = ЗарегистрированныеСинхронизацииПоУчетнойЗаписи.КодВнешнегоКалендаря
	|ГДЕ
	|	ВЫБОР
	|			КОГДА СписокВнешнихКалендарей.ТипСервиса = &Яндекс
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ СписокВнешнихКалендарей.ТипКалендаря = ""VEVENT""
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КартаСинхронизации.КодВнешнегоКалендаря,
	|	КартаСинхронизации.DAVКалендарьНаименование,
	|	КартаСинхронизации.ТипСервиса,
	|	КартаСинхронизации.ТипКалендаря,
	|	КартаСинхронизации.DAVКалендарьНаименованиеОписание,
	|	КартаСинхронизации.КалендарьСотрудника,
	|	КартаСинхронизации.КалендарьСотрудникаНаименование,
	|	КартаСинхронизации.УчетнаяЗаписьВнешнегоКалендаря КАК УчетнаяЗаписьВнешнегоКалендаря,
	|	КартаСинхронизации.Статус КАК Статус,
	|	ВЫБОР
	|		КОГДА КартаСинхронизации.КалендарьСотрудника ЕСТЬ NULL
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НоваяСинхронизация
	|ИЗ
	|	КартаСинхронизации");
	
	Запрос.УстановитьПараметр("СписокКалендарейDAV", СписокКалендарейDAV);
	Запрос.УстановитьПараметр("УчетнаяЗаписьВнешнегоКалендаря", УчетнаяЗаписьВнешнегоКалендаря);
	Запрос.УстановитьПараметр("ВладелецКалендаря", СотрудникиПользователя[0]);
	Запрос.УстановитьПараметр("Яндекс", "caldav.yandex.ru");
	СписокЗадачТекст = НСтр("ru = '(Список задач)'");
	Запрос.УстановитьПараметр("СписокЗадачТекст", СтрШаблон(НСтр("ru = '%1%2'"), Символы.Таб, СписокЗадачТекст));
	РезультатЗапроса = Запрос.Выполнить();
	ТаблицаНастройкаСинхронизации.Загрузить(РезультатЗапроса.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура СохранитьНастройкиDAV()
	
	Если ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.Google Тогда
		Возврат;
	КонецЕсли;
	
	// Создание/Изменение данных Учетной Записи Внешнего Календаря
	Попытка
		
		Если УчетнаяЗаписьВнешнегоКалендаря.Пустая() Тогда
			УчетнаяЗаписьОбъект = Справочники.УчетныеЗаписиВнешнихКалендарей.СоздатьЭлемент();
		Иначе
			УчетнаяЗаписьОбъект = УчетнаяЗаписьВнешнегоКалендаря.ПолучитьОбъект();
		КонецЕсли;
		УчетнаяЗаписьОбъект.Заблокировать();
		УчетнаяЗаписьОбъект.Наименование = Логин;
		УчетнаяЗаписьОбъект.Пользователь = Пользователи.ТекущийПользователь();
		УчетнаяЗаписьОбъект.Провайдер = ВнешнийСервисТекущий;
		УчетнаяЗаписьОбъект.КаталогКалендарей = ДанныеАвторизации.КаталогКалендарей;
		УчетнаяЗаписьОбъект.Сервер = ДанныеАвторизации.Сервер;
		УчетнаяЗаписьОбъект.Статус = Истина;
		УчетнаяЗаписьОбъект.Записать();
		УчетнаяЗаписьОбъект.Разблокировать();
		
		Если УчетнаяЗаписьВнешнегоКалендаря.Пустая() Тогда
			УчетнаяЗаписьВнешнегоКалендаря = УчетнаяЗаписьОбъект.Ссылка;
		КонецЕсли;
		
		УстановитьПривилегированныйРежим(Истина);
		ОбщегоНазначения.ЗаписатьДанныеВБезопасноеХранилище(УчетнаяЗаписьОбъект.Ссылка, Пароль);
		УстановитьПривилегированныйРежим(Ложь);
		
		ОбменСВнешнимиКалендарями.ИнициализироватьУзелПланаОбменаДляВнешнихКалендарей();
		
		// + регламент 
		ОбластьДоступа = Перечисления.ОбластиДоступаGoogle.Календарь;
		РегистрыСведений.ЗаданияОбменаСGoogle.ВключитьПоОбластиДоступа(ОбластьДоступа);
		
	Исключение
		ОбщегоНазначения.СообщитьПользователю(ИнформацияОбОшибке());
		ВызватьИсключение;
	КонецПопытки;
	
	// Обновление статуса ранее зарегистрированных синхронизаций
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	ТаблицаНастройкаСинхронизации.Статус КАК Статус,
	|	ТаблицаНастройкаСинхронизации.КодВнешнегоКалендаря
	|	ПОМЕСТИТЬ СписокВсехСинхронизацийКалендарей
	|ИЗ
	|	&ТаблицаНастройкаСинхронизации КАК ТаблицаНастройкаСинхронизации
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкиСинхронизацииСВнешнимиКалендарями.КодВнешнегоКалендаря КАК КодВнешнегоКалендаря,
	|	НастройкиСинхронизацииСВнешнимиКалендарями.УчетнаяЗаписьВнешнегоКалендаря КАК УчетнаяЗаписьВнешнегоКалендаря,
	|	НастройкиСинхронизацииСВнешнимиКалендарями.Статус КАК Статус,
	|	СписокВсехСинхронизацийКалендарей.Статус КАК ОбновленныйСтатус	
	|ИЗ
	|	РегистрСведений.НастройкиСинхронизацииСВнешнимиКалендарями КАК НастройкиСинхронизацииСВнешнимиКалендарями
	|	ВНУТРЕННЕЕ СОЕДИНЕНИЕ СписокВсехСинхронизацийКалендарей КАК СписокВсехСинхронизацийКалендарей
	|	ПО НастройкиСинхронизацииСВнешнимиКалендарями.КодВнешнегоКалендаря = СписокВсехСинхронизацийКалендарей.КодВнешнегоКалендаря
	|	И НЕ НастройкиСинхронизацииСВнешнимиКалендарями.Статус = СписокВсехСинхронизацийКалендарей.Статус
	|ГДЕ
	|	НастройкиСинхронизацииСВнешнимиКалендарями.УчетнаяЗаписьВнешнегоКалендаря = &УчетнаяЗаписьВнешнегоКалендаря");
	
	Запрос.УстановитьПараметр("ТаблицаНастройкаСинхронизации", ТаблицаНастройкаСинхронизации.Выгрузить());
	Запрос.УстановитьПараметр("УчетнаяЗаписьВнешнегоКалендаря", УчетнаяЗаписьВнешнегоКалендаря);
	РезультатЗапроса = Запрос.Выполнить();
	СписокИзмененныхСинхронизаций = РезультатЗапроса.Выгрузить();
	
	Для каждого Синхронизация Из СписокИзмененныхСинхронизаций Цикл
		
		МенеджерЗаписи = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.КодВнешнегоКалендаря = Синхронизация.КодВнешнегоКалендаря;
		МенеджерЗаписи.УчетнаяЗаписьВнешнегоКалендаря = Синхронизация.УчетнаяЗаписьВнешнегоКалендаря.Ссылка;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Выбран() И Не МенеджерЗаписи.Статус = Синхронизация.ОбновленныйСтатус Тогда
			МенеджерЗаписи.Статус = Синхронизация.ОбновленныйСтатус;
			МенеджерЗаписи.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
	Отбор = Новый Структура;
	Отбор.Вставить("Статус", Истина);
	СписокАктивныхСинхронизаций = ТаблицаНастройкаСинхронизации.НайтиСтроки(Отбор);
	
	// Регистрация синхронизаций между календарями сотрудника и внешними календарями
	Для каждого Синхронизация Из СписокАктивныхСинхронизаций Цикл
		Если Синхронизация.НоваяСинхронизация Тогда
			
			СотрудникиПользователя = РегистрыСведений.СотрудникиПользователя.ПолучитьСотрудниковПользователя(Пользователи.ТекущийПользователь());
			НовыйКалендарьСотрудника = Справочники.КалендариСотрудников.СоздатьЭлемент();
			НовыйКалендарьСотрудника.УстановитьНовыйКод();
			НовыйКалендарьСотрудника.Наименование = Синхронизация.DAVКалендарьНаименование;
			НовыйКалендарьСотрудника.Пользователь = Пользователи.ТекущийПользователь();
			НовыйКалендарьСотрудника.ВладелецКалендаря = СотрудникиПользователя[0];
			НовыйКалендарьСотрудника.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
			НовыйКалендарьСотрудника.ОбменДанными.Получатели.Очистить();
			НовыйКалендарьСотрудника.Записать();
			КалендарьСотрудника = НовыйКалендарьСотрудника.Ссылка;
			
			// Регистрация синхронизации между календарями
			МенеджерЗаписи = РегистрыСведений.НастройкиСинхронизацииСВнешнимиКалендарями.СоздатьМенеджерЗаписи();
			МенеджерЗаписи.КалендарьСотрудника = КалендарьСотрудника;
			МенеджерЗаписи.КодВнешнегоКалендаря = Синхронизация.КодВнешнегоКалендаря;
			МенеджерЗаписи.КалендарьDAVНаименование = Синхронизация.DAVКалендарьНаименование;
			МенеджерЗаписи.УчетнаяЗаписьВнешнегоКалендаря = УчетнаяЗаписьВнешнегоКалендаря;
			МенеджерЗаписи.Статус = Синхронизация.Статус;
			МенеджерЗаписи.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура НастроитьЯндекс()
	ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.Яндекс;
	ОбновитьВыбор();
КонецПроцедуры

&НаСервере
Процедура ОбновитьВыбор()
	
	Если ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.Google Тогда
		ВыборСервисGoogle = Истина;
		ВыборСервисICloud = Ложь;
		ВыборСервисMailRu = Ложь;
		ВыборСервисЯндекс = Ложь;
	ИначеЕсли ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.iCloud Тогда
		ВыборСервисGoogle = Ложь;
		ВыборСервисICloud = Истина;
		ВыборСервисMailRu = Ложь;
		ВыборСервисЯндекс = Ложь;
	ИначеЕсли ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.mailru Тогда
		ВыборСервисGoogle = Ложь;
		ВыборСервисICloud = Ложь;
		ВыборСервисMailRu = Истина;
		ВыборСервисЯндекс = Ложь;
	ИначеЕсли ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.Яндекс Тогда
		ВыборСервисGoogle = Ложь;
		ВыборСервисICloud = Ложь;
		ВыборСервисMailRu = Ложь;
		ВыборСервисЯндекс = Истина;
	КонецЕсли;
	
	Элементы.КнопкаДалее.Доступность = ?(ЗначениеЗаполнено(ВнешнийСервисТекущий), Истина, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура НастроитьMailRu()
	ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.mailru;
	ОбновитьВыбор();
КонецПроцедуры

&НаСервере
Процедура НастроитьICloud()
	ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.iCloud;
	ОбновитьВыбор();
КонецПроцедуры

&НаСервере
Процедура НастроитьGoogle()
	ВнешнийСервисТекущий = Перечисления.ТипыСинхронизацииКалендарей.Google; 
	ОбновитьВыбор();
КонецПроцедуры

&НаСервере
Процедура ПолучитьСеансовыеДанныеGoogle()
	
	ОтключенныеОбластиДоступа = РегистрыСведений.СеансовыеДанныеGoogle.ОтключенныеОбластиДоступа(
	Пользователи.АвторизованныйПользователь());
	СинхронизацияКалендаряGoogle = ОтключенныеОбластиДоступа.Найти(
		Перечисления.ОбластиДоступаGoogle.Календарь) = Неопределено;
	ИдентификацияПриложенияGoogle = Константы.ИдентификацияПриложенияGoogle.Получить();
	
КонецПроцедуры

&НаСервере
Функция ПроверитьОбновитьИдентификацияПриложенияGoogle()
	
	ЗначениеКорректно = Истина;
	
	Если Не ПустаяСтрока(ИдентификацияПриложенияGoogle) Тогда
		ТекстОшибки = ОбменСGoogle.ИдентификацияПриложенияGoogleКорректна(ИдентификацияПриложенияGoogle);
		ЗначениеКорректно = ПустаяСтрока(ТекстОшибки);
	КонецЕсли;
	
	Если Не ЗначениеКорректно Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Элементы.ИдентификацияПриложенияGoogle.Имя);
	КонецЕсли;
	
	Возврат ЗначениеКорректно;
	
КонецФункции

&НаКлиенте
Процедура СеансовыеДанныеСGoogleЗавершение(Результат, ДополнительныеПараметры) Экспорт
	ЗаполнитьСтатусСеансовыхДанныхGoogle();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтатусСеансовыхДанныхGoogle()
	
	СеансовыеДанные = РегистрыСведений.СеансовыеДанныеGoogle.СеансовыеДанные(Пользователи.ТекущийПользователь(), Перечисления.ОбластиДоступаGoogle.Календарь);
	Если СеансовыеДанные.Свойство("access_token") И ЗначениеЗаполнено(СеансовыеДанные.access_token) Тогда
		Элементы.ДекорацияСтатусАутентификацииВыполнено.Видимость = Истина;
		Элементы.ДекорацияСтатусАутентификацииНеВыполнено.Видимость = Ложь;
		ТекущийСтатусСеансовыхДанныхGoogle = НСтр("ru = 'Настроено'");
		Элементы.КнопкаДалее.Доступность = Истина;
	Иначе
		Элементы.ДекорацияСтатусАутентификацииВыполнено.Видимость = Ложь;
		Элементы.ДекорацияСтатусАутентификацииНеВыполнено.Видимость = Истина;
		ТекущийСтатусСеансовыхДанныхGoogle = НСтр("ru = 'Не настроено'");
		Элементы.КнопкаДалее.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтраницыШагиНастройкиGoogleПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущийШагСценария = 22 Тогда
		ЗаполнитьСтатусСеансовыхДанныхGoogle();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПроверкаЗаполненияПолейDAV()
	
	Если Сервер <> "" И Логин <> "" И Пароль <> "" Тогда
		Элементы.КнопкаДалее.Доступность = Истина;
	Иначе
		Элементы.КнопкаДалее.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИдентификацияПриложенияGoogleПриИзменении(Элемент)
	
	ИдентификацияПриложенияGoogleПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура ИдентификацияПриложенияGoogleПриИзмененииСервер()
	
	ЗначениеКорректно = Истина;
	
	Если Не ПустаяСтрока(ИдентификацияПриложенияGoogle) Тогда
		ТекстОшибки = ОбменСGoogle.ИдентификацияПриложенияGoogleКорректна(ИдентификацияПриложенияGoogle);
		ЗначениеКорректно = ПустаяСтрока(ТекстОшибки);
	КонецЕсли;
	
	Если ЗначениеКорректно Тогда
		Константы.ИдентификацияПриложенияGoogle.Установить(ИдентификацияПриложенияGoogle);
	Иначе
		ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , Элементы.ИдентификацияПриложенияGoogle.Имя);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

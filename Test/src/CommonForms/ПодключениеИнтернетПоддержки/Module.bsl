///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		ВызватьИсключение НСтр("ru = 'Использование Интернет-поддержки недоступно при работе в модели сервиса.'");
	КонецЕсли;
	
	РежимВводаНастроекКлиентаЛицензирования = Параметры.РежимВводаНастроекКлиентаЛицензирования;
	Если РежимВводаНастроекКлиентаЛицензирования Тогда
		НастройкиСоединенияССерверами =
			ИнтернетПоддержкаПользователейСлужебныйПовтИсп.НастройкиСоединенияССерверамиИПП();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ДанныеАутентификации = ИнтернетПоддержкаПользователей.ДанныеАутентификацииПользователяИнтернетПоддержки();
	Если ДанныеАутентификации <> Неопределено Тогда
		Логин = ДанныеАутентификации.Логин;
	КонецЕсли;
	
	Элементы.ДекорацияНадписьТехническаяПоддержка.Видимость = ОбщегоНазначения.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИПП_АктивизироватьФормуПодключенияИПП" Тогда
		Если Параметр.Активизирована <> Истина Тогда
			Если ВладелецФормы = Неопределено
				Или РежимОткрытияОкна <> РежимОткрытияОкнаФормы.БлокироватьОкноВладельца Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьЭтуФорму", 0.1, Истина);
			ИначеЕсли ЭтотОбъект.ВладелецФормы <> Неопределено Тогда
				Параметр.Активизирована = Истина;
				ПодключитьОбработчикОжидания("АктивизироватьВладельца", 0.1, Истина);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНадписьПодключениеОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openPortal" Тогда
		СтандартнаяОбработка = Ложь;
		ИнтернетПоддержкаПользователейКлиент.ОткрытьГлавнуюСтраницуПортала();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольПриИзменении(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ПриИзмененииСекретныхДанных(Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПарольНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ИнтернетПоддержкаПользователейКлиент.ОтобразитьСекретныеДанные(
		ЭтотОбъект,
		Элемент,
		"Пароль");
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьВосстановленияПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуВосстановленияПароля();
	
КонецПроцедуры

&НаКлиенте
Процедура НадписьНетЛогинаИПароляАвторизацияНажатие(Элемент)
	
	ИнтернетПоддержкаПользователейКлиент.ОткрытьСтраницуРегистрацииНовогоПользователя();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Подключить(Команда)
	
	Если Не ЗаполнениеЛогинаИПароляКорректно() Тогда
		Возврат;
	КонецЕсли;
	
	Если НастройкиСоединенияССерверами = Неопределено Тогда
		НастройкиСоединенияССерверами = ИнтернетПоддержкаПользователейКлиент.НастройкиСоединенияССерверами();
	КонецЕсли;
	
	Состояние(, , НСтр("ru = 'Подключение Интернет-поддержки...'"));
	РезультатАутентификации =
		АутентифицироватьПользователя(
			СокрЛП(Логин),
			Пароль,
			Истина,
			СохранитьБезПроверки);
	Состояние();
	
	Если ПустаяСтрока(РезультатАутентификации.КодОшибки) Тогда
		ПараметрыОповещения = Новый Структура("Логин, Пароль", Логин, "");
		Закрыть(ПараметрыОповещения);
		Оповестить("ИнтернетПоддержкаПодключена", ПараметрыОповещения);
	ИначеЕсли РезультатАутентификации.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
		ПоказатьПредупреждение(, РезультатАутентификации.СообщениеОбОшибке);
	Иначе
		
		// Сетевая или иная ошибка.
		// В этом случае:
		//  - пользователю отображается сообщение об ошибке проверки логина и пароля;
		//  - логин и пароль сохраняются в программе - см. метод АутентифицироватьПользователя().
		
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Логин и пароль сохранены в программе, но проверка корректности
				|логина и пароля не выполнена из-за ошибки:
				|%1'"),
			РезультатАутентификации.СообщениеОбОшибке);
		
		ПоказатьПредупреждение(
			Новый ОписаниеОповещения("ПриСообщенииОбОшибкеПроверкиКорректностиЛогинаИПароля", ЭтотОбъект),
			ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияНадписьТехническаяПоддержкаОбработкаНавигационнойСсылки(
		Элемент,
		НавигационнаяСсылкаФорматированнойСтроки,
		СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "action:openSupport" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Сообщение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не получается подключить Интернет-поддержку пользователей.
				|Для подключения указывается логин %1.'"),
			Элементы.Логин.ТекстРедактирования);
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.СообщенияВСлужбуТехническойПоддержки") Тогда
			
			МодульСообщенияВСлужбуТехническойПоддержкиКлиентСервер =
				ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиентСервер");
			ДанныеСообщения = МодульСообщенияВСлужбуТехническойПоддержкиКлиентСервер.ДанныеСообщения();
			ДанныеСообщения.Получатель = "webIts";
			ДанныеСообщения.Тема = НСтр("ru = 'Интернет-поддержка. Подключение Интернет-поддержки'");
			ДанныеСообщения.Сообщение = Сообщение;
			ДанныеСообщения.НастройкиПоискаГотовогоОтвета.Текст = НСтр("ru = 'Превышено количество попыток аутентификации'");
			
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент =
				ОбщегоНазначенияКлиент.ОбщийМодуль("СообщенияВСлужбуТехническойПоддержкиКлиент");
			МодульСообщенияВСлужбуТехническойПоддержкиКлиент.ОтправитьСообщение(
				ДанныеСообщения);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Общего назначения.

&НаКлиенте
Функция ЗаполнениеЛогинаИПароляКорректно()
	
	Результат = ИнтернетПоддержкаПользователейКлиентСервер.ПроверитьДанныеАутентификации(
		Новый Структура("Логин, Пароль",
		Логин, Пароль));
	
	Если Результат.Отказ Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(
			Результат.СообщениеОбОшибке,
			,
			Результат.Поле);
	КонецЕсли;
	
	Возврат Не Результат.Отказ;
	
КонецФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Знач ДанныеАутентификации)
	
	// Проверка права записи данных
	Если Не ИнтернетПоддержкаПользователей.ПравоЗаписиПараметровИПП() Тогда
		ВызватьИсключение НСтр("ru = 'Недостаточно прав для записи данных аутентификации Интернет-поддержки.'");
	КонецЕсли;
	
	// Запись данных
	УстановитьПривилегированныйРежим(Истина);
	ИнтернетПоддержкаПользователей.СлужебнаяСохранитьДанныеАутентификации(ДанныеАутентификации);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция АутентифицироватьПользователя(
		Знач Логин,
		Знач Пароль,
		Знач ЗапомнитьПароль,
		Знач СохранитьБезПроверки)
	
	Если Не СохранитьБезПроверки Тогда
		РезультатАутентификации =
			ИнтернетПоддержкаПользователей.ПроверитьЛогинИПароль(
				Логин,
				Пароль);
	Иначе
		РезультатАутентификации = Новый Структура(
			"КодОшибки, СообщениеОбОшибке, Результат",
			"",
			"",
			Истина);
	КонецЕсли;
	
	Если РезультатАутентификации.КодОшибки <> "НеверныйЛогинИлиПароль" Тогда
		СохранитьДанныеАутентификации(
			?(ЗапомнитьПароль, Новый Структура("Логин, Пароль", Логин, Пароль), Неопределено));
	КонецЕсли;
	
	Возврат РезультатАутентификации;
	
КонецФункции

&НаКлиенте
Процедура ПриСообщенииОбОшибкеПроверкиКорректностиЛогинаИПароля(ДополнительныеПараметры) Экспорт
	
	ПараметрыОповещения = Новый Структура("Логин, Пароль", Логин, "");
	Закрыть(ПараметрыОповещения);
	Оповестить("ИнтернетПоддержкаПодключена", ПараметрыОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьЭтуФорму()
	
	ЭтотОбъект.Активизировать();
	
КонецПроцедуры

&НаКлиенте
Процедура АктивизироватьВладельца()
	
	ЭтотОбъект.ВладелецФормы.Активизировать();
	
КонецПроцедуры

#КонецОбласти

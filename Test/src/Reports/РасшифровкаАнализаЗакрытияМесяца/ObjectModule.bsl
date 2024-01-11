#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Задать настройки формы отчета.
//
// Параметры:
//  Форма		 - ФормаКлиентскогоПриложения	 - Форма отчета
//  КлючВарианта - Строка						 - Ключ загружаемого варианта
//  Настройки	 - Структура					 - см. ОтчетыКлиентСервер.НастройкиОтчетаПоУмолчанию
//
Процедура ОпределитьНастройкиФормы(Форма, КлючВарианта, Настройки) Экспорт

	Настройки.РазрешеноИзменятьВарианты = Ложь;
	Настройки.РазрешеноИзменятьСтруктуру = Ложь;
	Настройки.События.ПриСозданииНаСервере = Истина;
	Настройки.События.ПриЗагрузкеВариантаНаСервере = Истина;
	Настройки.События.ПриЗагрузкеПользовательскихНастроекНаСервере = Истина;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// Процедура - Обработчик заполнения настроек отчета и варианта
//
// Параметры:
//  НастройкиОтчета		 - Структура - Настройки отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиОтчета 
//  НастройкиВариантов	 - Структура - Настройки варианта отчета, подробнее см. процедуру ОтчетыУНФ.ИнициализироватьНастройкиВарианта
//
Процедура ПриОпределенииНастроекОтчета(НастройкиОтчета, НастройкиВариантов) Экспорт
	
	УстановитьТегиВариантов(НастройкиВариантов);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиСобытий

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - ФормаКлиентскогоПриложения - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "ФормаКлиентскогоПриложения.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	ОтчетыУНФ.ФормаОтчетаПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеВариантаНаСервере
//
// Параметры:
//  Форма			 - ФормаКлиентскогоПриложения	 - Форма отчета
//  НовыеНастройкиКД - НастройкиКомпоновкиДанных	 - Загружаемые настройки КД
//
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПреобразоватьСтарыеНастройки(Форма, НовыеНастройкиКД);	
	ОтчетыУНФ.ФормаОтчетаПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД);
	
КонецПроцедуры

// Обработчик события ПриЗагрузкеПользовательскихНастроекНаСервере
//
// Параметры:
//  Форма							 - ФормаКлиентскогоПриложения				 - Форма отчета
//  НовыеПользовательскиеНастройкиКД - ПользовательскиеНастройкиКомпоновкиДанных - Загружаемые пользовательские
//                                                                                 настройки КД
//
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
	ОтчетыУНФ.ПеренестиПараметрыЗаголовкаВНастройки(КомпоновщикНастроек.Настройки, НовыеПользовательскиеНастройкиКД);	
	
КонецПроцедуры

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	ОтчетыУНФ.ОбъединитьСПользовательскимиНастройками(КомпоновщикНастроек);
	
	НастройкиСКД = КомпоновщикНастроек.Настройки;
	ПараметрДанных = НастройкиСКД.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ВариантРасшифровки"));
	Если ПараметрДанных = Неопределено Тогда
		УдаляемыйОтбор = Неопределено; 
	ИначеЕсли ПараметрДанных.Значение = 0 Тогда
		УдаляемыйОтбор = "Характеристика";
	ИначеЕсли ПараметрДанных.Значение = 1 Тогда
		УдаляемыйОтбор = "Партия";
	ИначеЕсли ПараметрДанных.Значение = 2 Тогда
		УдаляемыйОтбор = "СтруктурнаяЕдиница";
	ИначеЕсли ПараметрДанных.Значение = 3 Тогда
		УдаляемыйОтбор = "ЗаказПокупателя";
	Иначе
		УдаляемыйОтбор = Неопределено; 
	КонецЕсли;
	Если ЗначениеЗаполнено(УдаляемыйОтбор) Тогда
		УдаляемыйОтбор = Новый ПолеКомпоновкиДанных(УдаляемыйОтбор);
	КонецЕсли; 
	
	КУдалению = Новый Массив;
	Для каждого ЭлементОтбора Из НастройкиСКД.Отбор.Элементы Цикл
		Если ТипЗнч(ЭлементОтбора) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли; 
		Если ЭлементОтбора.ЛевоеЗначение = УдаляемыйОтбор Тогда
			КУдалению.Добавить(ЭлементОтбора);
		Иначе
			ЭлементОтбора.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли; 
	КонецЦикла;
	Для каждого ЭлементОтбора Из КУдалению Цикл
		НастройкиСКД.Отбор.Элементы.Удалить(ЭлементОтбора);
	КонецЦикла;
	
	Если ПараметрДанных <> Неопределено И ПараметрДанных.Значение = 3 Тогда
		// Только резервы
		НовыйЭлемент = НастройкиСКД.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйЭлемент.ЛевоеЗначение = УдаляемыйОтбор;
		НовыйЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено;
		НовыйЭлемент.Использование = Истина;
		НовыйЭлемент.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
	КонецЕсли; 
	
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	Для Каждого НастройкиТекВарианта Из НастройкиВариантов Цикл
		НастройкиТекВарианта.Значение.Теги = НСтр("ru = 'Компания'");
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти 

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти 

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
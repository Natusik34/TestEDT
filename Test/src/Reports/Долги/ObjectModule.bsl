#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

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
	ОтчетыУНФ.ОбновитьВидимостьОтбораОрганизация(Форма.Отчет.КомпоновщикНастроек);	
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
	НастроитьКолонкиОтчета();
	
	ОтчетыУНФ.ОбработатьСхемуМультивалютногоОтчета(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки);
	ОтчетыУНФ.ПриКомпоновкеРезультата(КомпоновщикНастроек, СхемаКомпоновкиДанных, ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка);
	
	ОбработатьШапкуИПодвал(ДокументРезультат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТегиВариантов(НастройкиВариантов)
	
	НастройкиВариантов["Долги"].Теги = НСТР("ru = 'Главное,Запасы,Закупки,Продажи,Взаиморасчеты,Долги,Авансы,Контрагенты,Покупатели,Поставщики'");
	
КонецПроцедуры

Процедура НастроитьКолонкиОтчета()
	
	ПараметрСвернутьДолг = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("СвернутьДолг");
	Если ПараметрСвернутьДолг = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПорядокРесурсаНеВСписке = Новый Массив;
	
	Если ПараметрСвернутьДолг.Использование И ПараметрСвернутьДолг.Значение = "ДолгСвернуто" Тогда
		ПорядокРесурсаНеВСписке.Добавить(1);
		ПорядокРесурсаНеВСписке.Добавить(2);
		ПорядокРесурсаНеВСписке.Добавить(6);
		ПорядокРесурсаНеВСписке.Добавить(7);
	Иначе
		ПорядокРесурсаНеВСписке.Добавить(3);
		ПорядокРесурсаНеВСписке.Добавить(8);
	КонецЕсли;
	
	ПолеПорядокРесурса = Новый ПолеКомпоновкиДанных("ПорядокРесурса");
	
	Для Каждого ТекЭлемент Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
		
		Если ТипЗнч(ТекЭлемент) <> Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТекЭлемент.ЛевоеЗначение <> ПолеПорядокРесурса Тогда
			Продолжить;
		КонецЕсли;
		
		ТекЭлемент.ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке;
		ТекЭлемент.ПравоеЗначение = Новый СписокЗначений;
		ТекЭлемент.ПравоеЗначение.ЗагрузитьЗначения(ПорядокРесурсаНеВСписке);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьШапкуИПодвал(ТабличныйДокумент)
	
	ПараметрПериодОтчета = КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("СтПериод"));
	
	Если ПараметрПериодОтчета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для ИндексСтроки = 1 По ТабличныйДокумент.ВысотаТаблицы Цикл
		
		ИмяОбластиНачОст = "";
		ИмяОбластиКонОст = "";
		
		Для ИндексКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
			
			ТекстЗаголовка = ТабличныйДокумент.Область(ИндексСтроки, ИндексКолонки).Текст;
			
			ОбработатьЗаголовокКолонки(ИмяОбластиНачОст, ИндексКолонки, ИндексСтроки, ТабличныйДокумент, ТекстЗаголовка, НСтр("ru = '(нач. ост.)'"));
			
			ОбработатьЗаголовокКолонки(ИмяОбластиКонОст, ИндексКолонки, ИндексСтроки, ТабличныйДокумент, ТекстЗаголовка, НСтр("ru = '(кон. ост.)'"));
			
		КонецЦикла;
		
		УстановитьТекстОбласти(
		ТабличныйДокумент,
		ИмяОбластиНачОст,
		Формат(ПараметрПериодОтчета.Значение.ДатаНачала, "ДЛФ=D"),
		НСтр("ru = 'Начальный остаток'"));
		
		УстановитьТекстОбласти(
		ТабличныйДокумент,
		ИмяОбластиКонОст,
		Формат(ПараметрПериодОтчета.Значение.ДатаОкончания, "ДЛФ=D"),
		НСтр("ru = 'Конечный остаток'"));
		
		Если ЗначениеЗаполнено(ИмяОбластиНачОст)
			Или ЗначениеЗаполнено(ИмяОбластиКонОст) Тогда
			
			ОчиститьИтогиДвижений(ТабличныйДокумент, ИндексСтроки);
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьЗаголовокКолонки(ИмяОбласти, ИндексКолонки, ИндексСтроки, ТабличныйДокумент, ТекстЗаголовка, Суффикс)
	
	Если СтрНайти(ТекстЗаголовка, Суффикс) = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ИмяОбласти)
		И СтрНайти(ИмяОбласти, ":") = 0 Тогда
		ИмяОбласти = СтрШаблон("%1:R%2C%3", ИмяОбласти, ИндексСтроки, ИндексКолонки);
	Иначе
		ИмяОбласти = СтрШаблон("R%1C%2", ИндексСтроки, ИндексКолонки);
	КонецЕсли;
	
	ТабличныйДокумент.Область(ИндексСтроки + 1, ИндексКолонки).Текст = СтрЗаменить(ТекстЗаголовка, Суффикс, "");
	
КонецПроцедуры

Процедура УстановитьТекстОбласти(ТабличныйДокумент, ИмяОбласти, Текст, ТекстПоУмолчанию)
	
	Если Не ЗначениеЗаполнено(ИмяОбласти) Тогда
		Возврат;
	КонецЕсли;
	
	Если СтрНайти(ИмяОбласти, ":") <> 0 Тогда
		ТабличныйДокумент.Область(ИмяОбласти).Объединить();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Текст) Тогда
		ТабличныйДокумент.Область(ИмяОбласти).Текст = Текст;
	Иначе
		ТабличныйДокумент.Область(ИмяОбласти).Текст = ТекстПоУмолчанию;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьИтогиДвижений(ТабличныйДокумент, ИндексСтрокиШапки)
	
	Для ИндексКолонки = 1 По ТабличныйДокумент.ШиринаТаблицы Цикл
		
		ТекстЗаголовка = ТабличныйДокумент.Область(ИндексСтрокиШапки, ИндексКолонки).Текст;
		
		Если СтрНачинаетсяС(ТекстЗаголовка, "Увеличение") Или СтрНачинаетсяС(ТекстЗаголовка, "Уменьшение") Тогда
			
			ТабличныйДокумент.Область(ТабличныйДокумент.ВысотаТаблицы, ИндексКолонки).Текст = "";
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ЭтоОтчетУНФ = Истина;

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли
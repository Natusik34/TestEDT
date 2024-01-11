&НаСервере
Перем КонтекстЭДОСервер Экспорт;

&НаКлиенте
Перем КонтекстЭДОКлиент Экспорт;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Основание = Параметры.Основание;
	
	Если НЕ ЗначениеЗаполнено(Основание) Тогда
		РезультатОткрытия = Новый Структура("Предупреждение", "Не выбран запрос!");
		Возврат;
	КонецЕсли;
	
	СтруктураРеквизитовФормы = Новый Структура;
	СтруктураРеквизитовФормы.Вставить("СписокПечатаемыхЛистов");
	СтруктураРеквизитовФормы.Вставить("мПечатныеФормы");
	СтруктураРеквизитовФормы.Вставить("мРежимПечати");
	СтруктураРеквизитовФормы.СписокПечатаемыхЛистов = Новый СписокЗначений;
	СтруктураРеквизитовФормы.мПечатныеФормы = Новый СписокЗначений;
	СтруктураРеквизитовФормы.мРежимПечати = Истина;
	
	// инициализируем контекст ЭДО - модуль обработки
	КонтекстЭДОСервер = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.ЗапросНаИнформационноеОбслуживаниеСтрахователя") Тогда
		
		Ответы = КонтекстЭДОСервер.ПолучитьОтветыНаЗапросИОС(Основание, Истина);
		Если НЕ ЗначениеЗаполнено(Ответы) Тогда
			РезультатОткрытия = Новый Структура("Предупреждение", "Не найдено приложение!");
			Возврат;
		КонецЕсли;
		
		ИмяФайлаОтвета = Ответы[0].ИмяФайла;
		ДанныеФайлаОтвета = Ответы[0].Данные;
		
	Иначе
		
		СодержимоеОтветы = КонтекстЭДОСервер.ПолучитьВложенияТранспортногоСообщения(Основание, Истина, Перечисления.ТипыСодержимогоТранспортногоКонтейнера.ОтветПриложениеНаЗапросПФР);
		Если СодержимоеОтветы.Количество() = 0 Тогда
			РезультатОткрытия = Новый Структура("Предупреждение", "Не найдено приложение!");
			Возврат;
		КонецЕсли;
		СодержимоеОтвет = СодержимоеОтветы[0];
		
		ИмяФайлаОтвета = СодержимоеОтвет.ИмяФайла;
		ДанныеФайлаОтвета = СодержимоеОтвет.Данные;
		
	Конецесли;
	
	Если НЕ ЗначениеЗаполнено(ДанныеФайлаОтвета) Тогда
		РезультатОткрытия = Новый Структура("Предупреждение", "Ответ пуст!");
		Возврат;
	КонецЕсли;
	
	// загружаем ответ в дерево
	ФайлОтвета = ПолучитьИмяВременногоФайла();
	ДанныеФайлаОтвета.Получить().Записать(ФайлОтвета);
	ДеревоОтвета = КонтекстЭДОСервер.ЗагрузитьXMLВДеревоЗначений(ФайлОтвета);
	УдалитьФайлы(ФайлОтвета);
	Если ДеревоОтвета = Неопределено Тогда
		РезультатОткрытия = Новый Структура("Предупреждение", "Неизвестный формат файла ответа!");
		Возврат;
	КонецЕсли;
	
	РегистрационныйНомер = ПолучитьЗначениеИзДерева(ДеревоОтвета, "регистрационныйНомерПлательщика");
	ПолноеНаименованиеОрганизации = ПолучитьЗначениеИзДерева(ДеревоОтвета, "наименованиеПлательщика");
	
	// ищем реквизит наДату
	УзелНаДату = ДеревоОтвета.Строки.Найти("наДату", "Имя", Истина);
	Если ЗначениеЗаполнено(УзелНаДату) Тогда
		ДатаНа = XMLЗначение(Тип("Дата"), УзелНаДату.Значение);
		Если ЗначениеЗаполнено(ДатаНа) Тогда
			ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " по состоянию на " + Формат(ДатаНа, "ДФ=dd.MM.yyyy");
		КонецЕсли;
	КонецЕсли;
	
	// ищем узел списокЗастрахованныхЛиц
	УзелСписокЗастрахованныхЛиц = ДеревоОтвета.Строки.Найти("списокЗастрахованныхЛиц", "Имя", Истина);
	Если НЕ ЗначениеЗаполнено(УзелСписокЗастрахованныхЛиц) Тогда
		РезультатОткрытия = Новый Структура("Предупреждение", "Некорректная структура файла ответа: не обнаружен узел ""списокЗастрахованныхЛиц""!");
		Возврат;
	КонецЕсли;
	
	// ищем узлы застрахованноеЛицо
	УзлыЗастрахованноеЛицо = УзелСписокЗастрахованныхЛиц.Строки.НайтиСтроки(Новый Структура("Имя", "застрахованноеЛицо"), Истина);
	Для Каждого УзелЗастрахованноеЛицо Из УзлыЗастрахованноеЛицо Цикл
		
		// определяем ФИО
		УзелФИО = УзелЗастрахованноеЛицо.Строки.Найти("ФИО", "Имя");
		Если ЗначениеЗаполнено(УзелФИО) Тогда
			
			УзелФамилия = УзелФИО.Строки.Найти("Фамилия", "Имя");
			УзелИмя = УзелФИО.Строки.Найти("Имя", "Имя");
			УзелОтчество = УзелФИО.Строки.Найти("Отчество", "Имя");
			
			Фамилия = ?(УзелФамилия = Неопределено, "", СокрЛП(УзелФамилия.Значение));
			Имя = ?(УзелИмя = Неопределено, "", СокрЛП(УзелИмя.Значение));
			Отчество = ?(УзелОтчество = Неопределено, "", СокрЛП(УзелОтчество.Значение));
			
			ФИО = СокрЛП(Фамилия + " " + Имя + " " + Отчество);
			
		Иначе
			
			Фамилия = "";
			Имя = "";
			Отчество = "";
			
			ФИО = "";
			
		КонецЕсли;
		
		// определяем страховой номер
		УзелСтраховойНомер = УзелЗастрахованноеЛицо.Строки.Найти("страховойНомер", "Имя");
		СтраховойНомер = ?(УзелСтраховойНомер = Неопределено, "", СокрЛП(УзелСтраховойНомер.Значение));
		
		// определяем дату рождения
		УзелДатаРождения = УзелЗастрахованноеЛицо.Строки.Найти("датаРождения", "Имя");
		ДатаРождения = ?(УзелДатаРождения = Неопределено, '00010101', КонтекстЭДОСервер.ДатаИзСтроки(УзелДатаРождения.Значение));
		
		// определяем результат
		УзелРезультатСверки = УзелЗастрахованноеЛицо.Строки.Найти("результатСверки", "Имя");
		РезультатСверки = ?(УзелРезультатСверки = Неопределено, "", КодРезультатаСверкиПоСтрокеРезультата(УзелРезультатСверки.Значение));
		
		// добавляем строку в таблицу
		НовСтр = ЗастрахованныеЛица.Добавить();
		НовСтр.ФИО = ФИО;
		НовСтр.СНИЛС = СтраховойНомер;
		НовСтр.ДатаРождения = ДатаРождения;
		НовСтр.РезультатПроверки = РезультатСверки;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТекстПредупреждения = "";
	Если ЗначениеЗаполнено(РезультатОткрытия) И РезультатОткрытия.Свойство("Предупреждение", ТекстПредупреждения) Тогда
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПриОткрытииЗавершение", ЭтотОбъект);
	
	ДокументооборотСКОКлиент.ПолучитьКонтекстЭДО(ОписаниеОповещения);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗастрахованныеЛицаПриИзменении(Элемент)
	
	ПронумероватьСтроки();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Печать(Команда)
	
	Состояние(СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1. Формируется печатная форма...'"), ЭтаФорма.Заголовок), , , БиблиотекаКартинок.Печать);
	
	ТабличныйДокумент = ПечатьНаСервере("ПечататьБланк"); 

	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#Иначе
		ЭтоВебКлиент = Ложь;
	#КонецЕсли
	
	ЦиклОбмена = Основание;
	ПечатныеДокументы 	= Новый СписокЗначений;
	ПечатныеДокументы.Вставить(0, ТабличныйДокумент, "Справка о состоянии расчетов");
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ЦиклОбмена",			ЦиклОбмена);
	СтруктураПараметров.Вставить("ПечатныеДокументы", 	ПечатныеДокументы);
	СтруктураПараметров.Вставить("ВидПечати", 			"ПечататьБланк");
	СтруктураПараметров.Вставить("ЭтоВебКлиент", 		ЭтоВебКлиент);

	ОткрытьФорму(ПутьКОбъекту + ".Форма.ПредварительныйПросмотрПечатныхФорм", СтруктураПараметров,,Новый УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция КодРезультатаСверкиПоСтрокеРезультата(СтрокаРезультата)
	
	Если СтрНайти(СтрокаРезультата, "FAM") <> 0 Тогда
		Возврат 1;
	ИначеЕсли СтрНайти(СтрокаРезультата, "NAM") <> 0 Тогда
		Возврат 2;
	ИначеЕсли СтрНайти(СтрокаРезультата, "PTR") <> 0 Тогда
		Возврат 3;
	ИначеЕсли СтрНайти(СтрокаРезультата, "FIO") <> 0 Тогда
		Возврат 4;
	Иначе
		Возврат СтрокаРезультата;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытииЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	КонтекстЭДОКлиент = Результат.КонтекстЭДО;
	ПутьКОбъекту = КонтекстЭДОКлиент.ПутьКОбъекту;
	
КонецПроцедуры

&НаСервере
Процедура ПронумероватьСтроки()
	
	Для Каждого Стр Из ЗастрахованныеЛица Цикл
		Стр.Номер = ЗастрахованныеЛица.Индекс(Стр) + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПечатьНаСервере(ВидПечати)
	
	ТабДок 			= Новый ТабличныйДокумент;	
	МакетСверки 	= ПолучитьМакетОбработки("СверкаФИОиСНИЛС");	
	Шапка 			= МакетСверки.ПолучитьОбласть("Шапка");
	Подвал 			= МакетСверки.ПолучитьОбласть("Подвал");

	ТабДок.Очистить();
	
	// заполняем шапку
	Шапка.Параметры.ДатаДокумента 					= Формат(ДатаНа,"ДЛФ=DD");
	Шапка.Параметры.РегистрационныйНомер 			= РегистрационныйНомер;
	Шапка.Параметры.ПолноеНаименованиеОрганизации 	= ПолноеНаименованиеОрганизации;
	ТабДок.Вывести(Шапка);
	
	// заполняем таблицу
	Для каждого СтрокаПоЗастрахованномуЛицу Из ЗастрахованныеЛица Цикл
		СтрокаТаблицы 	= МакетСверки.ПолучитьОбласть("СтрокаТаблицы");
		СтрокаТаблицы.Параметры.Заполнить(СтрокаПоЗастрахованномуЛицу);
		
		// изменяем текст ошибки в соответствии с условным оформлением
		ТекстСообщения = "";
		Если СтрокаПоЗастрахованномуЛицу.РезультатПроверки = "1" Тогда 
			ТекстСообщения = "Не сравнилась фамилия";
		ИначеЕсли СтрокаПоЗастрахованномуЛицу.РезультатПроверки = "2" Тогда 	
			ТекстСообщения = "Не сравнилось имя";
		ИначеЕсли СтрокаПоЗастрахованномуЛицу.РезультатПроверки = "3" Тогда 	
			ТекстСообщения = "Не сравнилось отчество";	
		ИначеЕсли СтрокаПоЗастрахованномуЛицу.РезультатПроверки = "4" Тогда 	
			ТекстСообщения = "Не сравнилось ФИО";
		КонецЕсли;	
		
		Если НЕ ПустаяСтрока(ТекстСообщения) Тогда
			СтрокаТаблицы.Параметры.РезультатПроверки = ТекстСообщения;	
		КонецЕсли;	
					
		ТабДок.Вывести(СтрокаТаблицы);
	КонецЦикла; 
	
	// выводим подвал
	ТабДок.Вывести(Подвал);
	ТабДок.АвтоМасштаб = Истина;
	
	Возврат ТабДок;
	
КонецФункции	

&НаСервереБезКонтекста
Функция ПолучитьМакетОбработки(ИмяМакета)
	ОбработкаЭДО = ДокументооборотСКО.ПолучитьОбработкуЭДО();
	Возврат ОбработкаЭДО.ПолучитьМакет(ИмяМакета);
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗначениеИзДерева(Дерево, НаименованиеУзла)
	
	Узел = Дерево.Строки.Найти(НаименованиеУзла, "Имя", Истина);
	Если Узел = Неопределено Тогда
		Возврат Неопределено;
	Иначе 
		Возврат Узел.Значение;
	КонецЕсли;	

КонецФункции

#КонецОбласти
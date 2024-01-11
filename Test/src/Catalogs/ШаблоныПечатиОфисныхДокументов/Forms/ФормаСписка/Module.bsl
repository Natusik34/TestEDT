
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ФормаЗаполнитьПоставляемыеШаблоныДоговоровКонтрагентов.Видимость =
		Константы.ПредложитьЗаполнитьПоставляемыеШаблоныДоговоровКонтрагентов.Получить();
	Элементы.ФормаЗаполнитьПоставляемыеШаблоныКоммерческогоПредложения.Видимость = 
		Константы.ПредложитьЗаполнитьПоставляемыеШаблоныКоммерческогоПредложения.Получить();
	
	Если Параметры.Свойство("Отбор") И Параметры.Отбор.Свойство("Назначение") Тогда
		Назначение = Параметры.Отбор.Назначение;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Назначение) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Назначение", Назначение, ВидСравненияКомпоновкиДанных.Равно);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбора(Список.Отбор, "Назначение");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьСнятьПометкуИспользуется(Команда)
	
	Если Элементы.Список.ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Шаблоны = Элементы.Список.ВыделенныеСтроки;
	ШаблонУстановитьСнятьПометкуИспользуется(Шаблоны);
	
	ОповеститьОбИзменении(Элементы.Список.ТекущиеДанные.Ссылка);
	Оповестить(
		"Запись_ШаблоныПечатиОфисныхДокументов",
		Новый Структура("ЭтоНовый,Назначение", Истина, Элементы.Список.ТекущиеДанные.Назначение));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоставляемыеШаблоныДоговоровКонтрагентов(Команда)
	
	ЗаполнитьПоставляемыеШаблоныДоговоровКонтрагентовНаСервере();
	ОповеститьОбИзменении(Тип("СправочникСсылка.ШаблоныПечатиОфисныхДокументов"));
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоставляемыеШаблоныКоммерческогоПредложения(Команда)
	
	ЗаполнитьПоставляемыеШаблоныКоммерческогоПредложенияНаСервере();
	ОповеститьОбИзменении(Тип("СправочникСсылка.ШаблоныПечатиОфисныхДокументов"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ШаблонУстановитьСнятьПометкуИспользуется(Шаблоны)
	
	Для каждого ШаблонСсылка Из Шаблоны Цикл
		ШаблонОбъект = ШаблонСсылка.ПолучитьОбъект();
		ШаблонОбъект.Используется = НЕ ШаблонОбъект.Используется;
		ШаблонОбъект.Записать();
	КонецЦикла;
	
	ОбновитьПовторноИспользуемыеЗначения();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоставляемыеШаблоныДоговоровКонтрагентовНаСервере()
	
	ШаблоныПечатиОфисныхДокументов.СоздатьПредопределенныеШаблоныДоговоровКонтрагентов();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоставляемыеШаблоныКоммерческогоПредложенияНаСервере()
	
	ШаблоныПечатиОфисныхДокументов.СоздатьПредопределенныеШаблоныКоммерческогоПредложения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		ОтборОрганизация = Параметры.Организация;
		ОтборПриИзменении(ЭтотОбъект, "Организация", ОтборОрганизация);
	КонецЕсли;
	
	Если Параметры.Свойство("Требования") Тогда
		ОтборТребования = Параметры.Требования;
		Если ОтборТребования <> Неопределено Тогда
			ОтборПриИзменении(ЭтотОбъект, "Ссылка", ОтборТребования, ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;
	КонецЕсли;
	
	ОтборВидДокумента.Вставить(0, "Требование о представлении документов по камеральной проверке");
	ОтборВидДокумента.Вставить(1, "Требование о представлении документов по выездной проверке");
	
	ВидыДокумента = Параметры.ВидыДокумента;
	Список.Параметры.УстановитьЗначениеПараметра("ВидыДокумента", ВидыДокумента);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборОрганизацияПриИзменении(Элемент)
	
	ОтборПриИзменении(ЭтотОбъект, "Организация", ОтборОрганизация);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтборВидДокументаПриИзменении(Элемент)
	
	ОтборПриИзменении(ЭтотОбъект, "ВидДокумента", Элемент.ТекстРедактирования);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьОтборСписка(ОтборСписка, СтрокаЛевоеЗначение, ПравоеЗначение, ВидСравнения = Неопределено)
	
	ЛевоеЗначение = Новый ПолеКомпоновкиДанных(СтрокаЛевоеЗначение);
	
	Если ВидСравнения = Неопределено Тогда
		ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	
	ОтборУстановлен = Ложь;
	Для Каждого ЭлементОтбора Из ОтборСписка.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = ЛевоеЗначение Тогда
			ЭлементОтбора.Использование = Истина;
			ЭлементОтбора.ВидСравнения = ВидСравнения;
			ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
			ОтборУстановлен = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Если Не ОтборУстановлен Тогда
		ЭлементОтбора = ОтборСписка.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.ЛевоеЗначение = ЛевоеЗначение;
		ЭлементОтбора.Использование = Истина;
		ЭлементОтбора.ВидСравнения = ВидСравнения;
		ЭлементОтбора.ПравоеЗначение = ПравоеЗначение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтключитьОтборСписка(ОтборСписка, СтрокаЛевоеЗначение)
	
	ЛевоеЗначение = Новый ПолеКомпоновкиДанных(СтрокаЛевоеЗначение);
	
	Для Каждого ЭлементОтбора Из ОтборСписка.Элементы Цикл
		Если ЭлементОтбора.ЛевоеЗначение = ЛевоеЗначение Тогда
			ЭлементОтбора.Использование = Ложь;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОтборПриИзменении(Форма, СтрокаЛевоеЗначение, ПравоеЗначение, ВидСравнения = Неопределено)
	
	СписокОтбор = Форма.Список.КомпоновщикНастроек.Настройки.Отбор;
	
	Если ЗначениеЗаполнено(ПравоеЗначение) Тогда
		УстановитьОтборСписка(СписокОтбор, СтрокаЛевоеЗначение, ПравоеЗначение, ВидСравнения);
	Иначе
		ОтключитьОтборСписка(СписокОтбор, СтрокаЛевоеЗначение);
	КонецЕсли;
	
	СписокОтбор.ИдентификаторПользовательскойНастройки = Строка(Новый УникальныйИдентификатор);

КонецПроцедуры

#КонецОбласти
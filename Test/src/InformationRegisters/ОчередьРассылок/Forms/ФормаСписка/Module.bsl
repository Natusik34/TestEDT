
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВизуализироватьОтборПоМассовойРассылке(Параметры);
	Если ЗначениеЗаполнено(МассоваяРассылка) Тогда
		СервисМассовойРассылки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(МассоваяРассылка, "СервисМассовойРассылки");
	КонецЕсли;
	ОтобразитьСостояниеЗаданияВЗаголовкеФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.Событие
		И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Событие) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элемент.ТекущиеДанные.Событие);
		Возврат;
	КонецЕсли;
	
	Если Поле = Элементы.МассоваяРассылка
		И ЗначениеЗаполнено(Элемент.ТекущиеДанные.МассоваяРассылка) Тогда
		СтандартнаяОбработка = Ложь;
		ПоказатьЗначение(, Элемент.ТекущиеДанные.МассоваяРассылка);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьМассовуюРассылку(Команда)
	ПоказатьЗначение(, МассоваяРассылка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтобразитьСостояниеЗаданияВЗаголовкеФормы()
	
	Если ЗначениеЗаполнено(СервисМассовойРассылки) Тогда
		Заголовок = НСтр("ru='Задания используются только для рассылок 1С:УНФ'");
		Возврат;
	КонецЕсли;
	
	Если Не РегистрыСведений.ОчередьРассылок.ЗаданиеЗапланировано() Тогда
		Заголовок = НСтр("ru = 'Задание не запланировано'");
		Возврат;
	КонецЕсли;
	
	Если РегистрыСведений.ОчередьРассылок.ЗаданиеУжеВыполняется() Тогда
		Заголовок = НСтр("ru = 'Задание выполняется'");
		Возврат;
	КонецЕсли;
	
	Заголовок = НСтр("ru = 'Задание запланировано'");
	
КонецПроцедуры

&НаСервере
Процедура ВизуализироватьОтборПоМассовойРассылке(Параметры)
	
	Если Не Параметры.Свойство("Отбор") Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Отбор) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Отбор.Свойство("МассоваяРассылка") Тогда
		Возврат;
	КонецЕсли;
	
	МассоваяРассылка = Параметры.Отбор.МассоваяРассылка;
	Элементы.МассоваяРассылка.Видимость = Ложь;
	Элементы.ОткрытьМассовуюРассылку.Видимость = Истина;
	Элементы.ОткрытьМассовуюРассылку.Заголовок = МассоваяРассылка;
	
КонецПроцедуры

#КонецОбласти
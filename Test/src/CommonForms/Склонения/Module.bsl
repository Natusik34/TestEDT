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
	
	Если Параметры.Свойство("Склонения") И Параметры.Склонения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.Склонения);
		Склонения = Параметры.Склонения;
	КонецЕсли;
	
	ПараметрыСклонения = Неопределено;
	Параметры.Свойство("ПараметрыСклонения", ПараметрыСклонения);
	
	Если ПараметрыСклонения = Неопределено Тогда
		ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	КонецЕсли;
	
	ЭтоФИО = ПараметрыСклонения.ЭтоФИО;
	Пол = ПараметрыСклонения.Пол;
	
	Если Параметры.Свойство("Представление") Тогда
		Представление = Параметры.Представление;
	КонецЕсли;
	
	Если Параметры.Свойство("ИзмененоПредставление") Тогда
		ИзмененоПредставление = Параметры.ИзмененоПредставление;
	КонецЕсли;
	
	ОбновитьГруппуИнформационнаяНадписьСервисСклонения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ИзмененоПредставление Или Склонения = Неопределено Тогда
		НачатьСклонение(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	СтруктураСклонения = СклонениеПредставленийОбъектовКлиентСервер.СтруктураСклонения();
	ЗаполнитьЗначенияСвойств(СтруктураСклонения, ЭтотОбъект);
	
	Закрыть(СтруктураСклонения);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаПросклонятьПовторно(Команда)
	
	НачатьСклонение(Истина);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура НачатьСклонение(ПоказыватьСообщения)
	
	ЗаполнитьСклонениеПоУмолчанию();
	
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ЗавершитьСклонение", ЭтотОбъект);
	
	ПараметрыСклонения = СклонениеПредставленийОбъектовКлиентСервер.ПараметрыСклонения();
	ПараметрыСклонения.ЭтоФИО = ЭтоФИО;
	ПараметрыСклонения.Пол = Пол;
	СклонениеПредставленийОбъектовКлиент.НачатьСклонение(ЭтотОбъект, Представление, ПараметрыСклонения, ПоказыватьСообщения, ОповещениеОЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьСклонение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если Склонения <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Склонения);
	КонецЕсли;
	
	ОбновитьГруппуИнформационнаяНадписьСервисСклонения();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьГруппуИнформационнаяНадписьСервисСклонения()
	
	Элементы.ГруппаИнформационнаяНадписьНедоступностьСервиса.Видимость = Ложь;
	
	ИспользоватьСервисСклонения = Константы.ИспользоватьСервисСклоненияMorpher.Получить();
	Если Не ИспользоватьСервисСклонения Тогда
		Возврат;
	КонецЕсли;
	
	Если Не СклонениеПредставленийОбъектов.ДоступенСервисСклонения() Тогда
		Элементы.ГруппаИнформационнаяНадписьНедоступностьСервиса.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСклонениеПоУмолчанию()
	
	Именительный = Представление;
	Родительный = Представление;
	Дательный = Представление;
	Винительный = Представление;
	Творительный = Представление;
	Предложный = Представление;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Элементы.Подразделение.Видимость = ИнтеграцияИС.ИспользоватьОбособленныеПодразделенияВыделенныеНаБаланс();
	
КонецПроцедуры
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПротоколОбмена(Команда)
	
	Если Элементы.Список.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Источник",  ТекущиеДанные.Сообщение);
	ПараметрыФормы.Вставить("Заголовок", СтрШаблон(НСтр("ru = 'Сообщения операции: %1'"), ТекущиеДанные.Операция));
		
	ОткрытьФорму(
		"ОбщаяФорма.ЛогОбменаЗЕРНО",
		ПараметрыФормы,
		ЭтотОбъект,,,,,
		РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

#КонецОбласти
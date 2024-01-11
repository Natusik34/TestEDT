
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КонтактнаяИнформация = Параметры.КонтактнаяИнформация;
	Если Не ПустаяСтрока(Параметры.ЗаголовокКнопки) Тогда
		Элементы.ФормаВыбрать.Заголовок = Параметры.ЗаголовокКнопки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура КонтактнаяИнформацияВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СтрокаКИ = КонтактнаяИнформация.НайтиПоИдентификатору(Значение);
	
	Если СтрокаКИ = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОповеститьОВыборе(СтрокаКИ.Значение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Перем ВыбранноеЗначение;
	
	Если Элементы.КонтактнаяИнформация.ТекущиеДанные <> Неопределено Тогда
		ВыбранноеЗначение = Элементы.КонтактнаяИнформация.ТекущиеДанные.Значение;
	КонецЕсли;
	
	ОповеститьОВыборе(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Пояснение = Параметры.Пояснение;
	Требования = Параметры.Требования;
	КлючТребований = Параметры.КлючТребований;
	
	ВидыТребований = СтрРазделить("Формат,Разрешение,Цветность,Размер", ",");
	Для Каждого ВидТребования Из ВидыТребований Цикл
		Элементы["Группа" + ВидТребования].Видимость = Ложь;
	КонецЦикла;
	
	Для Каждого Требование Из Требования Цикл
		Если ЗначениеЗаполнено(Требование.Значение) Тогда
			Элементы["Группа" + Требование.Ключ].Видимость = Истина;
			Элементы[Требование.Ключ].Заголовок = Требование.Значение;		
		КонецЕсли;
	КонецЦикла;
	
	Если ЗначениеЗаполнено(Пояснение) Тогда
		Элементы.Пояснение.Заголовок = Пояснение;
	Иначе
		Элементы.Пояснение.Видимость = Ложь;
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = КлючТребований;
	
КонецПроцедуры

#КонецОбласти
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("Склад") Тогда
		
		Склад = Параметры.Отбор.Склад;
		
	КонецЕсли;
	
	Если Параметры.Свойство("ЗапретитьИзменениеСклада") Тогда
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ОтборСклад",
			"Видимость", Ложь);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Недействителен",
		Ложь,,,
		Не Элементы.ПоказыватьНедействительных.Пометка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборСкладПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Склад) Тогда
			
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, 
			"Склад",
			Склад,
			ВидСравненияКомпоновкиДанных.Равно,
			,
			Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный);
			
	Иначе
		
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(Список, "Склад");
			
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказыватьНедействительных(Команда)
	
	Элементы.ПоказыватьНедействительных.Пометка = Не Элементы.ПоказыватьНедействительных.Пометка;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Недействителен",
		Ложь,
		,
		,
		Не Элементы.ПоказыватьНедействительных.Пометка);
		
КонецПроцедуры

#КонецОбласти
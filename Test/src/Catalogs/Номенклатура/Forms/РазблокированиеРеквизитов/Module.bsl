
#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ЗаблокированныеРеквизиты = Неопределено Тогда
		
		БлокируемыеРеквизиты = Справочники.Номенклатура.ПолучитьБлокируемыеРеквизитыОбъекта();
		Параметры.ЗаблокированныеРеквизиты = Новый ФиксированныйМассив(БлокируемыеРеквизиты);
		
	КонецЕсли;
	
	Для Каждого Реквизит Из Параметры.ЗаблокированныеРеквизиты Цикл
		
		Элементы[Реквизит].Видимость = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)
	
	РазблокируемыеРеквизиты = Новый Массив;
	
	Для Каждого Реквизит Из Параметры.ЗаблокированныеРеквизиты Цикл
		
		Если Элементы[Реквизит].Видимость И ЭтотОбъект[Реквизит] Тогда
			
			РазблокируемыеРеквизиты.Добавить(Реквизит);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Закрыть(РазблокируемыеРеквизиты);
	
КонецПроцедуры

#КонецОбласти

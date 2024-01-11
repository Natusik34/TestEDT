#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.ИсходныйКлючЗаписи.Пустой() Тогда
		Если РегламентированнаяОтчетностьВызовСервера.ИспользуетсяОднаОрганизация() Тогда
			Запись.Организация = Справочники.Организации.ОрганизацияПоУмолчанию();
		Иначе
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Запись.Организация) Тогда
			Запись.Организация = Справочники.Организации.ОсновнаяОрганизация;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ПолучитьФункциональнуюОпцию("ОтображатьСчетаУчета") Тогда
		НовыйЗаголовок = НСтр("ru = 'При перемещении денежных средств используются переводы в пути'");
		Элементы.ИспользоватьПереводыВПутиПриПеремещенияДенежныхСредств.Заголовок = НовыйЗаголовок;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

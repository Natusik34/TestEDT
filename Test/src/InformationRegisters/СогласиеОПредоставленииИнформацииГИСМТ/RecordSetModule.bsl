#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		
		ИсторияИзменений = СогласиеОПредоставленииИнформацииГИСМТ.ИсторияИзмененийИзХранилища(Запись.ИсторияИзменений);
		
		ДанныеДокумента = ИсторияИзменений.Текущий;
		
		Если ЗначениеЗаполнено(ИсторияИзменений.КИзменению.ХешСумма) Тогда
			ДанныеДокумента = ИсторияИзменений.КИзменению;
		КонецЕсли;
		
		Запись.РазрешеноВсем        = ДанныеДокумента.РазрешеноВсем;
		Запись.ДействителенДо       = ДанныеДокумента.ДействителенДо;
		Запись.ДатаПодписания       = ДанныеДокумента.ДатаПодписания;
		Запись.ДоверенныеИНН        = Новый ХранилищеЗначения(ДанныеДокумента.ДоверенныеИНН);
		Запись.РегистрационныйНомер = ДанныеДокумента.РегистрационныйНомер;
		Запись.Идентификатор        = ДанныеДокумента.Идентификатор;
		Запись.ХешСумма             = ДанныеДокумента.ХешСумма;
		
	КонецЦикла;
	
КонецПроцедуры	

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ПроверяемыеРеквизитыИсключение = Новый Массив;
	ПроверяемыеРеквизитыИсключение.Добавить("ДействителенДо");
	ПроверяемыеРеквизитыИсключение.Добавить("ДатаПодписания");
	ПроверяемыеРеквизитыИсключение.Добавить("РегистрационныйНомер");
	ПроверяемыеРеквизитыИсключение.Добавить("Идентификатор");
	
	Для Каждого Запись Из ЭтотОбъект Цикл
		Если Не ЗначениеЗаполнено(Запись.Идентификатор) Тогда
			Для Каждого РеквизитИсключение Из ПроверяемыеРеквизитыИсключение Цикл
				ИндексСтроки = ПроверяемыеРеквизиты.Найти(РеквизитИсключение);
				Если ИндексСтроки <> Неопределено Тогда
					ПроверяемыеРеквизиты.Удалить(ИндексСтроки);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияРегистраСведений(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецЕсли
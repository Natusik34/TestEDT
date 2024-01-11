
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		
		ЭтаФорма.КоманднаяПанель.ГоризонтальноеПоложение = ГоризонтальноеПоложениеЭлемента.Лево;
		ЭтаФорма.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
		Элементы.ФормаОК.Картинка = БиблиотекаКартинок.Готово;
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры.НастройкиОтображения);
	НачалоРабочегоДня		= Дата(1,1,1, Параметры.НастройкиОтображения.НачалоРабочегоДня, 0,0);
	ОкончаниеРабочегоДня	= Дата(1,1,1, Параметры.НастройкиОтображения.ОкончаниеРабочегоДня, 0,0);
	
	СобытияУНФКлиентСервер.ЗаполнитьСписокВыбораВремени(Элементы.НачалоРабочегоДня, 3600, '00010101000000', '00010101230000');
	СобытияУНФКлиентСервер.ЗаполнитьСписокВыбораВремени(Элементы.ОкончаниеРабочегоДня, 3600, '00010101000000', '00010101230000');
	
	// Нулевое время обозначает конец дня, поэтому поставим его последним элементом
	Элементы.ОкончаниеРабочегоДня.СписокВыбора.Сдвинуть(0, Элементы.ОкончаниеРабочегоДня.СписокВыбора.Количество()-1);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не Модифицированность Тогда
		ОповеститьОВыборе(Неопределено);
		Возврат;
	КонецЕсли;
	
	Если Не ПроверитьКорректность() Тогда
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("НачалоРабочегоДня",		Час(НачалоРабочегоДня));
	Результат.Вставить("ОкончаниеРабочегоДня",	Час(ОкончаниеРабочегоДня));
	Результат.Вставить("ОтображатьТекущуюДату",	ОтображатьТекущуюДату);
	
	ОповеститьОВыборе(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция ПроверитьКорректность()
	
	ЗаполнениеКорректно = Истина;
	
	Если ОкончаниеРабочегоДня < НачалоРабочегоДня Тогда
		ОбщегоНазначенияКлиент.СообщитьПользователю(НСтр("ru='Окончание дня не может быть меньше начала.'"), ,
			"ОкончаниеРабочегоДня");
		ЗаполнениеКорректно = Ложь;
	КонецЕсли;
	
	Возврат ЗаполнениеКорректно;
	
КонецФункции

#КонецОбласти

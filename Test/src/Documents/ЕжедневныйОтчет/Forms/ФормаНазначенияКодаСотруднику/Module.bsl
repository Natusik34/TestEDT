
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Параметры.Свойство("Код", Код);
	Параметры.Свойство("ТипКода", ТипКода);
	
	Если НЕ ЗначениеЗаполнено(Код)
		ИЛИ НЕ ЗначениеЗаполнено(ТипКода) Тогда
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
	Если ТипКода = "Штрихкод" Тогда
		ЗаголовокКода = НСтр("ru='Штрихкод'");
	КонецЕсли;
	
	Если ТипКода = "МагнитныйКод" Тогда
		ЗаголовокКода = НСтр("ru='Номер карты'");
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
		Элементы, "Код", "Заголовок", ЗаголовокКода);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьКодДляСотрудникаНаСервере(Сотрудник, Код, ТипКода);
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура ЗаписатьКодДляСотрудникаНаСервере(Сотрудник, Код, ТипКода)
	
	НачатьТранзакцию();
	Попытка
	
		СотрудникОбъект = Сотрудник.ПолучитьОбъект();
		
		СотрудникОбъект.Заблокировать();
		СотрудникОбъект[ТипКода] = Код;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(СотрудникОбъект, Ложь, Ложь);
		СотрудникОбъект.Разблокировать();
		
		ЗафиксироватьТранзакцию();
	
	Исключение
		
		ОтменитьТранзакцию();
		СообщениеЗаписи = НСтр("ru = 'Назначение сотруднику кода'", ОбщегоНазначения.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СообщениеЗаписи, УровеньЖурналаРегистрации.Ошибка, , , 
			ОбработкаОшибок.ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	
	КонецПопытки;
	
КонецПроцедуры


#КонецОбласти
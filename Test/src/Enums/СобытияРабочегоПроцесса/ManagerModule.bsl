#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция СоответствиеСобытияМетаданнымОснования() Экспорт
	
	Соответствие = Новый Соответствие;
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказаПокупателя,
		Метаданные.Документы.ЗаказПокупателя);
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказНаряда,
		Метаданные.Документы.ЗаказПокупателя);
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказаПоставщику,
		Метаданные.Документы.ЗаказПоставщику);
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаказаНаПроизводство,
		Метаданные.Документы.ЗаказНаПроизводство);
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияСобытия,
		Метаданные.Документы.Событие);
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияЗаданияНаРаботу,
		Метаданные.Документы.ЗаданиеНаРаботу);
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ИзменениеСостоянияРемонта,
		Метаданные.Документы.ПриемИПередачаВРемонт);
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ОшибкаПробитияОнлайнЧеков,
		Метаданные.Справочники.РабочиеМеста);
	
	Соответствие.Вставить(
		Перечисления.СобытияРабочегоПроцесса.ПоступлениеПредоплатыПоЗаказуПокупателя,
		Метаданные.Документы.ЗаказПокупателя);
	
	Возврат Соответствие;
	
КонецФункции

Функция СобытиеРабочегоПроцессаПоИмениОснования(ПолноеИмяОснования) Экспорт
	
	СоответствиеСобытияМетаданнымОснования = СоответствиеСобытияМетаданнымОснования();
	
	Для Каждого КлючИЗначение Из СоответствиеСобытияМетаданнымОснования Цикл
		Если КлючИЗначение.Значение.ПолноеИмя() = ПолноеИмяОснования Тогда
			Возврат КлючИЗначение.Ключ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецЕсли
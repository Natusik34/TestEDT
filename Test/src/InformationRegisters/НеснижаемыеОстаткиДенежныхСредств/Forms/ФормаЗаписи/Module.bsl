
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ЗначенияЗаполнения.Свойство("БанковскийСчетКасса") И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.БанковскийСчетКасса) Тогда
		 Элементы.БанковскийСчетКасса.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Запись.ТипДенежныхСредств) Тогда
		Запись.ТипДенежныхСредств = ПолучитьТипДенежныхСредств(Запись.БанковскийСчетКасса);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БанковскийСчетКассаПриИзменении(Элемент)
	
	УстановитьВидимостьДоступность();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимостьДоступность()
	
	Если ЗначениеЗаполнено(Запись.БанковскийСчетКасса) Тогда
		Если ТипЗнч(Запись.БанковскийСчетКасса) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
			Элементы.Валюта.ТолькоПросмотр = Истина;
			Запись.Валюта = ПолучитьВалютуБанковскогоСчета(Запись.БанковскийСчетКасса);
		Иначе
			Элементы.Валюта.ТолькоПросмотр = Ложь;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьВалютуБанковскогоСчета(БанковскийСчет)
	
	Возврат БанковскийСчет.ВалютаДенежныхСредств;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьТипДенежныхСредств(БанковскийСчетКасса)
	
	ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.ПустаяСсылка");
	
	Если ТипЗнч(БанковскийСчетКасса) = Тип("СправочникСсылка.БанковскиеСчета") Тогда
		ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Безналичные");
	ИначеЕсли ТипЗнч(БанковскийСчетКасса) = Тип("СправочникСсылка.Кассы") Тогда
		ТипДенежныхСредств = ПредопределенноеЗначение("Перечисление.ТипыДенежныхСредств.Наличные");
	КонецЕсли;
	
	Возврат ТипДенежныхСредств;
	
КонецФункции

#КонецОбласти





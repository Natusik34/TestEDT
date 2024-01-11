
#Область СлужебныеПроцедурыИФункции

Функция ОписаниеПодписейДокументаПоИмениОбъекта(ИмяОбъекта, ИмяТипаОбъекта, ИмяТипаМетаданных) Экспорт
	
	ПолноеИмяОбъекта = ИмяТипаОбъекта + "." + ИмяОбъекта;
	
	ОписаниеПодписей = ПодписиДокументов.ОписаниеТаблицыПодписей();
	РеквизитыОбъекта = Метаданные[ИмяТипаМетаданных][ИмяОбъекта].Реквизиты;
	
	ЗаполнитьОписаниеПодписейДокумента(ОписаниеПодписей, РеквизитыОбъекта);
	
	ПроверитьКорректностьЗаполненияОписанияПодписей(РеквизитыОбъекта, ОписаниеПодписей, ПолноеИмяОбъекта);
	
	Возврат ОписаниеПодписей;
	
КонецФункции

// Возвращает соответствие поддерживаемых в системе ролей подписантов.
//
Функция ПредопределенныеИдентификаторыОписанийПодписей() Экспорт
	РолиПодписантов = Новый Массив;
	
	ЗарплатаКадры.ПриОпределенииРолейПодписантов(РолиПодписантов);
	
	ПодписиДокументовПереопределяемый.ПриОпределенииРолейПодписантов(РолиПодписантов);
	
	Возврат РолиПодписантов;
КонецФункции

Процедура ПроверитьКорректностьЗаполненияОписанияПодписей(РеквизитыОбъекта, ОписаниеПодписей, ПолноеИмяОбъекта)

	МассивНеНайденныхРеквизитов = Новый Массив;
	
	Для каждого СтрокаОписания Из ОписаниеПодписей Цикл
		ПроверитьНаличиеРеквизита(РеквизитыОбъекта, СтрокаОписания.ФизическоеЛицо, МассивНеНайденныхРеквизитов);
		ПроверитьНаличиеРеквизита(РеквизитыОбъекта, СтрокаОписания.Должность, МассивНеНайденныхРеквизитов);
		ПроверитьНаличиеРеквизита(РеквизитыОбъекта, СтрокаОписания.ОснованиеПодписи, МассивНеНайденныхРеквизитов);
	КонецЦикла;
	
	Если МассивНеНайденныхРеквизитов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если МассивНеНайденныхРеквизитов.Количество() = 1 Тогда
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'У %1 нет реквизита с именем %2'"), 
			ПолноеИмяОбъекта, 
			МассивНеНайденныхРеквизитов[0]);
	Иначе
		ТекстОшибки = СтрШаблон(
			НСтр("ru = 'У %1 нет реквизитов с именами %2.'"), 
			ПолноеИмяОбъекта, 
			СтрСоединить(МассивНеНайденныхРеквизитов, ", "));
	КонецЕсли;
	
	ТекстОшибки = ТекстОшибки + Символы.ПС + НСтр("ru = 'Необходимо исправить описание реквизитов подписей в менеджере объекта.'");
	
    ВызватьИсключение(ТекстОшибки);

КонецПроцедуры

Процедура ПроверитьНаличиеРеквизита(РеквизитыОбъекта, ИмяРеквизита, МассивНеНайденныхРеквизитов);

	Если РеквизитыОбъекта.Найти(ИмяРеквизита) = Неопределено Тогда
		МассивНеНайденныхРеквизитов.Добавить(ИмяРеквизита);
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьОписаниеПодписейДокумента(ОписаниеПодписей, РеквизитыОбъекта)

	МассивИдентификаторов = ПредопределенныеИдентификаторыОписанийПодписей();
	
	МассивРолейОбъекта = Новый Массив;
	
	Для Каждого СоответствиеИдентификатораПодписи Из МассивИдентификаторов Цикл
		Для каждого ИдентификаторПодписи Из СоответствиеИдентификатораПодписи Цикл
			Если УОбъектаЕстьВсеРеквизитыРоли(РеквизитыОбъекта, ИдентификаторПодписи) Тогда
				МассивРолейОбъекта.Добавить(СоответствиеИдентификатораПодписи);
			КонецЕсли;
		КонецЦикла; 
	КонецЦикла; 

	Для каждого СоответствиеОписаниеРолиПодписанта Из МассивРолейОбъекта Цикл
		Для каждого ОписаниеРолиПодписанта Из СоответствиеОписаниеРолиПодписанта Цикл
			ПодписиДокументов.ДобавитьОписаниеПодписи(ОписаниеПодписей, ОписаниеРолиПодписанта.Значение, ОписаниеРолиПодписанта.Ключ);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

Функция УОбъектаЕстьВсеРеквизитыРоли(РеквизитыОбъекта, ИдентификаторПодписи)
	
	Если РеквизитыОбъекта.Найти(ИдентификаторПодписи.Значение.ФизическоеЛицо) <> Неопределено
		ИЛИ РеквизитыОбъекта.Найти(ИдентификаторПодписи.Значение.Должность) <> Неопределено 
		ИЛИ РеквизитыОбъекта.Найти(ИдентификаторПодписи.Значение.ОснованиеПодписи) <> Неопределено Тогда
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

#КонецОбласти
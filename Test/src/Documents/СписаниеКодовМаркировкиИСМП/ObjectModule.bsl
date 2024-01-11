#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	
	Если Не ДополнительныеСвойства.Свойство("НеЗаполнятьТабличнуюЧасть") Тогда
		Товары.Очистить();
		ШтрихкодыУпаковок.Очистить();
	КонецЕсли;
	
	ТипДанныхЗаполнения = ТипЗнч(ДанныеЗаполнения);
	Если ТипДанныхЗаполнения = Тип("ДокументСсылка.ЗаказНаЭмиссиюКодовМаркировкиСУЗ") Тогда
		ЗаполнитьНепришедшиеКоды(ДанныеЗаполнения);
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ОбработкаЗаполненияДокумента(ЭтотОбъект, ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка);
	
	ЗаполнитьОбъектПоСтатистике();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(ЭтотОбъект);
	
	ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписи);
	
	ИнтеграцияИСПереопределяемый.ПередЗаписьюОбъекта(ЭтотОбъект, Отказ, РежимЗаписи, РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	МассивНепроверяемыхРеквизитов.Добавить("Товары.КоличествоПотребительскихУпаковок");
	
	ЭтоСписаниеПриПоступленииКИЗ = Операция = Перечисления.ВидыОперацийИСМП.СписаниеЭмитированныхКодовМаркировкиПриПоступлении;
	
	Если ОтчетПроизводственнойЛинии Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
	ИначеЕсли ЭтоСписаниеПриПоступленииКИЗ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары");
		МассивНепроверяемыхРеквизитов.Добавить("ДанныеОтчетаПроизводственнойЛинии");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ДанныеОтчетаПроизводственнойЛинии");
	КонецЕсли;
	
	Если ВидПродукции <> Перечисления.ВидыПродукцииИС.АльтернативныйТабак
		И ВидПродукции <> Перечисления.ВидыПродукцииИС.НикотиносодержащаяПродукция Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ВидПервичногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("ДатаПервичногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("НомерПервичногоДокумента");
		МассивНепроверяемыхРеквизитов.Добавить("НаименованиеПервичногоДокумента");
		
	ИначеЕсли ВидПервичногоДокумента <> Перечисления.ВидыПервичныхДокументовИСМП.Прочее Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("НаименованиеПервичногоДокумента");
		
	КонецЕсли;
	
	Если Не ЭтоСписаниеПриПоступленииКИЗ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("GLNОрганизации");
	КонецЕсли;
	
	МассивНепроверяемыхРеквизитов.Добавить("Товары.GTIN");
	
	Если ИнтеграцияИСКлиентСервер.ВидПродукцииИспользуетПередачуОтчетаОбОтбраковкеЧерезСУЗ(ВидПродукции)
		Или ИнтеграцияИСПовтИсп.ЭтоПродукцияМОТП(ВидПродукции)
		Или ЭтоСписаниеПриПоступленииКИЗ Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Товары.ПричинаСписания");
	Иначе
		МассивНепроверяемыхРеквизитов.Добавить("ПричинаСписания");
		МассивНепроверяемыхРеквизитов.Добавить("ПроизводственныйОбъект");
	КонецЕсли;
	
	Если ИнтеграцияИСПовтИсп.ЭтоПродукцияМОТП(ВидПродукции) Тогда
		
		Если ВидПродукции = Перечисления.ВидыПродукцииИС.АльтернативныйТабак
			Или ВидПродукции = Перечисления.ВидыПродукцииИС.НикотиносодержащаяПродукция Тогда
			ПроверитьЗаполнениеАдреса(Отказ);
		КонецЕсли;
		
	ИначеЕсли ИнтеграцияИСПовтИсп.ЭтоПродукцияИСМП(ВидПродукции, Истина) Тогда
		
		МассивНепроверяемыхРеквизитов.Добавить("ПроизводственныйОбъектИдентификатор");
		МассивНепроверяемыхРеквизитов.Добавить("ПроизводственныйОбъектАдресСтрокой"); 
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПроизводственногоЗаказа");
		МассивНепроверяемыхРеквизитов.Добавить("ИдентификаторПроизводственнойЛинии");
		
		Если Не ЭтоСписаниеПриПоступленииКИЗ Тогда
			
			Для Каждого СтрокаТовары Из Товары Цикл
				Если Не ЗначениеЗаполнено(СтрокаТовары.GTIN)
					И Не ЗначениеЗаполнено(СтрокаТовары.Номенклатура) Тогда
					ТекстСообщения = СтрШаблон(
						НСтр(
							"ru = 'В строке %1 табличной части Товары не заполнено поле GTIN'"),
							СтрокаТовары.НомерСтроки);
					ОбщегоНазначения.СообщитьПользователю(ТекстСообщения,
						ЭтотОбъект,
						ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти(
							"Товары", СтрокаТовары.НомерСтроки, "GTIN"),,
						Отказ);
				КонецЕсли;
			КонецЦикла;
		
		КонецЕсли;
		
	КонецЕсли;
	
	ИнтеграцияИСМППереопределяемый.ПриОпределенииОбработкиПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
	Если Не ЭтоСписаниеПриПоступленииКИЗ Тогда
		ИнтеграцияИСМПСлужебный.ПроверитьЗаполнениеШтрихкодовУпаковок(ЭтотОбъект, Отказ);
	КонецЕсли;
	
	ИнтеграцияИСМП.ПроверкаЗаполненияКоличестваПотребительскихУпаковок(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ИнтеграцияИСМП.ЗаписатьСтатусДокументаПоУмолчанию(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ДокументОснование   = Неопределено;
	ИдентификаторЗаявки = Неопределено;
	ШтрихкодыУпаковок.Очистить();
	ИдентификаторПроизводственногоЗаказа = "";
	ИдентификаторПроизводственнойЛинии   = "";
	ДанныеОтчетаПроизводственнойЛинии.Очистить();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ОбработкаЗаполнения

Процедура ЗаполнитьОбъектПоСтатистике()
	
	ДанныеСтатистики = ЗаполнениеОбъектовПоСтатистикеИСМП.ДанныеЗаполненияСписанияКодовМаркировкиИСМП(Организация);
	
	Для Каждого КлючИЗначение Из ДанныеСтатистики Цикл
		ЗаполнениеОбъектовПоСтатистикеИСМП.ЗаполнитьПустойРеквизит(ЭтотОбъект, ДанныеСтатистики, КлючИЗначение.Ключ);
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьНепришедшиеКоды(ДанныеЗаполнения)
	
КонецПроцедуры

#КонецОбласти

#Область ОбработкаПроверкиЗаполнения

Процедура ПроверитьЗаполнениеАдреса(Отказ)
	
	ДанныеСтраны = УправлениеКонтактнойИнформацией.СтранаАдресаКонтактнойИнформации(ПроизводственныйОбъектАдрес);
	
	Если ДанныеСтраны.Ссылка = ПредопределенноеЗначение("Справочник.СтраныМира.Россия") Тогда
		
		ДанныеКИ         = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияВJSON(ПроизводственныйОбъектАдрес);
		СведенияОбАдресе = РаботаСАдресами.СведенияОбАдресе(ДанныеКИ);
		
		Если Не ЗначениеЗаполнено(СведенияОбАдресе.Индекс) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен Индекс в адресе'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПроизводственныйОбъектАдресСтрокой",, Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(СведенияОбАдресе.КодРегиона) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен Код региона в адресе'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПроизводственныйОбъектАдресСтрокой",, Отказ);
		КонецЕсли;
		
	Иначе
		
		Если Не ЗначениеЗаполнено(ДанныеСтраны.Код) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен Код страны в адресе'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПроизводственныйОбъектАдресСтрокой",, Отказ);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПроизводственныйОбъектАдресСтрокой) Тогда
			ТекстСообщения = НСтр("ru = 'Не заполнен адрес'");
			ОбщегоНазначения.СообщитьПользователю(ТекстСообщения, ЭтотОбъект, "ПроизводственныйОбъектАдресСтрокой",, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли
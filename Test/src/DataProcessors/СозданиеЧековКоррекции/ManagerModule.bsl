#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Создаёт 2 чека коррекции: сторно и корректный чек
//
// Параметры:
//  Контекст - 	 данные обработки Создание чеков коррекции 
// 
// Возвращаемое значение:
//   Структура - cодержит свойства:
//     * ЧекКоррекцииСторно - ДокументСсылка.ЧекКоррекции - чек коррекции сторно.
//     * ЧекКоррекции - ДокументСсылка.ЧекКоррекции - чек коррекции.
//
Функция СоздатьЧекиКоррекции(Контекст) Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ЧекКоррекцииСторно");
	Результат.Вставить("ЧекКоррекцииСторноПроведен");
	Результат.Вставить("ЧекСкорректированный");
	Результат.Вставить("ЧекСкорректированныйПроведен");
	
	Если Не Контекст.НеприменениеККТ Тогда
		Если НЕ ЗначениеЗаполнено(Контекст.ЧекСторно) Тогда
			РезультатЧекСторно = ЧекКоррекцииСторно(Контекст);
			Если РезультатЧекСторно <> Неопределено Тогда
				Результат.ЧекКоррекцииСторно 			= РезультатЧекСторно.ЧекКоррекцииСторно;
				Результат.ЧекКоррекцииСторноПроведен 	= РезультатЧекСторно.ЧекПроведен;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Контекст.ЧекСкорректированный) Тогда
		РезультатЧек = ЧекКоррекции(Контекст);
		Если РезультатЧек <> Неопределено Тогда
			Результат.ЧекСкорректированный 			= РезультатЧек.ЧекСкорректированный;
			Результат.ЧекСкорректированныйПроведен 	= РезультатЧек.ЧекПроведен;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЧекКоррекцииСторно(Контекст)
	
	Результат = Новый Структура("ЧекКоррекцииСторно, ЧекПроведен");
	
	ЧекОбъект 	= Документы.ЧекККМКоррекции.СоздатьДокумент();
	ЧекПроведен = Ложь;
	
	ОбщиеПараметры = ОборудованиеЧекопечатающиеУстройстваВызовСервера.ЗагрузитьДанныеФискализацииИзXML(Контекст.ДанныеXMLКорректируемогоЧека);
	
	ЗаполнитьЗначенияСвойств(
		ЧекОбъект,
		Контекст,
		"Дата,
		 | ДатаКоррекции,
		 | ДокументОснование,
		 | ДокументРасчетов, 
		 | ДополнительныйРеквизит,
		 | КассаККМ,
		 | СтруктурнаяЕдиница,
		 | НомерПредписания,
		 | ОписаниеКоррекции,
		 | Организация,
		 | Ответственный,
		 | ТипКоррекции,
		 | Комментарий,
		 | Кассир,
		 | КассирИНН");
	
	ЗаполнитьЗначенияСвойств(
		ЧекОбъект,
		ОбщиеПараметры,
		"АдресМагазина,
		| АдресРасчетов,
		| МестоРасчетов,
		| ПокупательEmail,
		| ПокупательНомер,
		| ПризнакАгента,
		| СистемаНалогообложения");

	ЧекОбъект.ЭтоСторно		= Истина;
	Если ЗначениеЗаполнено(ОбщиеПараметры.Получатель) Тогда
		ЧекОбъект.Покупатель = ОбщиеПараметры.Получатель;
	Иначе
		ЧекОбъект.Покупатель = ОбщиеПараметры.СведенияОПокупателе.Покупатель;
	КонецЕсли;
	Если ЗначениеЗаполнено(ОбщиеПараметры.ПолучательИНН) Тогда
		ЧекОбъект.ПокупательИНН = ОбщиеПараметры.ПолучательИНН;
	Иначе
		ЧекОбъект.ПокупательИНН = ОбщиеПараметры.СведенияОПокупателе.ПокупательИНН;
	КонецЕсли;
	ЧекОбъект.ТипРасчета 	= ТипРасчетаСторно(ОбщиеПараметры.ТипРасчета);
	
	// Позиции чека
	
	// При создании Чека коррекции на основании Чека коррекции НеприменениеККТ, ТЧ ПозицииЧека
	// заполнятся из документа основания, т.к. XML в формате 1.05 не содержит достаточной информации 
	// для формирования Чека коррекции.
	Если ТипЗнч(Контекст.ДокументОснование) = Тип("ДокументСсылка.ЧекККМКоррекции") Тогда
			
			НеприменениеККТ = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Контекст.ДокументОснование, 
																		"НеприменениеККТ");
			
			Если НеприменениеККТ Тогда
				ЗаполнитьПозицииЧекаПоОснованию(ЧекОбъект.ПозицииЧека, Контекст.ДокументОснование);
			Иначе
				ЗаполнитьПозицииЧекаИзXML(ЧекОбъект.ПозицииЧека, ОбщиеПараметры.ПозицииЧека);
			КонецЕсли;
			
		Иначе
			
			ЗаполнитьПозицииЧекаИзXML(ЧекОбъект.ПозицииЧека, ОбщиеПараметры.ПозицииЧека);
			
	КонецЕсли;
	
	// Оплаты
	Для Каждого СтрокаОплаты Из ОбщиеПараметры.ТаблицаОплат Цикл
		
		НоваяСтрока = ЧекОбъект.Оплата.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОплаты);
		
	КонецЦикла;
	
	// Запись чека
	Попытка
		ЧекОбъект.Записать(РежимЗаписиДокумента.Запись);
	Исключение
		СтрокаОшибки = НСтр("ru = 'Не удалось записать чек коррекции сторно по причине:'") + Символы.ПС + ОписаниеОшибки();
		ОбщегоНазначения.СообщитьПользователю(СтрокаОшибки);
		Возврат Неопределено;
	КонецПопытки;
	
	// Потом чек проводится
	Попытка
		Если ЧекОбъект.ПроверитьЗаполнение() Тогда
			ЧекОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
			ЧекПроведен = Истина;
		Иначе
			СтрокаОшибки = НСтр("ru = 'Не удалось провести чек коррекции сторно по причине проверки заполнения'");
			ОбщегоНазначения.СообщитьПользователю(СтрокаОшибки);
		КонецЕсли;
	Исключение
		СтрокаОшибки = НСтр("ru = 'Не удалось провести чек коррекции сторно по причине:'") + Символы.ПС + ОписаниеОшибки();
		ОбщегоНазначения.СообщитьПользователю(СтрокаОшибки);
	КонецПопытки;
	
	Результат.ЧекКоррекцииСторно 	= ЧекОбъект.Ссылка;
	Результат.ЧекПроведен 			= ЧекПроведен;
	
	Возврат Результат;
	
КонецФункции

Функция ЧекКоррекции(Контекст)
	
	Результат = Новый Структура("ЧекСкорректированный, ЧекПроведен");
	
	ЧекОбъект 	= Документы.ЧекККМКоррекции.СоздатьДокумент();
	ЧекПроведен = Ложь;
	
	ЗаполнитьЗначенияСвойств(ЧекОбъект, Контекст);
	
	АдресМагазина = ПечатьДокументовУНФ.КонтактнаяИнформация(Контекст.СтруктурнаяЕдиница, ПредопределенноеЗначение("Справочник.ВидыКонтактнойИнформации.ФактАдресСтруктурнойЕдиницы"));
	
	ЧекОбъект.АдресРасчетов = АдресМагазина;
	ЧекОбъект.МестоРасчетов = Строка(Контекст.СтруктурнаяЕдиница) + " " + АдресМагазина;
	ЧекОбъект.АдресМагазина = АдресМагазина;
	
	ЧекОбъект.Покупатель 	= Контекст.Контрагент;
	ЧекОбъект.ПокупательИНН = Контекст.КонтрагентИНН;
	
	РеквизитыКассира = РозничныеПродажиСервер.ПолучитьРеквизитыКассира(Контекст.Ответственный);
	ЧекОбъект.Кассир          = РеквизитыКассира.ИмяКассира;
	ЧекОбъект.КассирИНН       = РеквизитыКассира.КассирИНН;
	
	// Позиции чека
	Для Каждого ПозицияЧека Из Контекст.ПозицииЧека Цикл
		
		НоваяСтрока = ЧекОбъект.ПозицииЧека.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПозицияЧека);
		
	КонецЦикла;
		
	// Оплаты
	Для Каждого СтрокаОплаты Из Контекст.Оплата Цикл
		
		НоваяСтрока = ЧекОбъект.Оплата.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаОплаты);
		
	КонецЦикла;
	
	// Запись чека
	Попытка
		ЧекОбъект.Записать(РежимЗаписиДокумента.Запись);
	Исключение
		СтрокаОшибки = НСтр("ru = 'Не удалось записать чек коррекции сторно по причине:'") + Символы.ПС + ОписаниеОшибки();
		ОбщегоНазначения.СообщитьПользователю(СтрокаОшибки);
		Возврат Неопределено;
	КонецПопытки;
	
	// Потом чек проводится
	Попытка
		Если ЧекОбъект.ПроверитьЗаполнение() Тогда
			ЧекОбъект.Записать(РежимЗаписиДокумента.Проведение, РежимПроведенияДокумента.Неоперативный);
			ЧекПроведен = Истина;
		Иначе
			СтрокаОшибки = НСтр("ru = 'Не удалось провести чек коррекции по причине проверки заполнения'");
			ОбщегоНазначения.СообщитьПользователю(СтрокаОшибки);
		КонецЕсли;
	Исключение
		СтрокаОшибки = НСтр("ru = 'Не удалось провести чек коррекции по причине:'") + Символы.ПС + ОписаниеОшибки();
		ОбщегоНазначения.СообщитьПользователю(СтрокаОшибки);
	КонецПопытки;
	
	Результат.ЧекСкорректированный 	= ЧекОбъект.Ссылка;
	Результат.ЧекПроведен 			= ЧекПроведен;
	
	Возврат Результат;
	
КонецФункции

Функция ТипРасчетаСторно(ТипРасчета)
	
	Если ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств Тогда
		Возврат Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств
	ИначеЕсли ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратДенежныхСредств Тогда
		Возврат Перечисления.ТипыРасчетаДенежнымиСредствами.ПриходДенежныхСредств
	ИначеЕсли ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.РасходДенежныхСредств Тогда
		Возврат Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратРасходаДенежныхСредств
	ИначеЕсли ТипРасчета = Перечисления.ТипыРасчетаДенежнымиСредствами.ВозвратРасходаДенежныхСредств Тогда
		Возврат Перечисления.ТипыРасчетаДенежнымиСредствами.РасходДенежныхСредств
	КонецЕсли;
	
КонецФункции

Процедура ЗаполнитьПозицииЧекаПоОснованию(ПозицииЧека, Основание)
	
	Для Каждого ПозицияЧека Из Основание.ПозицииЧека Цикл
		
		НоваяСтрока = ПозицииЧека.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПозицияЧека);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьПозицииЧекаИзXML(ПозицииЧека, ПозицииЧекаXML)
	
	Для Каждого ПозицияЧека Из ПозицииЧекаXML Цикл
		
		Если Не ПозицияЧека.Свойство("Наименование") Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ПозицииЧека.Добавить();
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ПозицияЧека);
		
		НоваяСтрока.ОператорПереводаАдрес 			= ПозицияЧека.ДанныеАгента.ОператорПеревода.Адрес;
		НоваяСтрока.ОператорПереводаИНН 			= ПозицияЧека.ДанныеАгента.ОператорПеревода.ИНН;
		НоваяСтрока.ОператорПереводаНаименование 	= ПозицияЧека.ДанныеАгента.ОператорПеревода.Наименование;
		НоваяСтрока.ОператорПереводаТелефон 		= ПозицияЧека.ДанныеАгента.ОператорПеревода.Телефон;
		
		НоваяСтрока.ОператорПоПриемуПлатежейТелефон	= ПозицияЧека.ДанныеАгента.ОператорПоПриемуПлатежей.Телефон;
		
		НоваяСтрока.ПлатежныйАгентОперация 			= ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Операция;
		НоваяСтрока.ПлатежныйАгентТелефон 			= ПозицияЧека.ДанныеАгента.ПлатежныйАгент.Телефон;
		
		НоваяСтрока.ДанныеПоставщикаИНН 			= ПозицияЧека.ДанныеПоставщика.ИНН;
		НоваяСтрока.ДанныеПоставщикаНаименование 	= ПозицияЧека.ДанныеПоставщика.Наименование;
		НоваяСтрока.ДанныеПоставщикаТелефон 		= ПозицияЧека.ДанныеПоставщика.Телефон;
		
		НоваяСтрока.НаименованиеПредметаРасчета 	= ПозицияЧека.Наименование;
		НоваяСтрока.СуммаСоСкидками 				= ПозицияЧека.Сумма;
		
		Если ПозицияЧека.СтавкаНДС = 0 Тогда
			НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Перечисления.ВидыСтавокНДС.Нулевая);
		ИначеЕсли ПозицияЧека.СтавкаНДС = 10 ИЛИ ПозицияЧека.СтавкаНДС = 110 Тогда
			НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Перечисления.ВидыСтавокНДС.Пониженная);
		ИначеЕсли ПозицияЧека.СтавкаНДС = 18 ИЛИ ПозицияЧека.СтавкаНДС = 118 Тогда
			НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Перечисления.ВидыСтавокНДС.Общая);
		ИначеЕсли ПозицияЧека.СтавкаНДС = 20 ИЛИ ПозицияЧека.СтавкаНДС = 120 Тогда
			НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Перечисления.ВидыСтавокНДС.Общая);
		Иначе
			НоваяСтрока.СтавкаНДС = Справочники.СтавкиНДС.СтавкаНДС(Перечисления.ВидыСтавокНДС.БезНДС);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли